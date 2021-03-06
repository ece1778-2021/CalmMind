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
    var currentSong: String!
    var songList = ["song1", "song2", "song3"]
    var imageList = ["galaxy", "sunset", "river"]
    var timer = Timer()
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var goodview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playBackgroundMusic(filename: "song1")
    }
    
    func playBackgroundMusic(filename: String) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            // Repeating the list for 20 times by default
            audioPlayer.numberOfLoops = 20
            currentSong = filename
        }
        catch {
            print(error)
        }
        
        // Setting of playing in the background when the screen is locked
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Alert message helper function
    func sendAlert(alertMsg: String) {
        let alertController = UIAlertController(title: "Kind reminds", message: alertMsg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Set timer for excuting fireTimer() function
    func creatTimer(duration: Double) {
        timer = Timer.scheduledTimer(
            timeInterval: duration,
            target: self,
            selector: #selector(fireTimer),
            userInfo: nil,
            repeats: false
        )
    }
    
    // Execute the commands when time is up
    @objc func fireTimer() {
        audioPlayer.stop()
        sendAlert(alertMsg: "Time's up, music has stopped..")
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
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        animateClickButton(click_button: self.nextButton)
        
        let indexOfSong = songList.firstIndex(of: currentSong)
        let nextSongIndex = (indexOfSong! + 1) % songList.count
        let nextSong = songList[nextSongIndex]
        
        animateChangeImageView(songName: nextSong)
        playBackgroundMusic(filename: nextSong)
        audioPlayer.play()
    }
    
    @IBAction func setTimerAction(_ sender: Any) {
        animateClickButton(click_button: self.timerButton)
        
        creatTimer(duration: 5)
        
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
    
    // Animate the image view when the user changes song
    func animateChangeImageView(songName: String) {
        
        let indexOfSong = songList.firstIndex(of: songName)
        let nextSongIndex = (indexOfSong! + 1) % songList.count
        
        UIView.animate(withDuration: 0.2, animations: {
            self.goodview.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        },
        completion: { done in
            if done {
                self.goodview.image = UIImage(named: self.imageList[nextSongIndex])
                self.goodview.transform = CGAffineTransform.identity
            }
        })
    }
    
    @IBAction func musicLibraryAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MLvc") as! MusicLibraryViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
}

extension MusicPlayerViewController: ChangeSongDelegate {
    
    func changeSong(songName: String) {
        self.dismiss(animated: true) {
            print("came back!")
            self.playBackgroundMusic(filename: songName)
            self.animateChangeImageView(songName: songName)
            self.audioPlayer.play()
        }
    }
    
}
