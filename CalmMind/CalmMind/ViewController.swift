//
//  ViewController.swift
//  CalmMind
//
//  Created by KYLE on 2021-02-24.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    let healthStore = HKHealthStore()
    @IBOutlet var heartLogo: UIImageView!
    @IBOutlet var heartRateLabel: UILabel!
    @IBOutlet var moodLogo: UIImageView!
    @IBOutlet var moodLabel: UILabel!
    @IBOutlet var mytableView: UITableView!
    var lastHeartRate : Int = 0
    var latestHeartRate : Int = 0
    let moodArray = ["Happy", "Angry", "Sad", "Crazy"]
    let moodImageArray = ["happy-icon", "angry-icon", "sad-icon", "crazy-icon"]
    var songList = [String]()
    var bpmList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Authorizing for the HealthKit
        authorizeHealthkit()
        
        // Change and display mood
        let tbc = self.tabBarController as! BaseTabBarController
        moodLabel.text = "You feel " + moodArray[tbc.currentMoodIndex] + " now"
        moodLogo.image = UIImage(named: moodImageArray[tbc.currentMoodIndex])
        songList = tbc.happySongList
        bpmList = tbc.happyBPMList
        
        // Parse heart rate
        let queue = DispatchQueue(label: "maintenance", qos: .utility)
        queue.async {
            while true {
                self.updateHr()
                sleep(2)
            }
        }
        
        // Animating the heart image view
        animate_heart()
        
        let nib = UINib(nibName: "MyTableViewCell", bundle: nil)
        mytableView.register(nib, forCellReuseIdentifier: "MyTableViewCell")
        mytableView.delegate = self
        mytableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if lastHeartRate != 0 {
            animate_heart()
        }
        updateHr()
    }
    
    @IBAction func changeMoodAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "mood_vc") as! moodViewController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
        
    }
    
    // Heart animation part1: Enlarge the heart image
    func animate_heart() {
        UIView.animate(withDuration: 0.6, animations: {
            self.heartLogo.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
        completion: { done in
            if done {
                self.shrink_heart()
            }
        })
    }
    
    // Heart animation part2: Shrink the heart image
    func shrink_heart() {
        UIView.animate(withDuration: 0.6, animations: {
            self.heartLogo.transform = CGAffineTransform.identity
        },
        completion: { done in
            if done {
                self.animate_heart()
            }
        })
    }
    
    // Authorization for the HealthKit
    func authorizeHealthkit() {
        let read = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        let share = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        healthStore.requestAuthorization(toShare: share, read: read) { (chk, error) in
            if (chk) {
                print("permission granted")
            }
        }
    }
    
    // Alert message helper function
    func sendAlert(alertMsg: String) {
        let alertController = UIAlertController(title: "Error", message: alertMsg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Parsing the latest heart rate from HealthKit
    func getLatestHeartRate() {
        
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
        let startDate = Calendar.current.date(byAdding: .hour, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            guard error == nil else {
                return
            }
            
            // If no bpm recorded
            if result?.count == 0 {
                self.sendAlert(alertMsg: "No heart rate recorded in Health App")
            }
            let data = result![0] as! HKQuantitySample
            let unit = HKUnit(from: "count/min")
            let latestHr = data.quantity.doubleValue(for: unit)
            self.lastHeartRate = self.latestHeartRate
            self.latestHeartRate = Int(latestHr)
            
        }
        
        healthStore.execute(query)
    }
    
    // Update the latest heart rate on the Label
    func updateHr() {
        let hrQueue = DispatchQueue(label: "Getting latest hr", attributes: .concurrent)
        hrQueue.async {
            self.getLatestHeartRate()
            
            DispatchQueue.main.async {
                if self.latestHeartRate != 0 {
                    if self.lastHeartRate == self.latestHeartRate{
                        let randomNum = Int(arc4random_uniform(0))
                        self.heartRateLabel.text = String(self.latestHeartRate + randomNum) + " bpm"
                    } else {
                        self.heartRateLabel.text = String(self.latestHeartRate) + " bpm"
                    }
                }
            }
        }
    }


}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
        tableView.deselectRow(at: indexPath, animated: true)
//        self.delegate?.changeSong(songName: songList[indexPath.row])
//        self.dismiss(animated: true, completion: nil)
        
        print(songList[indexPath.row], bpmList[indexPath.row])
        
//        (self.tabBarController!.viewControllers![0] as! MusicPlayerViewController).audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: "mp3")!))
//        audioPlayer.prepareToPlay()
//        
//        // Repeating the list for 20 times by default
//        audioPlayer.numberOfLoops = 20
//        audioPlayer.enableRate = true
//        audioPlayer.rate = 2
//        audioPlayer.volume = 1
//        currentSong = filename
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        // ???
        cell.songnameLabel.text = songList[indexPath.row]
        cell.songnameLabel?.font = UIFont(name: "Helvetica", size: 18)
        cell.bpmLabel.text = " " + bpmList[indexPath.row] + " BPM "
        cell.bpmLabel?.font = UIFont(name: "Helvetica", size: 16)
        return cell
        
    }
}
