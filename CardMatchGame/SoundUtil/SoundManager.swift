//
//  SoundManager.swift
//  CardMatchGame
//
//  Created by LiewSyetChau on 16/12/21.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer: AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect: SoundEffect) {
        
        var soundFileName = ""
        
        switch effect {
            
        case .flip:
            soundFileName = "cardflip"
            break
        case .match:
            soundFileName = "dingcorrect"
            break
        case .nomatch:
            soundFileName = "dingwrong"
            break
        case .shuffle:
            soundFileName = "shuffle"
            break
        }
        
        //get the path to resource
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: ".wav")
        
        //check that if not nil
        guard bundlePath != nil else {
            //could not find resource
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        do {
            //create the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            //play the audio player
            audioPlayer?.play()
            
        } catch {
            print("Could not create an audio player")
            return
        }
    }
}
