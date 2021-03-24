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
    var sadSongList = ["RÃªverie, L. 68_ Reverie", "Calm", "1-01 Unbraiding the Sun"]
    var sadBPMList = ["68", "54", "49"]
    var sadHexList = ["#414510", "#626932", "#907717"]
    var happySongList = ["Mendelssohn - Songs without Words", "Chopin - Nocturne in E Flat", "1-01 sleeping bag", "1-04 Moonlight Serenade", "Sunlight", "Ocean", "Sparkle", "1-07 Song On The Beach"]
    var happyBPMList = ["160", "110", "92", "83", "52", "44", "40", "30"]
    var happyHexList = ["#948786", "#5C96AA", "#212E29", "#555C48", "#5688A8", "#58648E", "#82671A", "#364129"]
    var neutralSongList = ["Mendelssohn - Songs without Words", "Chopin - Nocturne in E Flat", "1-01 sleeping bag", "1-04 Moonlight Serenade", "RÃªverie, L. 68_ Reverie", "Calm", "Sunlight", "1-01 Unbraiding the Sun", "Ocean", "Sparkle", "1-07 Song On The Beach"]
    var neutralBPMList = ["160", "110", "92", "83", "68", "54", "52", "49", "44", "40", "30"]
    var neutralHexList = ["#948786", "#5C96AA", "#212E29", "#555C48", "#414510", "#626932", "#5688A8", "#907717", "#58648E", "#82671A", "#364129"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        selectedIndex = 0
        // Do any additional setup after loading the view.
    }
}
