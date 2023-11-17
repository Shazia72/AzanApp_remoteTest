//  Created by Shazia Vohra on 2023-11-10.

import SwiftUI
import AVKit

class SoundManager {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    func playAdhan() {
        guard let url = Bundle.main.url(forResource: "adhan", withExtension: ".mp3") else {return}
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        }catch let error{
            print("error in playing sound \(error.localizedDescription)")
        }
    }
}
struct ContentView: View {
    @State var currentDate = Date()
    @State private var adhanApi : AdanApiData?
    @State var azanTime = ""
     
    var body: some View {
        VStack (spacing: 30) {
            Text("Adhan App").font(Font.custom("My font", size: 40))
            Button("click here to Listen Adhan"){
                SoundManager.instance.playAdhan()
            }
            Text("\(getTime(date: currentDate))").bold()
                .onAppear(perform: {
                    let _ = self.updateTime
                })
            Text("Fajar Adhan Time \(adhanApi?.data.timings.fajr ?? "Fajar")")
            Text("Dhuhr Adhan Time \(adhanApi?.data.timings.dhuhr ?? "Dhuhr")")
            Text("Asr Adhan Time \(adhanApi?.data.timings.asr ?? "Asr")")
            Text("Maghrib Adhan Time \(adhanApi?.data.timings.maghrib ?? "Maghrib")")
            Text("Isha Adhan Time \(adhanApi?.data.timings.isha ?? "Isha")")
            
            if adhanApi?.data.timings.fajr == getFormattedTime(){
                Text("Adhan-e-Fajar").onAppear(){
                    SoundManager.instance.playAdhan()
                }
            }
            if adhanApi?.data.timings.dhuhr == getFormattedTime(){
                Text("Adhan-e-Dhuhr ").onAppear(){
                    SoundManager.instance.playAdhan()
                }
            }
            if adhanApi?.data.timings.asr == getFormattedTime(){
                Text("Adhan-e-Asr").onAppear(){
                    SoundManager.instance.playAdhan()
                }
            }
            if adhanApi?.data.timings.maghrib == getFormattedTime(){
                Text("Adhan-e-Maghrib").onAppear(){
                    SoundManager.instance.playAdhan()
                }
            }
            if adhanApi?.data.timings.isha == getFormattedTime(){
                Text("Adhan-e-Isha").onAppear(){
                    SoundManager.instance.playAdhan()
                }
            }
        }
        .padding()
        .task {
            do{
                adhanApi = try await getAzan()
            }catch{
                
            }
        }
    }
    
    func getFormattedTime() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let formattedTime = formatter.string(from: Date())
        return formattedTime
    }
    
    func getTime(date: Date) -> String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd hh:mm:ss"
        return dateFormat.string(from: Date())
        
    }
    var updateTime: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in self.currentDate = Date() })
    }
    
    func getAzan() async throws -> AdanApiData{
        let today = getTime(date: Date())
        let endpoint = "https://api.aladhan.com/v1/timingsByAddress/\(today)?school=1&address=214 Markham Rd, Scarborough, ON M1J 3C2"
        
        guard let url = URL(string: endpoint) else {throw AdhanError.invalidResponse}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200
        else {throw AdhanError.invalidResponse}
        
        return try! JSONDecoder().decode(AdanApiData.self, from: data)
    }
}
enum AdhanError: Error{
    case invalidUrl
    case invalidResponse
}
#Preview {
    ContentView()
}
