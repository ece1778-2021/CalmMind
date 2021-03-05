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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
