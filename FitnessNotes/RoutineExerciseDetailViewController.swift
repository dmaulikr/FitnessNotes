//
//  RoutineExerciseDetailViewController.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/12/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import UIKit
import CoreData
import CocoaLumberjack

class RoutineExerciseDetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var moc: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController!
    
    let cellId = "ExerciseDetailCell"
    let addNewSetCellId = "AddNewSetCell"
    
    var exercise: RoutineExercise!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib.init(nibName: "RoutineExerciseDetailCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        //config the fetchResultsController
        let myDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        moc = myDelegate.coredataStack?.mainContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: RoutineExerciseSet.sortedFetchRequestWithPredicate(NSPredicate(format: "exercise = %@", exercise)), managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        _ = try? fetchedResultsController.performFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        if moc.hasChanges {
            moc.performSaveOrRollback()
        }
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


//MARK: tableViewDelegate and Datasource
extension RoutineExerciseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let objects = fetchedResultsController.fetchedObjects else { return 1 }
        return objects.count + 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if row == tableView.numberOfRowsInSection(indexPath.section)-1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(addNewSetCellId, forIndexPath: indexPath)
            cell.textLabel?.text = "Add New Set"
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! RoutineExerciseDetailTableViewCell
            cell.weightTextField.tag = row * 1000 + 1
            cell.repsTextField.tag = row * 1000 + 2
            cell.weightTextField.delegate = self
            cell.repsTextField.delegate = self
            let set = fetchedResultsController.objectAtIndexPath(indexPath) as! RoutineExerciseSet
            
            cell.configureCell(withSet: set.set.integerValue, weight: set.weight, reps: set.reps)
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.loadFromNibNamed("RoutineExerciseDetailTableViewHeader")
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1 {
            copySetAtIndexPath(indexPath)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func copySetAtIndexPath(indexPath: NSIndexPath) ->RoutineExerciseSet {
        let lastIndexPath = NSIndexPath(forRow: indexPath.row-1, inSection: indexPath.section)
        let lastSet = fetchedResultsController.objectAtIndexPath(lastIndexPath) as! RoutineExerciseSet

        let newSet = RoutineExerciseSet.insertIntoContext(moc, set: (lastSet.set.integerValue + 1), weight: lastSet.weight?.doubleValue, reps: lastSet.reps.integerValue, exercise: lastSet.exercise)
        return newSet
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            let obj = fetchedResultsController.objectAtIndexPath(indexPath) as! RoutineExerciseSet
            moc.deleteObject(obj)
        default:
            break
        }
    }
    
}

//MARK: - NSFetchedResultsControllerDelegate
extension RoutineExerciseDetailViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Move:
            break
        case .Update:
            break
        }
    }
}


extension RoutineExerciseDetailViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(RoutineExerciseDetailViewController.hideKeyboard))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(RoutineExerciseDetailViewController.hideKeyboard))
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        
        guard let val = textField.text where val != "" else {
            textField.resignFirstResponder()
            return
        }
        
        let row = textField.tag / 1000
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        let obj = fetchedResultsController.objectAtIndexPath(indexPath) as! RoutineExerciseSet
        
        if textField.tag % 1000 == 1 {
            let weight = Double(val)
            obj.weight = NSNumber(double: weight!)
        } else {
            let reps = Int(val)
            obj.reps = NSNumber(integer: reps!)
        }
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }

}
















