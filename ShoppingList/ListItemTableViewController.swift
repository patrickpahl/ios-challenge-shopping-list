//
//  ListItemTableViewController.swift
//  ShoppingList
//
//  Created by Patrick Pahl on 5/27/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit
import CoreData

class ListItemTableViewController: UITableViewController {

    
    @IBAction func addItem(sender: AnyObject) {
        presentAlertController()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    ItemController.sharedInstance.fetchedResultsController.delegate = self
    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sections = ItemController.sharedInstance.fetchedResultsController.sections else {return nil}
        
        let value = Int(sections[section].name)
        if value == 0 {
            return "To buy:"
        } else {
            return "Bought:"
        }
    }
  

    /////////ALERT CONTROLLER
    
    func presentAlertController(){
        
        var itemTextField: UITextField?
        
        let alertController = UIAlertController(title: "Add new shopping list item", message: "Don't forget the beer", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "i.e. milk, apples, coffee"
            itemTextField = textField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        let createAction = UIAlertAction(title: "Create", style: .Default) { (_) in
            guard let name = itemTextField?.text where name.characters.count > 0 else {return}
        
        ItemController.sharedInstance.addItem(name)
        
        }
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(createAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        guard  let sections = ItemController.sharedInstance.fetchedResultsController.sections else {return 0}
        
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = ItemController.sharedInstance.fetchedResultsController.sections else {return 0}
        
        return sections[section].numberOfObjects
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as? ButtonTableViewCell,

        item = ItemController.sharedInstance.fetchedResultsController.objectAtIndexPath(indexPath) as? Item else
        {return UITableViewCell()}
        
        cell.updateWithItem(item)
        cell.delegate = self

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
          
            guard let item = ItemController.sharedInstance.fetchedResultsController.objectAtIndexPath(indexPath) as? Item else {return}
            
            ItemController.sharedInstance.removeItem(item)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ListItemTableViewController: ItemTableViewCellDelegate {
    
    func buttonCellButtonTapped(cell: ButtonTableViewCell) {
        
     guard let indexPath = tableView.indexPathForCell(cell),
        let item = ItemController.sharedInstance.fetchedResultsController.objectAtIndexPath(indexPath) as? Item else {return}
        
        item.isComplete = !item.isComplete.boolValue
        cell.isCompleteValueChanged(item.isComplete.boolValue)
        ItemController.sharedInstance.saveToPersistentStorage()
    }
    
}

extension ListItemTableViewController: NSFetchedResultsControllerDelegate {
    
    //FUNC: Controller will change - Listening for changes, will begin updating content.
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    //FUNC: controller did change OBJECT- Handle cases with Switch stmt. Types are delete, insert, move, update.
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        case .Insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        case .Move:
            guard let indexPath = indexPath, newIndexPath = newIndexPath else {return}
            tableView.moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath)
        case .Update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    //**delete object way above when you swipe to delete, but HERE we actually delete the row in the table too.
    // Here we're just inserting the row
    //**On 'guard let indexPath = indexPath', the first indexPath correlates to the [indexPath] below in the stmt. We can call it whatever we want.
    
    
    //FUNC: controller did change SECTION -    Switch case for sections delete/insert
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default:
            break
        }
    }
    
    //FUNC: controller did change content - Completes reloading the table view so the app is not constantly updating.
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}








