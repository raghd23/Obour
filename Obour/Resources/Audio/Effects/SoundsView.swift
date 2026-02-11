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
    // Players for different sounds
    private var backgroundPlayer: AVAudioPlayer?
    private var firePlayer: AVAudioPlayer?
    private var boilingPlayer: AVAudioPlayer?
    private var ghostPlayer: AVAudioPlayer?
    private var cardPlayer: AVAudioPlayer?
    
    //Treats sounds name as strings
    enum SoundOption: String{
        case card
        case ghostBase
        case ghostCloseUp
        case boiling
        case fire
        case soundDesign
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
    // MARK: - General Sound Player
     private func play(soundName: String, loop: Bool = false) -> AVAudioPlayer? {
         guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
             print("Sound \(soundName) not found")
             return nil
         }
         
         do {
             let player = try AVAudioPlayer(contentsOf: url)
             if loop {
                 player.numberOfLoops = -1 // Loop forever
             }
             player.play()
             return player
         } catch {
             print("Error playing sound \(soundName): \(error.localizedDescription)")
             return nil
         }
     }
     
     // MARK: - Public Functions
     func playBackgroundMusic() {
         if backgroundPlayer == nil || backgroundPlayer?.isPlaying == false {
             backgroundPlayer = play(soundName: SoundOption.soundDesign.rawValue, loop: true)
         }
     }
     
     func stopBackgroundMusic() {
         backgroundPlayer?.stop()
         backgroundPlayer = nil
     }
     
     func playCardSound() {
         cardPlayer = play(soundName: SoundOption.card.rawValue)
     }
     
     func playFireSound() {
         firePlayer = play(soundName: SoundOption.fire.rawValue)
     }
     
     func playBoilingSound() {
         boilingPlayer = play(soundName: SoundOption.boiling.rawValue)
     }
     
     func playGhostSound() {
         // Placeholder: you can change to ghostBase or ghostCloseUp later
         ghostPlayer = play(soundName: SoundOption.ghostBase.rawValue)
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
            Button("Play Background Music") {
                SoundManger.instance.playBackgroundMusic()
            }
            
            Button("Stop Background Music") {
                SoundManger.instance.stopBackgroundMusic()
            }
            
            Button("Play Card Sound") {
                SoundManger.instance.playCardSound()
                HapticManger.instance.impact(style: .heavy)
            }
            
            Button("Play Fire Sound") {
                SoundManger.instance.playFireSound()
            }
            
            Button("Play Boiling Sound") {
                SoundManger.instance.playBoilingSound()
            }
            
            Button("Play Ghost Sound") {
                SoundManger.instance.playGhostSound()
            }
        }
    }
}

#Preview {
    SoundsView()
}
