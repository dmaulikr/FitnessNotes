//
//  BodyPartViewController.swift
//  FitnessNotes
//
//  Created by Yang, Yusheng on 5/4/16.
//  Copyright © 2016 SunY. All rights reserved.
//

import UIKit
import CoreData

class BodyPartViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var moc: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //config the fetchResultsController
        let myDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        moc = myDelegate.coredataStack?.mainContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: BodyPart.sortedFetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        _ = try? fetchedResultsController.performFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - IBAction
    
    @IBAction func addBarButtonTapped(sender: UIBarButtonItem) {
        //performSegueWithIdentifier("AddBodyPartSegue", sender: self)
    }
    
    @IBAction func cancelBarButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ViewExerciseSegue" {
            let indexPath = sender as! NSIndexPath
            let bodyPart = fetchedResultsController.objectAtIndexPath(indexPath) as! BodyPart
            let desVC = segue.destinationViewController as! ExerciseViewController
            desVC.bodyPart = bodyPart
        }
    }
}

extension BodyPartViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = fetchedResultsController.sections
        let sectionInfo = sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BodyPartCell", forIndexPath: indexPath)
        
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
        let record = fetchedResultsController.objectAtIndexPath(indexPath) as! BodyPart
        cell.textLabel?.text = record.name
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("ViewExerciseSegue", sender: indexPath)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}


extension BodyPartViewController: NSFetchedResultsControllerDelegate {
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
