//
//  MePageController.swift
//  Ride&Share
//
//  Created by uics4 on 11/13/15.
//  Copyright © 2015 uics4. All rights reserved.
//

import UIKit
import Parse

class MePageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var upcomingRidesTable: UITableView!
    
    var userNotificationDetails:[String] = []
     var riderNotification:[String] = []
    var searchResultArray : [ridedetails] = []
     var riderResultArray : [ridedetails] = []
    var NotificationDetails:[String] = []
    var notificationArrayObject : [ridedetails] = []
    
    var rideObj = ridedetails()
     var rideObj2 = ridedetails()
    var rideObj3 = ridedetails()
    
    var notificationRowCount: Int = 0
    var riderRowCount: Int = 0
    var notificationCount: Int = 0
    @IBAction func LogoutPressed(sender: UIButton) {
        
        PFUser.logOut()
        performSegueWithIdentifier("LogoutDone", sender: self)
        
    }
    
    @IBOutlet weak var NameOutlet: UILabel!
    
    
    @IBOutlet weak var NotificationTable: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var EmailOutlet: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        print("View Appeared")
        mePageLoaded()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.NotificationTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.upcomingRidesTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        mePageLoaded()
        
        
    }
    
    func mePageLoaded()
    {
        
        userNotificationDetails = []
       searchResultArray  = []
         NotificationDetails = []
         notificationArrayObject = []
        riderResultArray = []
        riderNotification = []
        riderRowCount = 0 ;
        
        
      rideObj = ridedetails()
        rideObj2 = ridedetails()
        rideObj3 = ridedetails()
        
         notificationRowCount = 0
         notificationCount  = 0

        
        
        /*NameOutlet.text = ((PFUser.currentUser()?.objectForKey("FirstName"))! as! String) + " " + ((PFUser.currentUser()?.objectForKey("LastName"))! as! String)*/
        let query = PFQuery(className: "SignUpData")
        // 2
        query.whereKey("Email", equalTo: (PFUser.currentUser()?.email)!)
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                //print("Successfully retrieved: \(objects)")
            } else {
                //print("Error: \(error) \(error!.userInfo)")
            }
            
            // print(objects);
            
            self.NameOutlet.text  = (String)(objects!.first!.objectForKey("FirstName")!)
            
            self.EmailOutlet.text = PFUser.currentUser()?.email
            
            // Do any additional setup after loading the view, typically from a nib.
        }
        
        
        fetchNotification()
        getRideRequests()
        getUpdatesForRider()
        
        self.tableView.reloadData()
        self.NotificationTable.reloadData()
        self.upcomingRidesTable.reloadData()

    }
    
    func fetchNotification(){
        let date = NSDate()
        
        print("Inside fetchNotification")
        print(PFUser.currentUser()?.email)
        let query1 = PFQuery(className: "RideDetails")
        query1.whereKey("Email", equalTo: (PFUser.currentUser()?.email)!)
        
        
        query1.findObjectsInBackgroundWithBlock { (obj, error) -> Void in
            if error == nil {
                print("Successfully retrieved: \(obj)")
            } else {
                print("Error: \(error) \(error!.userInfo)")
            }
            
            var i = 0
            for object in obj! {
                i++
                
                
                print("value: ",object)
                let email = (String) (object.objectForKey("Email")!)
                
                let fromLocation = (object.objectForKey("FromLocation"))
                let toLocation =  (object.objectForKey("ToLocation"))
                let tripStartDate =  (object.objectForKey("TripStartDate"))
                let Luggage = String(object.objectForKey("LuggageCapacity")!)
                 let seatOffered = String(object.objectForKey("SeatsOffered")!)
                let tripType = (object.objectForKey("TripType")!)
                if let fLocation = fromLocation , let tLocation = toLocation , let tsd =  tripStartDate
                {
                    
                   let ridedetail = ridedetails()
                    ridedetail.email = email
                    ridedetail.fare = String((object.objectForKey("Fare"))!)
                    ridedetail.fromLocation = String((object.objectForKey("FromLocation"))!)
                    
                    if(Luggage != "nil")
                    {
                        
                        ridedetail.luggageCapacity =
                            NSNumber(integer: ((Int(Luggage)))!)
                        

                    }
                    ridedetail.objectid = object.objectId
                    ridedetail.startDateTime = (tripStartDate as! NSDate)
                    
                    ridedetail.returnDateTime =
                        ((object.objectForKey("TripReturnDate")) as! NSDate)
                    ridedetail.seatsOffered =
                        NSNumber(integer: (Int(seatOffered))!)
                   ridedetail.toLocation = String(tLocation)
                    ridedetail.tripType = String (tripType)
                        
                        
                    if(ridedetail.startDateTime.compare((date)) == NSComparisonResult.OrderedDescending){
                        
                        
                        self.searchResultArray.append(ridedetail)
                        
                        self.userNotificationDetails.append("\(fLocation) --> \(tLocation) \(tsd)")
                    }
                    self.notificationRowCount = (self.searchResultArray.count)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
                
                
            }
            print(self.userNotificationDetails)
            
        }
        
        
        
    }
    
    func getUpdatesForRider()
    {
        var date = NSDate()
        
        
        var from = ""
        var to = ""
        var type = ""
        var startdate = ""
        var returndate = ""
        var fare = ""
        // Fetching Results if currently user is Driver
        
        
        let query2 = PFQuery(className: "ConfirmRides")
        query2.whereKey("RiderEmail", equalTo: (PFUser.currentUser()?.email)!)
        query2.findObjectsInBackgroundWithBlock { (obj, error) -> Void in
            if error == nil {
                
                var i = 0
                for object in obj! {
                    i++
                    
                    let riderEmail = (String) (object.objectForKey("DriverEmail")!)
                    let driverEmail = (String) (object.objectForKey("DriverEmail")!)
                    let DriverId = (String) (object.objectForKey("DriverId")!)
                    let LuggageBooked = String(object.objectForKey("Luggage")!)
                    let seatsBooked = String(object.objectForKey("SeatsBook")!)
                    
                    let comments = String(object.objectForKey("Comments")!)
                    let status = String(object.objectForKey("Approved")!)
                    
                    
                    let query3 = PFQuery(className: "RideDetails")
                    query3.whereKey("objectId", equalTo: (DriverId))
                    
                    
                    query3.findObjectsInBackgroundWithBlock { (obj2, error) -> Void in
                        if error == nil {
                            print("Obj2 values: ",(String) (obj2!.first!.objectForKey("TripStartDate")!))
                            from = (String) (obj2!.first!.objectForKey("FromLocation")!)
                            to = (String) (obj2!.first!.objectForKey("ToLocation")!)
                            
                            type = (String) (obj2!.first!.objectForKey("TripType")!)
                            startdate = (String) (obj2!.first!.objectForKey("TripStartDate")!)
                            returndate = (String) (obj2!.first!.objectForKey("TripReturnDate")!)
                            fare = (String) (obj2!.first!.objectForKey("Fare")!)
                            
                            let ridedetail3 = ridedetails()
                            ridedetail3.email = riderEmail
                            ridedetail3.fare =  fare
                            ridedetail3.fromLocation = from
                            ridedetail3.toLocation = to
                            ridedetail3.luggageCapacity =  NSNumber(integer: (Int(LuggageBooked))!)
                            ridedetail3.seatsOffered =
                                NSNumber(integer: (Int(seatsBooked))!)
                            ridedetail3.comments = comments
                            ridedetail3.status = status ;
                            
                            
                            
                            ridedetail3.startDateTime = (obj2!.first!.objectForKey("TripStartDate")! as! NSDate)
                            
                            ridedetail3.returnDateTime =
                                (obj2!.first!.objectForKey("TripReturnDate")! as! NSDate)
                            
                            
                            if(ridedetail3.startDateTime.compare((date)) == NSComparisonResult.OrderedDescending){
                                
                                
                                self.riderResultArray.append(ridedetail3)
                                self.riderNotification.append("\(from) --> \(to) \(startdate)")
                                
                                
                            }
                            self.riderRowCount = (self.riderNotification.count)
                            
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.upcomingRidesTable.reloadData()
                            }
                            
                        }
                            
                        else {
                            print("Error: \(error) \(error!.userInfo)")
                        }
                    }
                    
                }
                
                
                
                
            } else {
                print("Error: \(error) \(error!.userInfo)")
            }
            
            
        }
        
        
    }
    
    
    func getRideRequests(){
        let date = NSDate()
        
        print("Inside Ride Request")
        print(PFUser.currentUser()?.email)
        let query1 = PFQuery(className: "ConfirmRides")
        let x=query1.whereKey("DriverEmail", equalTo: (PFUser.currentUser()?.email)!)
        print("x:",x)
       
        query1.findObjectsInBackgroundWithBlock { (obj, error) -> Void in
            if error == nil {
                print("Successfully retrieved: \(obj)")
            } else {
                print("Error: \(error) \(error!.userInfo)")
            }
            
            print("rowCount:",self.notificationCount)
            var i = 0
            for object in obj! {
                i++
                
                
                print("value: ",object)
                let email = (String) (object.objectForKey("RiderEmail")!)
                
               
                    
                    let ridedetail2 = ridedetails()
                    ridedetail2.email = email
                
                let Luggage = String(object.objectForKey("Luggage")!)
                ridedetail2.luggageCapacity =
                            NSNumber(integer: ((Int(Luggage)))!)
                
                
                ridedetail2.DriverId = (String) (object.objectForKey("DriverId")!)
                ridedetail2.objectid = object.objectId
                
                 let seatOffered = String(object.objectForKey("SeatsBook")!)
                
                ridedetail2.seatsOffered =
                        NSNumber(integer: (Int(seatOffered))!)
                ridedetail2.comments = String(object.objectForKey("Comments")!)
                if(String(object.objectForKey("Approved")!) == "pending")
                {
                    
                    self.notificationArrayObject.append(ridedetail2)
                    
                    self.NotificationDetails.append("\(email) --> has sent you Ride Request")
                }
                
                    
                
                
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.NotificationTable.reloadData()
                }
                
                
            }
            self.notificationCount = self.NotificationDetails.count
            print(self.NotificationDetails)
            
        }
        
        
        
    }

    
        
   
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == self.tableView)
        {
            print("table rows: for tale view",self.notificationRowCount)
            return self.notificationRowCount
        }
       else if ( tableView == self.upcomingRidesTable)
        {
            
            print("table rows: for upcoming rides ",self.riderRowCount)
            return self.riderRowCount
        }
        else
        {
            print("table rows: for Notification",self.notificationCount)
            return self.notificationCount
        }
    }
    
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(tableView == self.tableView)
        {
            
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
            self.tableView.rowHeight = 100
            allowMultipleLines(cell)
        cell.textLabel?.text = "\(indexPath.row+1). \(self.userNotificationDetails[indexPath.row])"
            
        
        return cell
        }
            
            else if (tableView == self.upcomingRidesTable)
        {
            var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
            self.tableView.rowHeight = 100
            allowMultipleLines(cell)
            cell.textLabel?.text = "\(indexPath.row+1). \(self.riderNotification[indexPath.row])"
            
            
            return cell

        }
        else
        {
            var cell:UITableViewCell = self.NotificationTable.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
            self.NotificationTable.rowHeight = 100
            allowMultipleLines(cell)
            cell.textLabel?.text = "\(indexPath.row+1). \(self.NotificationDetails[indexPath.row])"
            
            return cell

        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == self.tableView)
        {
        print("You selected cell #\(indexPath.row)!")
       
         rideObj = searchResultArray[indexPath.row]
        self.performSegueWithIdentifier("RideDetails", sender: self)
        }
            else if (tableView == self.upcomingRidesTable)
        {
             print("You selected cell #\(indexPath.row)!")
            rideObj3 = riderResultArray[indexPath.row]
            self.performSegueWithIdentifier("RideToTakeDetails", sender: self)
            
        }
        else
        {
            print("You selected cell Notification table #\(indexPath.row)!")
            
            rideObj2 = notificationArrayObject[indexPath.row]
            self.performSegueWithIdentifier("NotificationDetails", sender: self)
        }
        
    }
    
    func allowMultipleLines(tableViewCell:UITableViewCell) {
        tableViewCell.textLabel?.numberOfLines = 0
        tableViewCell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "RideDetails") {
            
           
            let child:RideDetailsController = segue.destinationViewController as! RideDetailsController
            
            child.object = self.rideObj;
            
        }
        
        if (segue.identifier == "RideToTakeDetails") {
            
            
            let child:RideToTakeDetails = segue.destinationViewController as! RideToTakeDetails
            
            child.object = self.rideObj3;
            
        }
        if (segue.identifier == "NotificationDetails") {
            
            
            let child1:AcceptNotificationController = segue.destinationViewController as! AcceptNotificationController
            
            child1.object1 = self.rideObj2;
            
        }
        
    }
    
}