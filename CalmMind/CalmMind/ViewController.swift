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
    var lastHeartRate : Int = 0
    var latestHeartRate : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Authorizing for the HealthKit
        authorizeHealthkit()
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

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if lastHeartRate != 0 {
            animate_heart()
        }
        updateHr()
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
                        self.heartRateLabel.text = String(self.latestHeartRate + randomNum)
                    } else {
                        self.heartRateLabel.text = String(self.latestHeartRate)
                    }
                }
            }
        }
    }


}

