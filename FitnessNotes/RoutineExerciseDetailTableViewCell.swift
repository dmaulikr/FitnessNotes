//
//  RoutineExerciseDetailTableViewCell.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/12/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import UIKit

class RoutineExerciseDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet var setLabel: UILabel!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var repsTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(withSet set: NSNumber, weight: NSNumber?, reps: NSNumber) {
        setLabel.text = String(set.integerValue)
        repsTextField.text = String(reps.integerValue)
        guard let w = weight else { return }
        weightTextField.text = String(w.doubleValue)
    }

}
