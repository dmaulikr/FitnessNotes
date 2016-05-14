//
//  RoutinesViewController.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/6/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import UIKit
import CocoaLumberjack
import CoreData


///ViewController shows all routines from the Routine Table
class RoutinesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var moc: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController!
    
    let addRoutineSegueIdentifier = "AddRoutineSegue"

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //config the fetchResultsController
        let myDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        moc = myDelegate.coredataStack?.mainContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: Routine.sortedFetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        _ = try? fetchedResultsController.performFetch()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
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
    
    
    //MARK: - IBAction
    @IBAction func addBarButtonTapped(sender: UIBarButtonItem) {
        performSegueWithIdentifier(addRoutineSegueIdentifier, sender: sender)
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender is NSIndexPath {
            let destVC = segue.destinationViewController as! AddRoutineViewController
            let indexPath = sender as! NSIndexPath
            let selectedRoutine = fetchedResultsController.objectAtIndexPath(indexPath) as! Routine
            destVC.routine = selectedRoutine
        }
    }
    

}

//MARK: UITableViewDataSource, UITableViewDelegate
extension RoutinesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numOfSection = 0
        
        let records = fetchedResultsController.fetchedObjects
        
        if records == nil || records?.count == 0 {
            let emptyLabel = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
            emptyLabel.numberOfLines = 0
            emptyLabel.text = "No Routine, Please Add Your First Routine"
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
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("RoutineCell", forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let record = fetchedResultsController.objectAtIndexPath(indexPath) as! Routine
        cell.textLabel?.text = record.name
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(addRoutineSegueIdentifier, sender: indexPath)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            let deleteObj = fetchedResultsController.objectAtIndexPath(indexPath) as! Routine
            moc.deleteObject(deleteObj)
        default:
            break
        }
    }
    
    
}


//MARK: - NSFetchedResultsControllerDelegate
extension RoutinesViewController: NSFetchedResultsControllerDelegate {
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
