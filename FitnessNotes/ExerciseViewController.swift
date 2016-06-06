//
//  ExerciseViewController.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/5/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import UIKit
import CoreData

class ExerciseViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var moc: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController!
    var bodyPart: BodyPart!
    
    var selectedExercise = Set<Exercise>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //property configure
        
        //config the fetchResultsController
        let myDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        moc = myDelegate.coredataStack?.mainContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: Exercise.sortedFetchRequestWithPredicate(NSPredicate(format: "bodyPart = %@", bodyPart)), managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        _ = try? fetchedResultsController.performFetch()
        
        //configure toolbar
        self.navigationController?.toolbarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - IBAction
    @IBAction func addBarButtonTapped(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func saveExerciseButtonTapped(sender: UIBarButtonItem) {
        let routineExercise = selectedExercise.map { (exercise) -> RoutineExercise in
            return RoutineExercise.insertIntoContext(moc, exercise: exercise)
        }
        
        let userInfo = ["newExercise" : routineExercise]
        NSNotificationCenter.defaultCenter().postNotificationName("AddExerciseToRoutineNotificaton", object: self, userInfo: userInfo)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension ExerciseViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            // TODO: delete from CoreData
            break
        case .Insert:
            // TODO: insert into CoreData
            break;
        case .None:
            break;
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let record = fetchedResultsController.objectAtIndexPath(indexPath) as! Exercise
        cell.textLabel?.text = record.name
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let exercise = fetchedResultsController.objectAtIndexPath(indexPath) as! Exercise
        if cell?.accessoryType == .Checkmark {
            cell?.accessoryType = .None
            selectedExercise.remove(exercise)
        } else {
            cell?.accessoryType = .Checkmark
            selectedExercise.insert(exercise)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension ExerciseViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            tableView.deleteRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Move:
            break
        case .Update:
            break
            
        }
    }
}


