//
//  ridedetails.swift
//  RideNShareV4
//
//  Created by macbook_user on 11/24/15.
//  Copyright © 2015 uics4. All rights reserved.
//

import UIKit
class ridedetails {
    var objectid : String!
    var DriverId : String!
    var email : String!
    var fromLocation : String!
    var toLocation : String!
    var tripType : String!
    var startDateTime = NSDate()
    var returnDateTime = NSDate()
    var luggageCapacity : NSNumber!
    var seatsOffered : NSNumber!
    var fare : String!
    var comments : String!
    var status : String!
    var DriverEmail : String!
    
    func toString(){
    print ("objectID:\(objectid) Email:\(email) fromLocation:\(fromLocation) toLocation: \(toLocation) tripType: \(tripType) startDateTime \(startDateTime) returnDateTime: \(returnDateTime) luggageCapacity: \(luggageCapacity) seatsOffered:\(seatsOffered) Fare:\(fare)")
    
    }
    
    
}