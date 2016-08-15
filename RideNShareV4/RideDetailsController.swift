//
//  RideDetailsController.swift
//  RideNShareV4
//
//  Created by uics4 on 11/25/15.
//  Copyright © 2015 uics4. All rights reserved.
//

import UIKit
import Parse


class RideDetailsController: UIViewController {
  
    
    var object = ridedetails()
    
    @IBOutlet weak var scrollHandle: UIScrollView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var toLabel: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    
    @IBOutlet weak var startDate: UILabel!
    
    @IBOutlet weak var returnDateLabel: UILabel!
    
    @IBOutlet weak var returnDate: UILabel!
    
    
    @IBOutlet weak var LuggageAllowed: UILabel!
    
    
    @IBOutlet weak var fareLabel: UILabel!
    
    @IBOutlet weak var seatOfferedLabel: UILabel!
    
    var confirmedRiderList = [String]()
    
    override func viewDidLoad() {
        
        scrollHandle.contentSize.height = 1000

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
       print("Inside Ride Details ")
        object.toString()
        
        emailLabel.text = object.email
        fromLabel.text = object.fromLocation
        toLabel.text = object.toLocation
        typeLabel.text = object.tripType
        startDate.text = String(object.startDateTime)
        returnDate.text = ""
        if(typeLabel.text == "OneWay")
        {
            returnDateLabel.hidden = true
            returnDate.hidden = true
            
        }
        else
        {
            returnDate.text = String(object.returnDateTime)
        }
        
        LuggageAllowed.text = String(object.luggageCapacity)
        fareLabel.text = object.fare
        seatOfferedLabel.text = String(object.seatsOffered)
        
        getConfirmedRiderDetails()
        
        
        
    }
    
    func getConfirmedRiderDetails()
    {
        print("Inside getConfirmedRiderDetails")
        print(PFUser.currentUser()?.email)
        let query1 = PFQuery(className: "ConfirmRides")
        query1.whereKey("DriverId", equalTo: (object.objectid)!)
        query1.whereKey("Approved", equalTo: "approved")
        
        query1.findObjectsInBackgroundWithBlock { (obj, error) -> Void in
            if error == nil {
                print("Successfully retrieved: \(obj)")
            } else {
                print("Error: \(error) \(error!.userInfo)")
            }
            
            for object in obj! {
                
                let query2 = PFQuery(className: "SignUpData")
                query2.whereKey("Email", equalTo: (object.objectForKey("RiderEmail"))!)
                query2.findObjectsInBackgroundWithBlock { (obj, error) -> Void in
                    if error == nil {
                        print("Successfully retrieved SignUpData: \(obj)")
                    } else {
                        print("Error: \(error) \(error!.userInfo)")
                    }
                    
                    for object1 in obj! {
                        var str = "Email: \(String((object.objectForKey("RiderEmail"))!)) Name: \(String((object1.objectForKey("FirstName"))!)) \(String((object1.objectForKey("LastName"))!)) Mobile: \(String((object1.objectForKey("PhoneNumber"))!))"
                        self.confirmedRiderList.append(str)
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                }
                
                
            }
            
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
            
            print(self.confirmedRiderList)
            
            
          
            
            
        }
    }
    
    func uniq<S : SequenceType, String : Hashable where S.Generator.Element == String >(source: S) -> [String] {
        var buffer = [String]()
        var added = Set<String>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }

    override func viewDidAppear(animated: Bool) {
        
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.confirmedRiderList = self.uniq(self.confirmedRiderList)
        return self.confirmedRiderList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
            tableView.rowHeight = 100
            allowMultipleLines(cell)
        
        
            cell.textLabel?.text = "\(indexPath.row+1). \(self.confirmedRiderList[indexPath.row])"
        
            
            
        return cell
        
    }
    func allowMultipleLines(tableViewCell:UITableViewCell) {
        tableViewCell.textLabel?.numberOfLines = 0
        tableViewCell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
   
    
}
