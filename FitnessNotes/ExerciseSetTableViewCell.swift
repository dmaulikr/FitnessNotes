//
//  ExerciseSetTableViewCell.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/17/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import UIKit

class ExerciseSetTableViewCell: UITableViewCell {
    
    @IBOutlet var setLabel: UILabel!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var repsTextField: UITextField!
    @IBOutlet var checkmarkButton: UIButton!
    
    var workoutSet: WorkoutExerciseSet!
    var setFinishMark: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        weightTextField.delegate = self
        repsTextField.delegate = self
    }
    
    func configureCellWithSet(set: WorkoutExerciseSet) {
        self.workoutSet = set
        setFinishMark = workoutSet.finishFlag.boolValue
        
        self.setLabel.text = "\(set.set.integerValue)"
        if let weight = set.weight?.doubleValue {
            self.weightTextField.text = "\(weight)"
        } else {
            self.weightTextField.text = nil
        }
        self.repsTextField.text = "\(set.reps.integerValue)"
        
        if set.finishFlag.boolValue {
            checkmarkButton.setImage(UIImage(named: "Checkmark.png"), forState: .Normal)
        } else {
            checkmarkButton.setImage(UIImage(named: "Multiply.png"), forState: .Normal)
        }

    }
    
    @IBAction func checkmarkButtonTapped(sender: UIButton) {
        setFinishMark = !setFinishMark!
        workoutSet.finishFlag = NSNumber(bool:setFinishMark!)
        if setFinishMark! {
            checkmarkButton.setImage(UIImage(named: "Checkmark.png"), forState: .Normal)
        } else {
            checkmarkButton.setImage(UIImage(named: "Multiply.png"), forState: .Normal)
        }
    }
}

extension ExerciseSetTableViewCell: UITextFieldDelegate {
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let weight = weightTextField.text {
            workoutSet.weight = NSNumber(double: Double(weight) ?? 0)
        }
        
        if let reps = repsTextField.text {
            workoutSet.reps = NSNumber(integer: Int(reps) ?? 0)
        }
    }
}
