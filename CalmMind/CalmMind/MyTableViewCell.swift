//
//  MyTableViewCell.swift
//  CalmMind
//
//  Created by Jun Chen on 2021/3/5.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    @IBOutlet var imageview: UIImageView!
    @IBOutlet var songnameLabel: UILabel!
    @IBOutlet var bpmLabel: UILabel!
    @IBOutlet weak var bestMatchIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        bpmLabel.layer.backgroundColor = UIColor.blue.cgColor
        bpmLabel.layer.cornerRadius = 5
        bpmLabel.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
