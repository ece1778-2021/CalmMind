//
//  ViewController.swift
//  CalmMind
//
//  Created by KYLE on 2021-02-24.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    @IBOutlet var heartLogo: UIImageView!
    @IBOutlet var heartRateLabel: UILabel!
    @IBOutlet var moodLogo: UIImageView!
    @IBOutlet var moodLabel: UILabel!
    @IBOutlet var mytableView: UITableView!
    @IBOutlet var demoSwitch: UISwitch!
    
    let healthStore = HKHealthStore()
    var lastHeartRate : Int = 0
    var latestHeartRate : Int = 0
    let moodArray = ["Happy", "Sad", "Neutral"]
    let moodImageArray = ["happy-icon", "sad-icon", "crazy-icon"]
    var songList = [String]()
    var bpmList = [String]()
    var hexList = [String]()
    var isDemoOn = false
    var demoHeartRateArray = [100, 90, 80, 70, 60, 50]
    var playbackspeedArray = [1.0, 0.95, 0.9, 0.85, 0.8, 0.7]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Preload all views in tabbar controller
        self.tabBarController!.viewControllers?.forEach { let _ = $0.view }
        
        // Authorizing for the HealthKit
        authorizeHealthkit()
        
        // Change and display mood
        let tbc = self.tabBarController as! BaseTabBarController
//        var secondTab = (self.tabBarController?.viewControllers![1])! as! MusicPlayerViewController
        
        moodLabel.text = "You feel " + moodArray[tbc.currentMoodIndex] + " now"
        moodLogo.image = UIImage(named: moodImageArray[tbc.currentMoodIndex])
        // Get first 5 tracks
        // ??? Need to get a matched list
        if tbc.currentMoodIndex == 0 {
            songList = Array(tbc.happySongList[0...2])
            bpmList = Array(tbc.happyBPMList[0...2])
            hexList = Array(tbc.happyHexList[0...2])
        } else if tbc.currentMoodIndex == 1 {
            songList = Array(tbc.sadSongList[0...2])
            bpmList = Array(tbc.sadBPMList[0...2])
            hexList = Array(tbc.sadHexList[0...2])
        } else {
            songList = Array(tbc.neutralSongList[0...2])
            bpmList = Array(tbc.neutralBPMList[0...2])
            hexList = Array(tbc.neutralHexList[0...2])
        }
        
        // Parse heart rate and update label
        let queue = DispatchQueue(label: "maintenance", qos: .utility)
        queue.async {
            while true {
                if self.isDemoOn {
                    for (i, demoCurrentHr) in self.demoHeartRateArray.enumerated() {
                        
                        
                        if !self.isDemoOn {
                            break
                        }
                        self.updateHrDemoMode(demoCurrentHr: demoCurrentHr, demoCurrentPBS: self.playbackspeedArray[i])
                        sleep(2)
                    }
                    
                } else {
                    self.updateHr()
                    sleep(2)
                }
                tbc.latestHeartRate = self.latestHeartRate
            }
        }
        
        // Animating the heart image view
        animate_heart()
        
        let nib = UINib(nibName: "MyTableViewCell", bundle: nil)
        mytableView.register(nib, forCellReuseIdentifier: "MyTableViewCell")
        mytableView.delegate = self
        mytableView.dataSource = self
        
        demoSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        
        
        
    }
    
    @objc func stateChanged(switchState: UISwitch) {
        if demoSwitch.isOn {
            isDemoOn = true
        } else {
            isDemoOn = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if lastHeartRate != 0 {
            animate_heart()
        }
        if !self.isDemoOn {
            updateHr()
        }
    }
    
    @IBAction func changeMoodAction(_ sender: Any) {
        
        // Stop the music
        let secondTab = (self.tabBarController?.viewControllers![1])! as! MusicPlayerViewController
        secondTab.audioPlayer.stop()
        
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

                self.heartRateLabel.text = String(self.latestHeartRate) + " bpm"
                let secondTab = (self.tabBarController?.viewControllers![1])! as! MusicPlayerViewController
                secondTab.latestHeartRate = self.latestHeartRate
                secondTab.heartRateLabel.text = String(self.latestHeartRate)
                secondTab.playbackspeedLabel.text = String(1.0)
                secondTab.audioPlayer.rate = Float(1.0)
            }
        }
    }
    
    func updateHrDemoMode(demoCurrentHr: Int, demoCurrentPBS: Double) {
        
        let hrQueue = DispatchQueue(label: "Getting latest hr", attributes: .concurrent)
        hrQueue.async {
            self.latestHeartRate = demoCurrentHr
            
            DispatchQueue.main.async {
                self.heartRateLabel.text = String(self.latestHeartRate) + " bpm"
                let secondTab = (self.tabBarController?.viewControllers![1])! as! MusicPlayerViewController
                secondTab.latestHeartRate = self.latestHeartRate
                secondTab.heartRateLabel.text = String(self.latestHeartRate)
                secondTab.playbackspeedLabel.text = String(demoCurrentPBS)
                secondTab.audioPlayer.rate = Float(demoCurrentPBS + 0.1)
            }
            
        }
    }


}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
        tableView.deselectRow(at: indexPath, animated: true)
        print(songList[indexPath.row], bpmList[indexPath.row])
        
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        // ???
        cell.imageview.image = UIImage(named: hexList[indexPath.row])
        cell.songnameLabel.text = songList[indexPath.row]
        cell.songnameLabel?.font = UIFont(name: "Helvetica", size: 18)
        cell.bpmLabel.text = " " + bpmList[indexPath.row] + " BPM "
        cell.bpmLabel?.font = UIFont(name: "Helvetica", size: 16)
        return cell
        
    }
}
