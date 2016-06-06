//
//  AddWorkOutViewController.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/4/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import UIKit
import CocoaLumberjack
import CoreData

class AddWorkOutViewController: UIViewController {
    
    @IBOutlet var workoutDatePicker: UIDatePicker!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var freeWorkoutButton: UIButton!
    
    var moc: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController!

    override func viewDidLoad() {
        super.viewDidLoad()

        //config the fetchResultsController
        let myDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        moc = myDelegate.coredataStack?.mainContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: Routine.sortedFetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        _ = try? fetchedResultsController.performFetch()
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segueIdentifierForSegue(segue) {
        case .ViewRoutineSegue:
            break;
        case .StartWorkOutSegue:
            break;
        case .FreeWorkoutSegue:
            break;
        }
    }
    
    
    
    //MARK: - IBActions
    
    @IBAction func freeWorkoutButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func RoutinesBarButtonTapped(sender: UIBarButtonItem) {
        performSegueWithIdentifier(SegueIdentifier.ViewRoutineSegue.rawValue, sender: self)
    }
    
    
    
}



//MARK: - UITableViewDelegate, UITableViewDataSource
extension AddWorkOutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numOfSection = 0
        
        let records = fetchedResultsController.fetchedObjects
        
        if records == nil || records?.count == 0 {
            let emptyLabel = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
            emptyLabel.numberOfLines = 0
            emptyLabel.text = "No Routine Created, Please Select Free Workout or Click the Routine Button to Create Your New Routine"
            emptyLabel.textColor =  UIColor.blackColor()
            emptyLabel.textAlignment = .Center
            tableView.backgroundView = emptyLabel
            tableView.separatorStyle = .None
        } else {
            tableView.separatorStyle = .SingleLine
            tableView.backgroundView = nil
            numOfSection = 1
        }
        
        return numOfSection
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = fetchedResultsController.sections
        let sectionInfo = sections![section]
        return sectionInfo.numberOfObjects
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ExerciseCell", forIndexPath: indexPath)
        
        configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let routine = fetchedResultsController.objectAtIndexPath(indexPath) as! Routine
        let destVC = UIStoryboard(name: "StartWorkout", bundle: nil).instantiateViewControllerWithIdentifier("StartWorkoutNavigationController") as! UINavigationController
        let startWorkoutVC = destVC.viewControllers[0] as! StartWotkoutMainViewController
        initStartWorkoutViewController(startWorkoutVC, withRoutine: routine)
        presentViewController(destVC, animated: true, completion: nil)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let record = fetchedResultsController.objectAtIndexPath(indexPath) as! Routine
        cell.textLabel?.text = record.name
    }
    
    func initStartWorkoutViewController(viewController: StartWotkoutMainViewController, withRoutine routine: Routine) {
        
        let workoutLog = WorkoutLog.insetIntoContext(moc, dateTime: workoutDatePicker.date, duration: 0, routine: routine)
        //workout Exercise
        _ = routine.exercises?.map({ (exercise) -> WorkoutExercise in
            let exe = exercise as! RoutineExercise
            let workoutExercise = WorkoutExercise.insertIntoContext(moc, exercise: exe, workoutLog: workoutLog)
            
            _ = (exercise as! RoutineExercise).sets.map({ (set) -> WorkoutExerciseSet in
                let s = set as! RoutineExerciseSet
                return WorkoutExerciseSet.insertIntoContext(moc, reps: s.reps.integerValue, set: s.set.integerValue, exercise: workoutExercise)
            })
            
            return workoutExercise
        })
        
        
        
        viewController.workoutLog = workoutLog
    }
    
}

//MARK: - NSFetchedResultsControllerDelegate
extension AddWorkOutViewController: NSFetchedResultsControllerDelegate {
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


extension AddWorkOutViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case ViewRoutineSegue
        case StartWorkOutSegue
        case FreeWorkoutSegue
    }
}


















