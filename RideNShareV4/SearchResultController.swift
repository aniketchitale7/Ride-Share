//

//  SearchResultController.swift

//  RideNShareV4

//

//  Created by macbook_user on 11/25/15.

//  Copyright © 2015 uics4. All rights reserved.

//



import Foundation

import UIKit



class SearchResultController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var searchResultArray : [ridedetails] = []
    var rideObj = ridedetails()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        print("searchResultArray Count",self.searchResultArray.count)
        var i = 0
        while i < self.searchResultArray.count{
            self.searchResultArray[i].toString()
            i++
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return self.searchResultArray.count
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.rowHeight = 100
        
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        allowMultipleLines(cell)
        var rowData : String! = "\(indexPath.row+1). Email: \(self.searchResultArray[indexPath.row].email) FromLocation: \(self.searchResultArray[indexPath.row].fromLocation) ToLocation: \(self.searchResultArray[indexPath.row].toLocation) Fare: \(self.searchResultArray[indexPath.row].fare)"
        
        cell.textLabel?.text = rowData
        
        
        
        return cell
        
        
        
    }
    
    func allowMultipleLines(tableViewCell:UITableViewCell) {
        tableViewCell.textLabel?.numberOfLines = 0
        tableViewCell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("You selected cell #\(indexPath.row)!")
        rideObj = searchResultArray[indexPath.row]
        self.performSegueWithIdentifier("SelectedTripRow", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if(segue.identifier == "SelectedTripRow"){
            let child:ConfirmRideController = segue.destinationViewController as! ConfirmRideController
            child.object = self.rideObj;
        }
    }
    
    
    
}