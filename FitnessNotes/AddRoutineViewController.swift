//
//  AddRoutineViewController.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/6/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import UIKit
import CoreData

///ViewController shows the Exercises in the Routine
class AddRoutineViewController: UIViewController {
    
    //iboutlet
    @IBOutlet var routineNameTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    //coredata
    var moc: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController?
    
    //identifier
    let addCellIdentifier = "AddExerciseCell"
    let cellIdentifier = "ExerciseCell"
    let addExerciseSegue = "AddRoutineExerciseSegue"
    let exerciseDetailSegue = "ViewRoutineExerciseSegue"
    
    
    var routine: Routine?
    
    var newExercises = Array<RoutineExercise>() {
        didSet {
            if newExercises.count == 0 {
                self.navigationItem.leftBarButtonItem?.enabled = false
            } else {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(AddRoutineViewController.saveBarButtonAction))
            }
        }
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //config the fetchResultsController
        let myDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        moc = myDelegate.coredataStack?.mainContext
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddRoutineViewController.saveExerciseToRoutine(_:)), name: "AddExerciseToRoutineNotificaton", object: nil)
        
        guard let r = routine else {//create new routine
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(AddRoutineViewController.saveBarButtonAction))
            self.navigationItem.title = "Add New Routine"
            return
        }
        
        self.navigationItem.title = r.name
        self.routineNameTextField.text = r.name
        fetchedResultsController = NSFetchedResultsController(fetchRequest: RoutineExercise.sortedFetchRequestWithPredicate(NSPredicate(format: "routine = %@", r)), managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController!.delegate = self
        _ = try? fetchedResultsController!.performFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    
    //MARK: - IBAction
    @IBAction func EditBarButtonTapped(sender: UIBarButtonItem) {
        
    }
    
    func saveBarButtonAction() {
        guard let routineName = self.routineNameTextField.text else {
            //show alert
            return
        }
        guard routineName != "" else {
            //show alert
            return
        }
        
        if routine == nil {
            Routine.insertRoutineIntoContext(moc, name: routineName, note: nil, exercises: Set(newExercises))
        }
        
        if moc.hasChanges {
            moc.performSaveOrRollback()
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveExerciseToRoutine(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let exercises = userInfo["newExercise"] as! [RoutineExercise]
        newExercises += exercises
        if let r  = routine {
            _ = newExercises.map{ (exercise) -> RoutineExercise in
                exercise.routine = r
                return exercise
            }
        }
        
        tableView.reloadData()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //TODO: init view routine exercise segue
        if segue.identifier == exerciseDetailSegue {
            let indexPath = sender as! NSIndexPath
            let destVC = segue.destinationViewController as! RoutineExerciseDetailViewController
            if routine == nil {
                destVC.exercise = newExercises[indexPath.row]
            } else {
                destVC.exercise = fetchedResultsController?.objectAtIndexPath(indexPath) as! RoutineExercise
            }
        }
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension AddRoutineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchController = fetchedResultsController else {
            return newExercises.count + 1
        }
        
        let sections = fetchController.sections
        let sectionInfo = sections![section]
        return sectionInfo.numberOfObjects + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell: UITableViewCell
        if row == tableView.numberOfRowsInSection(indexPath.section)-1 {
            cell = tableView.dequeueReusableCellWithIdentifier(addCellIdentifier, forIndexPath: indexPath)
            cell.textLabel?.text = "Add Exercise"
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            configureCell(cell, atIndexPath: indexPath)
        }
        
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let fetchController = fetchedResultsController else {
            cell.textLabel?.text = newExercises[indexPath.row].exercise.name
            return
        }
        
        let record = fetchController.objectAtIndexPath(indexPath) as! RoutineExercise
        cell.textLabel?.text = record.exercise.name
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1 {
            let exerciseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AddExerciseContainer")
            self.presentViewController(exerciseVC, animated: true, completion: nil)
        } else {
            self.performSegueWithIdentifier(exerciseDetailSegue, sender: indexPath)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            if routine == nil {
                let deleteObj = newExercises.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                moc.deleteObject(deleteObj)
            } else {
                let deleteObj = fetchedResultsController?.objectAtIndexPath(indexPath) as! RoutineExercise
                moc.deleteObject(deleteObj)
            }
            
        default:
            break
        }
    }
}


//MARK: - NSFetchedResultsControllerDelegate
extension AddRoutineViewController: NSFetchedResultsControllerDelegate {
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



























