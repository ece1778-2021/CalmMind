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
    var happySongList = ["Mendelssohn - Songs without Words", "Chopin - Nocturne in E Flat", "1-01 sleeping bag", "1-04 Moonlight Serenade", "Sunlight", "Ocean", "Sparkle", "1-07 Song On The Beach"]
    var happyBPMList = ["160", "110", "92", "83", "52", "44", "40", "30"]
    var happyHexList = ["#4E9245", "#5C96AA", "#212E29", "#555C48", "#5688A8", "#58648E", "#82671A", "#364129"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        selectedIndex = 0
        // Do any additional setup after loading the view.
    }
}
