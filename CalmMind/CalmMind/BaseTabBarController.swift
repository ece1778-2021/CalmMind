//
//  BaseTabBarController.swift
//  CalmMind
//
//  Created by Jun Chen on 2021/3/18.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    var latestHeartRate : Int = 0
    var currentMoodIndex : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 1
        // Do any additional setup after loading the view.
    }
}

//extension BaseTabBarController: UpdateMoodDelegate {
//
//    func UpdateMood(currentMoodIndex: Int) {
//        self.dismiss(animated: true) {
//            
//            self.currentMoodIndex = currentMoodIndex
//            
//            
//        }
//    }
//}
