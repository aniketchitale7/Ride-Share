//
//  ConfirmRideController.swift
//  RideNShareV4
//
//  Created by uics4 on 11/24/15.
//  Copyright © 2015 uics4. All rights reserved.
//

import UIKit
import Parse

extension UILabel {
    func resizeHeightToFit(heightConstraint: NSLayoutConstraint) {
        let attributes = [NSFontAttributeName : font]
        numberOfLines = 0
        lineBreakMode = NSLineBreakMode.ByWordWrapping
        let rect = text!.boundingRectWithSize(CGSizeMake(frame.size.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
        heightConstraint.constant = rect.height
        setNeedsLayout()
    }
}

class ConfirmRideController: UIViewController {
    
    var object = ridedetails()
    
    
    @IBOutlet weak var DriverEmailLabel: UILabel!

    
    
    @IBOutlet weak var LuggageToCary: UITextField!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var seatsToBook: UITextField!
    
    @IBOutlet weak var toLabel: UILabel!
    
    
    @IBOutlet weak var tripTypeLabel: UILabel!
    
    
    @IBOutlet weak var startDateLabel: UILabel!
    
    
    @IBOutlet weak var returnDateLabel: UILabel!
    
    
  
    @IBOutlet weak var maxAllowedLuggage: UILabel!
    
    
    @IBOutlet weak var availableSeats: UILabel!
    @IBOutlet weak var farelabel: UILabel!
    
    
   
    
    
    @IBOutlet weak var returnDateHolder: UILabel!
    
    
    @IBOutlet weak var commentsLabel: UITextField!
    
    
    
    
    @IBAction func checkLuggage(sender: UITextField) {
        if(Int(LuggageToCary.text!) > Int(object.luggageCapacity))
        {
            
            var alert = UIAlertView(title: "Error", message: "Luggage Capacity Exceeded . leave a note in comments regarding Extra luggages and type ", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        }
        
        editingEnded(sender)
    }
    
    
    @IBAction func checkSeats(sender: UITextField) {
        
        
        if(Int(seatsToBook.text!) > Int(object.seatsOffered))
        {
            var alert = UIAlertView(title: "Error", message: "Seat Capacity Exceeded", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
        }
        editingEnded(sender)
    }
    
    
    @IBAction func ConfirmRidePressed(sender: UIButton) {
        
       if(Int(seatsToBook.text!) <= Int(object.seatsOffered))
       {
        
       let testObject = PFObject(className: "ConfirmRides")
        
        testObject["RiderEmail"] = PFUser.currentUser()?.email
        
        testObject["DriverId"] = object.objectid
        
        testObject["Luggage"] =  Int(LuggageToCary.text!)
        
        testObject["SeatsBook"] = Int(seatsToBook.text!)
        testObject["DriverEmail"] = object.email
        testObject["Approved"] = "pending"
        testObject["Comments"] = commentsLabel.text
        

        
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            print("Object has been saved.")
            
            var alert = UIAlertView(title: "Success", message: "Submitted", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
        }
    }
        else
       {
        
        var alert = UIAlertView(title: "Error", message: "Invalid Input", delegate: self, cancelButtonTitle: "OK")
        
        alert.show()
        
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
            }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    @IBAction func editingChanged(sender: UITextField) {
        print("Editing Changes")
    }
    
    @IBAction func editingEnded(sender: UITextField) {
        
        
    }
    
    @IBAction func commentLabelAct(sender: UITextField) {
        editingEnded(sender)
    }
    
    override func viewDidLoad() {
        
       object.toString()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.stringFromDate(object.startDateTime)
        let returnDate = dateFormatter.stringFromDate(object.returnDateTime)
        DriverEmailLabel.text = object.email ;
       
        fromLabel.text =  object.fromLocation ;
        toLabel.text = object.toLocation;
        tripTypeLabel.text = object.tripType;
        
        if(tripTypeLabel.text == "OneWay")
        {
            returnDateLabel.hidden = true
            returnDateHolder.hidden = true
            
        }
        else
        {
            returnDateLabel.text = returnDate;
        }
        startDateLabel.text = strDate;
        
        maxAllowedLuggage.text = "Max: \(object.luggageCapacity)";
        farelabel.text = object.fare;
        commentsLabel.text = "";
        availableSeats.text = "Available seats: \(object.seatsOffered)" ;
        
    }

    
}
