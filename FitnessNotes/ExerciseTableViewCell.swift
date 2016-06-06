//
//  ExerciseTableViewCell.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/17/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var setsLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
