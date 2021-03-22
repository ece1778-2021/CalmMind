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
    var sadSongList = ["Music 1", "Music 2", "Music 3"]
    var sadBPMList = ["80", "70", "60"]
    var happySongList = ["Music 3", "Music 2", "Music 1"]
    var happyBPMList = ["90", "75", "50"]

    override func viewDidLoad() {
        super.viewDidLoad()
//        selectedIndex = 0
        // Do any additional setup after loading the view.
    }
}
