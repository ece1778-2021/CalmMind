//
//  BaseTabBarController.swift
//  CalmMind
//
//  Created by Jun Chen on 2021/3/18.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    var latestHeartRate : Int = 200
    var currentMoodIndex : Int = 0
    var sadSongList = ["Floating in the City", "Rising of the Dream", "Dance of Gossamer", "Dazing", "Drip Drip Drip"]
    var sadBPMList = ["100", "90", "80", "70", "60"]
    var happySongList = ["Dance of Gossamer", "Dazing", "Drip Drip Drip", "Floating in the City", "Rising of the Dream"]
    var happyBPMList = ["120", "100", "90", "75", "50"]

    override func viewDidLoad() {
        super.viewDidLoad()
//        selectedIndex = 0
        // Do any additional setup after loading the view.
    }
}
