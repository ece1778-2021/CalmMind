//
//  BaseTabBarController.swift
//  CalmMind
//
//  Created by Jun Chen on 2021/3/18.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    var profilePageImageArray = [UIImage]()
    var profilePostTimestampArray = [String]()
    var feedPageImageArray = [UIImage]()
    var feedPostTimestampArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 1
        // Do any additional setup after loading the view.
    }
}
