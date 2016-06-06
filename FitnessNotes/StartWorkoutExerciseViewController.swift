//
//  StartWorkoutExerciseViewController.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/17/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import UIKit

class StartWorkoutExerciseViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let workoutSetCellId = "WorkoutSetsCell"
    
    var workoutSets: Array<WorkoutExerciseSet>!

    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: "ExerciseSetTableViewCell", bundle: nil), forCellReuseIdentifier: workoutSetCellId)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StartWorkoutExerciseViewController.keyboardDidShow), name: UIKeyboardDidShowNotification, object: nil)
        self.navigationController?.toolbarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action
    func keyboardDidShow() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(StartWorkoutExerciseViewController.cancelBarButtonTapped))
    }
    
    func cancelBarButtonTapped() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.view.endEditing(true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


//MARK: UITableViewDelegate, UITableViewDataSource
extension StartWorkoutExerciseViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return workoutSets.count
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            let set = workoutSets[row]
            let cell = tableView.dequeueReusableCellWithIdentifier(workoutSetCellId, forIndexPath: indexPath) as! ExerciseSetTableViewCell
            
            cell.configureCellWithSet(set)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("noteHolder", forIndexPath: indexPath)
            cell.textLabel?.text = "note"
            return cell
        }
    }
    
//    func configureCell(cell: ExerciseSetTableViewCell, withSet set: WorkoutExerciseSet) {
//        cell.setLabel.text = "\(set.set.integerValue)"
//        if let weight = set.weight?.doubleValue {
//            cell.weightTextField.text = "\(weight) lbs"
//        } else {
//            cell.weightTextField.text = nil
//        }
//        cell.repsTextField.text = "\(set.reps.integerValue)"
//        
//        if set.finishFlag.boolValue {
//           cell.checkmarkButton.imageView?.image = UIImage(named: "Checkmark.png")
//        } else {
//            cell.checkmarkButton.imageView?.image = UIImage(named: "Multiply.png")
//        }
//    }
//    
}























