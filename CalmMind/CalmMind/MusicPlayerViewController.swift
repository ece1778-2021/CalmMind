//
//  MusicPlayerViewController.swift
//  CalmMind
//
//  Created by Jun Chen on 2021/3/3.
//

import UIKit
import AVKit
import AVFoundation
import HealthKit

class MusicPlayerViewController: UIViewController {
    
    let healthStore = HKHealthStore()
    var audioPlayer = AVAudioPlayer()
    var currentSong: String!
    var songList = [String]()
    var bpmList = [String]()
    var currentHex = ""
    var hexList = [String]()
    var timer = Timer()
    var initial_hr = 0
    var countdown = 10
    var latestHeartRate : Int = 200
//    let largeConfig = UIImage.SymbolConfiguration(pointSize: 70, weight: .semibold, scale: .large)
    var largeConfig = UIImage.SymbolConfiguration(scale: .large)
    
    @IBOutlet var countDownLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var goodview: UIImageView!
    @IBOutlet var heartRateLabel: UILabel!
    @IBOutlet var playbackspeedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tbc = self.tabBarController as! BaseTabBarController
        
        // ??? Need to get a matched list
        songList = tbc.neutralSongList
        bpmList = tbc.neutralBPMList
        hexList = tbc.neutralHexList
        
        chooseBackgroundMusic(filename: songList[0])
        countDownLabel.text = "Calm down now..."
        countDownLabel.layer.cornerRadius = 10
        countDownLabel.layer.masksToBounds = true
        
        currentHex = hexList[0]
        view.backgroundColor = hexStringToUIColor(hex: hexList[0], add_rgb: 0)
        goodview.image = UIImage(named: hexList[0])
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//       updateHr()
//        heartRateLabel.text = String(latestHeartRate)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hexStringToUIColor (hex:String, add_rgb: CGFloat) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0 + add_rgb,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0 + add_rgb,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0 + add_rgb,
            alpha: CGFloat(1.0)
        )
    }
    
    func chooseBackgroundMusic(filename: String) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            
            // Repeating the list for 20 times by default
            audioPlayer.numberOfLoops = 20
            audioPlayer.enableRate = true
//            audioPlayer.rate = 1.0
            audioPlayer.volume = 0.2
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
    
    // Alert message helper function
    func sendAlert(alertMsg: String) {
        let alertController = UIAlertController(title: "Time is up", message: alertMsg, preferredStyle: .alert)
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
        playButton.setImage(UIImage(systemName: "play", withConfiguration: largeConfig), for: .normal)
        sendAlert(alertMsg: "Music has stopped..")
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        
        animateClickButton(click_button: self.playButton)
        
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            playButton.setImage(UIImage(systemName: "play", withConfiguration: largeConfig), for: .normal)
            print("pausing")
        } else {
            audioPlayer.play()
            print("playing")
            countDownLabel.text = "Calm down now..."
            playButton.setImage(UIImage(systemName: "pause", withConfiguration: largeConfig), for: .normal)
        }
    }
    
    @IBAction func restartButtonAction(_ sender: Any) {
        
        animateClickButton(click_button: self.restartButton)
        
        if audioPlayer.isPlaying {
            audioPlayer.currentTime = 0
            audioPlayer.play()
            playButton.setImage(UIImage(systemName: "pause", withConfiguration: largeConfig), for: .normal)
        } else {
            audioPlayer.play()
            playButton.setImage(UIImage(systemName: "pause", withConfiguration: largeConfig), for: .normal)
        }
        countDownLabel.text = "Calm down now..."
    }
    
    @IBAction func lastButtonAction(_ sender: Any) {
        
        animateClickButton(click_button: self.lastButton)
        
        let indexOfSong = songList.firstIndex(of: currentSong)
        let nextSongIndex = (indexOfSong! - 1 + songList.count) % songList.count
        let nextSong = songList[nextSongIndex]
        
        animateChangeImageView(songName: nextSong)
        chooseBackgroundMusic(filename: nextSong)
        audioPlayer.play()
        playButton.setImage(UIImage(systemName: "pause", withConfiguration: largeConfig), for: .normal)
        countDownLabel.text = "Calm down now..."
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        animateClickButton(click_button: self.nextButton)
        
        let indexOfSong = songList.firstIndex(of: currentSong)
        let nextSongIndex = (indexOfSong! + 1) % songList.count
        let nextSong = songList[nextSongIndex]
        
        animateChangeImageView(songName: nextSong)
        chooseBackgroundMusic(filename: nextSong)
        audioPlayer.play()
        playButton.setImage(UIImage(systemName: "pause", withConfiguration: largeConfig), for: .normal)
        countDownLabel.text = "Calm down now..."
    }
    
    func setTimerAction(action: UIAlertAction) {
        var duration = 0.0
        
        if action.title! == "5 seconds" {
            duration = 5
        } else if action.title! == "10 minutes" {
            duration = 600
        } else if action.title! == "20 minutes" {
            duration = 1200
        } else if action.title! == "30 minutes" {
            duration = 1800
        } else if action.title! == "60 minutes" {
            duration = 3600
        } else {
            print("error")
            return
        }
        
        if audioPlayer.isPlaying {
            creatTimer(duration: duration)

            countdown = Int(duration)
            countDownLabel.text = "Music will stop in " + String(countdown) + " seconds"
            
            // Set up the count down
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                if self.countdown > 0 {
                    self.countdown -= 1
                    self.countDownLabel.text = "Music stops in " + String(self.countdown) + " seconds"
                } else {
                    Timer.invalidate()
                    self.countDownLabel.text = "Go to sleep now..."
                }
            }
        } else {
            sendAlert(alertMsg: "Music is not playing")
        }
    }
    
    @IBAction func setTimerAction(_ sender: Any) {
        animateClickButton(click_button: self.timerButton)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "5 seconds", style: .default, handler: setTimerAction))
        alert.addAction(UIAlertAction(title: "10 minutes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "20 minutes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "30 minutes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "60 minutes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    
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
//        let nextSongIndex = (indexOfSong! + 1) % songList.count
        
        UIView.animate(withDuration: 0.2, animations: {
            self.goodview.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        },
        completion: { done in
            if done {
                self.goodview.image = UIImage(named: self.hexList[indexOfSong!])
                self.view.backgroundColor = self.hexStringToUIColor(hex: self.hexList[indexOfSong!], add_rgb: 0)
                self.currentHex = self.hexList[indexOfSong!]
                self.goodview.transform = CGAffineTransform.identity
            }
        })
    }
    
    @IBAction func musicLibraryAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MLvc") as! MusicLibraryViewController
        controller.delegate = self
        controller.songList = songList
        controller.bpmList = bpmList
        controller.hexList = hexList
        controller.backColor = hexStringToUIColor(hex: currentHex, add_rgb: CGFloat(0.2))
        self.present(controller, animated: true, completion: nil)
    }

}

extension MusicPlayerViewController: ChangeSongDelegate {
    
    func changeSong(songName: String) {
        self.dismiss(animated: true) {
            print("came back!")
            self.chooseBackgroundMusic(filename: songName)
            self.animateChangeImageView(songName: songName)
            self.audioPlayer.play()
            self.playButton.setImage(UIImage(systemName: "pause", withConfiguration: self.largeConfig), for: .normal)
            self.countDownLabel.text = "Calm down now..."
        }
    }
    
}
