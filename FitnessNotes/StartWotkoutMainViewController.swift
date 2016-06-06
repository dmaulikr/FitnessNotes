//
//  StartWotkoutMainViewController.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/14/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import UIKit
import CoreData

class StartWotkoutMainViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var workoutLog: WorkoutLog!
    var workoutExercise: WorkoutExercise?
    
    var moc: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController!
    
    //tableView cell Id
    let exerciseCellId = "ExerciseCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure tableview
        tableView.registerNib(UINib.init(nibName: "ExerciseTableViewCell", bundle: nil), forCellReuseIdentifier: exerciseCellId)
        self.navigationController?.toolbarHidden = false

        //config the fetchResultsController
        let myDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        moc = myDelegate.coredataStack?.mainContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: WorkoutExercise.sortedFetchRequestWithPredicate(NSPredicate(format: "workoutLog = %@", workoutLog)) , managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        _ = try? fetchedResultsController.performFetch()
        
        //barbutton
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(StartWotkoutMainViewController.leftBarButtonTapped))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBAction
    func leftBarButtonTapped() {
        moc.deleteObject(workoutLog)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func rightBarButtonTapped() {
//        if moc.hasChanges {
//            moc.performSaveOrRollback()
//        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}


extension StartWotkoutMainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            guard let objs =  fetchedResultsController.fetchedObjects else {
                return 1
            }
            return objs.count
        } else {
            return 4
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let cell: UITableViewCell
        
        if section == 0 {
            let obj = fetchedResultsController.objectAtIndexPath(indexPath) as! WorkoutExercise
            let exerciseCell = tableView.dequeueReusableCellWithIdentifier("ExerciseCell", forIndexPath: indexPath) as! ExerciseTableViewCell
            configureExerciseCell(exerciseCell, withExercise: obj)
            return exerciseCell
        } else {
            switch row {
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath)
                cell.textLabel?.text = "Note"
            case 2:
                cell = tableView.dequeueReusableCellWithIdentifier("WeightCell", forIndexPath: indexPath)
                cell.textLabel?.text = "Weight"
            case 3:
                cell = tableView.dequeueReusableCellWithIdentifier("DurationCell", forIndexPath: indexPath)
                cell.textLabel?.text = "Duration"
            case 4:
                cell = tableView.dequeueReusableCellWithIdentifier("SummaryCell", forIndexPath: indexPath)
                cell.textLabel?.text = "Summary"
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("SummaryCell", forIndexPath: indexPath)
                cell.textLabel?.text = "Summary"
            }
        }
        
        return cell
    }
    
    func configureExerciseCell(cell: ExerciseTableViewCell, withExercise exercise: WorkoutExercise) {
        guard let name = exercise.exercise?.name else { return }
        guard let sets = exercise.sets?.count else { return }
        cell.nameLabel.text = name
        cell.setsLabel.text = "\(sets) sets"
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Exercise"
        } else {
            return "Notes"
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        if section == 0 {
            performSegueWithIdentifier(SegueIdentifier.StartExerciseSegue.rawValue, sender: indexPath)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension StartWotkoutMainViewController: NSFetchedResultsControllerDelegate {
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


// MARK: - Navigation
extension StartWotkoutMainViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case StartExerciseSegue
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifierForSegue(segue) {
        case .StartExerciseSegue:
            let inexPath = sender as! NSIndexPath
            let selectObj = fetchedResultsController.objectAtIndexPath(inexPath) as! WorkoutExercise
            let exerciseSets = selectObj.sets?.map({ (set) -> WorkoutExerciseSet in
                return set as! WorkoutExerciseSet
            })
            let destVC = segue.destinationViewController as! StartWorkoutExerciseViewController
            destVC.workoutSets = exerciseSets
            break;
        }
    }
}












