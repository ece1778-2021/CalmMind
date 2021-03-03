//
//  MusicPlayerViewController.swift
//  CalmMind
//
//  Created by Jun Chen on 2021/3/3.
//

import UIKit
import AVKit
import AVFoundation

class MusicPlayerViewController: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "song1", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            // Repeating the list for 20 times by default
            audioPlayer.numberOfLoops = 20
        }
        catch {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        
        animateClickButton(click_button: self.playButton)
        
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            print("pausing")
        } else {
            audioPlayer.play()
            print("playing")
        }
    }
    
    @IBAction func restartButtonAction(_ sender: Any) {
        
        animateClickButton(click_button: self.restartButton)
        
        if audioPlayer.isPlaying {
            audioPlayer.currentTime = 0
            audioPlayer.play()
        } else {
            audioPlayer.play()
        }
    }
    
    // Animate the button when the user clicks on it
    func animateClickButton(click_button: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            click_button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
        completion: { done in
            if done {
                click_button.transform = CGAffineTransform.identity
            }
        })
    }
}
