//
//  ViewController.swift
//  TodoListSwift
//
//  Created by Miguel Fagundez on 1/22/15.
//  Copyright (c) 2015 Miguel Fagundez. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toDoItem: UITextField!
    
    // Variables
    var items :[String] = []
    
// MARK: Functions from the UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Settings delegates and parameters to handle textFields and tableViews
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.toDoItem.delegate = self
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: Helper methods
    /*
        It loads the data from the Core Data to the toDo item list
    */
    func loadData(){
        if let dataOptional = (NSUserDefaults.standardUserDefaults().objectForKey("toDoList") as? [String]){
            self.items = dataOptional
        }
        
    }
    
    /*
        It saves the data of the toDo item list to the Core Data
    */
    func saveData(){
        NSUserDefaults.standardUserDefaults().setObject(self.items, forKey: "toDoList")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

// MARK: Button methods
    
    /*
        Adds the toDo item to the list
    */
    @IBAction func addToDoItem(sender: UIButton) {
        
        self.toDoItem.resignFirstResponder()
        
        // Validates the empty field
        if self.toDoItem.text == "" {
            
            // Display the alert caused by the empty field
            let alert = UIAlertController(title: "toDoItem List", message: "The toDoItem text field can't be empty, you have to write something!",preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok! I'll write something!", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return;
        }
        
        // Adds the item to the toDoList
        self.items.append(self.toDoItem.text)
        self.toDoItem.text = ""
        self.saveData()
        self.tableView.reloadData()
        
    }
    
// MARK: Function of the textField Delegate
    
    /*
        It sets the functionality of the return button in the Text Field
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
// MARK: Functions related to TableViews
    
    /*
        It is neccesary just one section to display the items
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    /*
        It sets the number of rows in the toDo List, counts the number of items
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    /*
        It sets the content of the table view cells
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath) as UITableViewCell
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    /*
        It allows to edit the rows, so a toDoItem can be finished
    */
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    /*
        Handles the deleting of an item
    */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.items.removeAtIndex(indexPath.row)
            self.saveData()
            self.tableView.reloadData()
        }
    }
    /* 
        Sets the title for delete button that will finish the toDo item
    */
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "Finish!"
    }
}

