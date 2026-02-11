//
//  TestSounds.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//

import SwiftUI
//Come in hand for playing audio and video
import AVKit

class SoundManger{
    //Initialize once for the whole app. Reusable for the app. (Singleton here or anywhere else)
    static let instance = SoundManger()
    
    //Variable that holdes AVAudioPlayer. It plays music.
    var player: AVAudioPlayer?
    
    //Treats sounds name as strings
    enum SoundOption: String{
        case card
        case ghostBase
    }
    
    func playSound(sound: SoundOption){
        //If it could fetch get the url, just return.
        //Bundle of the app.
        guard let url = Bundle.main.url(forResource: sound.rawValue , withExtension: ".mp3") else { return }
        
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error{
            print("Error playing sound \(error.localizedDescription)")
        }
    }
}

class HapticManger{
    //(Singleton here or anywhere else)
    static let instance = HapticManger()

    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle){
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()

    }
}


struct SoundsView: View {
    var body: some View {
        VStack(spacing: 40){
            Button("Play Sound 1"){
                SoundManger.instance.playSound(sound: .card)
                HapticManger.instance.impact(style: .heavy)
            }
            Button("Play Sound 2"){
                SoundManger.instance.playSound(sound: .ghostBase)
                HapticManger.instance.impact(style: .medium)
                
            }
        }
    }
}

#Preview {
    SoundsView()
}
