//
//  ContentView.swift
//  AzanApp
//
//  Created by Shazia Vohra on 2023-11-10.
//

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
    var body: some View {
        VStack (spacing: 40){
            Button("Adhan"){
                SoundManager.instance.playAdhan()
            }
            Text("\(getTime(date: currentDate))")
                .onAppear(perform: {
                    let _ = self.updateTime
                })
        }
        .padding()
    }
    
    func getTime(date: Date) -> String{
        let dateFormat = DateFormatter()
        dateFormat.timeStyle = .long
        return dateFormat.string(from: Date())
    }
    var updateTime: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in self.currentDate = Date() })
    }
}

#Preview {
    ContentView()
}
