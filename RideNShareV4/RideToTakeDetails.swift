//
//  RideDetailsController.swift
//  RideNShareV4
//
//  Created by uics4 on 11/25/15.
//  Copyright © 2015 uics4. All rights reserved.
//

import UIKit
import Parse


class RideToTakeDetails: UIViewController {
    
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    var object = ridedetails()
    
    @IBOutlet weak var scrollHandle: UIScrollView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var toLabel: UILabel!
    
   
    
    @IBOutlet weak var typeLabel: UILabel!
    
    
    @IBOutlet weak var startDate: UILabel!
    
    @IBOutlet weak var returnDateLabel: UILabel!
    
    @IBOutlet weak var returnDate: UILabel!
    
    
    @IBOutlet weak var LuggageAllowed: UILabel!
    
    
    @IBOutlet weak var fareLabel: UILabel!
    
    @IBOutlet weak var seatOfferedLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        
        scrollHandle.contentSize.height = 1000
        
        commentLabel.text = object.comments
        statusLabel.text = object.status
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
        
        
        
        
    }
    
    
  
    
    override func viewDidAppear(animated: Bool) {
        
        
    }
    
    
   
    
    
}
