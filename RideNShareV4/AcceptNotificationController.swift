//
//  AcceptNotificationController.swift
//  RideNShareV4
//
//  Created by uics4 on 11/27/15.
//  Copyright © 2015 uics4. All rights reserved.
//

import UIKit
import Parse
import MessageUI


class AcceptNotificationController: UIViewController ,MFMailComposeViewControllerDelegate{
    @IBOutlet weak var RiderEmail: UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    
    @IBOutlet weak var startDateLabel: UILabel!
    
    @IBOutlet weak var returnDate: UILabel!
    
    
    @IBOutlet weak var returnDateLabel: UILabel!
    
    
    @IBOutlet weak var luggageLabel: UILabel!
    
    @IBOutlet weak var seatsbooked: UILabel!
    
    
    @IBOutlet weak var commentsLabel: UILabel!
    
    var object1 = ridedetails()
    override func viewDidLoad() {
        var from = ""
        var to = ""
        var type = ""
        var startdate = ""
        var returndate = ""
        var fare = ""
        
        
        
        let query1 = PFQuery(className: "RideDetails")
        query1.whereKey("objectId", equalTo: (object1.DriverId!))
        print("Driver id  \(object1.DriverId) " )
        
        query1.findObjectsInBackgroundWithBlock { (obj, error) -> Void in
            if error == nil {
                print("Successfully retrieved: \(obj)")
                from = (String) (obj!.first!.objectForKey("FromLocation")!)
                to = (String) (obj!.first!.objectForKey("ToLocation")!)
                
                type = (String) (obj!.first!.objectForKey("TripType")!)
                startdate = (String) (obj!.first!.objectForKey("TripStartDate")!)
                returndate = (String) (obj!.first!.objectForKey("TripReturnDate")!)
                fare = (String) (obj!.first!.objectForKey("Fare")!)
                
                self.RiderEmail.text = self.object1.email
                self.luggageLabel.text = String(self.object1.luggageCapacity)
                self.seatsbooked.text = String(self.object1.seatsOffered)
                self.commentsLabel.text = self.object1.comments
                self.fromLabel.text = from
                self.toLabel.text = to
                self.typeLabel.text = type
                self.startDateLabel.text = startdate
                
                
                if(self.typeLabel == "OneWay")
                {
                    self.returnDateLabel.hidden = true ;
                    self.returnDate.hidden = true;
                    
                }
                else
                {
                    self.returnDate.text = returndate
                }
                
                
            } else {
                print("Error: \(error) \(error!.userInfo)")
            }
            
        }
        
        //object1.toString()
        
        
        
        
        
        
    }
    
    
    @IBAction func AcceptPressed(sender: UIButton) {
        
        var objectID =  object1.objectid
        var driverId = object1.DriverId
        let seatsBooked = Int(object1.seatsOffered)
        var luggageBooked = Int(object1.luggageCapacity)
        
        let query = PFQuery(className: "ConfirmRides")
        query.getObjectInBackgroundWithId(objectID) {
            (object, error) -> Void in
            if error != nil {
                print(error)
            } else {
                if let object = object {
                    object["Approved"] =   "approved"              }
                object!.saveInBackground()
                
                
                let query1 = PFQuery(className: "RideDetails")
                query1.getObjectInBackgroundWithId(driverId) {
                    (object, error) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        let Luggage = Int(String((object!.objectForKey("LuggageCapacity")!)))
                        
                        let seatOffered = Int(String(object!.objectForKey("SeatsOffered")!) )
                        
                        if(seatOffered != nil && Luggage != nil)
                        {
                            if let object = object {
                                
                                object["SeatsOffered"] = (seatOffered! - seatsBooked)
                                
                                
                                object["LuggageCapacity"] = (Luggage! - luggageBooked)
                                
                            }
                            print("remanining seats \(seatOffered! - seatsBooked)" )
                            object!.saveInBackground()
                            
                            
                        }
                        
                        
                    }
                }
                
                
                //var alert = UIAlertView(title: "Success", message: "Ride Approved", delegate: self, cancelButtonTitle: "OK")
                // alert.show()
                
                var refreshAlert = UIAlertController(title: "Send Email", message: "would you like to send a Email", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
                    self.launchEmail("Approved")
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                    
                    refreshAlert .dismissViewControllerAnimated(true, completion: nil)
                    
                    
                }))
                
                self.presentViewController(refreshAlert, animated: true, completion: nil)
                
            }
        }
        
        
    }
    
    
    @IBAction func RejectPressed(sender: AnyObject) {
        var objectID =  object1.objectid
        
        
        let query = PFQuery(className: "ConfirmRides")
        query.getObjectInBackgroundWithId(objectID) {
            (object, error) -> Void in
            if error != nil {
                print(error)
            } else {
                if let object = object {
                    object["Approved"] =   "rejected"              }
                object!.saveInBackground()
                
                //var alert = UIAlertView(title: "Success", message: "Ride Rejected", delegate: self, cancelButtonTitle: "OK")
                //alert.show()
                
                //self.launchEmail("Rejected")
                
                var refreshAlert = UIAlertController(title: "Send Email", message: "would you like to send a Email", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
                    self.launchEmail("Rejected")
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                    
                    refreshAlert .dismissViewControllerAnimated(true, completion: nil)
                    
                    
                }))
                
                self.presentViewController(refreshAlert, animated: true, completion: nil)
                
                
            }
        }
        
           }
    
    
    func launchEmail(status : String) {
        
        var emailTitle = "Ride has been \(status) "
        var messageBody = "Your Ride Has Been \(status). Your ride is from \(fromLabel.text)  to : \(toLabel.text) on \(startDateLabel.text)"
        
        var toRecipents = [RiderEmail.text!]
        var mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.presentViewController(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
               self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
}
