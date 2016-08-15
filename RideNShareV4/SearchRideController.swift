//
//  SearchRideController.swift
//  Ride&Share
//
//  Created by macbook_user on 11/12/15.
//  Copyright © 2015 uics4. All rights reserved.
//

import Foundation
import Parse
import GoogleMaps



class SearchRideController: UIViewController , UITextFieldDelegate , LocateOnTheMap , UISearchBarDelegate   {
    var searchResultArray: [ridedetails] = []
    @IBOutlet weak var toCityLabel: UILabel!
    @IBOutlet weak var fromCityLabel: UILabel!
    @IBOutlet weak var rideType: UISwitch!
    @IBOutlet weak var startDateTime: UIDatePicker!
    @IBOutlet weak var scrollHandle: UIScrollView!
    
    @IBOutlet weak var fromRadius: UISlider!
    
    @IBOutlet weak var toRadius: UISlider!
    @IBOutlet weak var seatsOffered: UITextField!
    @IBOutlet weak var luggageCapacity: UITextField!
    
    @IBOutlet weak var returnDateTimeTagLabel: UILabel!
    @IBOutlet weak var returnDateTime: UIDatePicker!
    var fromCities = false
    var toCities = false
    var cityTitle = ""
    var searchResultController:SearchResultsControllerTableViewController!
    var resultsArray = [String]()
    var googleMapsView:GMSMapView!
    var isReturnTrip = true
    
    
    @IBOutlet weak var fromRadiusLabel: UILabel!
    @IBOutlet weak var toRadiusLabel: UILabel!
    @IBAction func fromRadiusChanged(sender: UISlider) {
        var currentValue = Int(sender.value)
        
        fromRadiusLabel.text = "\(currentValue)"
    }
    @IBAction func toRadiusChanged(sender: UISlider) {
        var currentValue = Int(sender.value)
        
        toRadiusLabel.text = "\(currentValue)"
    }
    @IBAction func fromCityAutoPopulateClicked(sender: UIButton) {
        fromCities = true
        toCities = false;
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
        
    }
    
    @IBAction func toCityAutoPopulateButton(sender: UIButton) {
        fromCities = false
        toCities = true;
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //self.googleMapsView =  GMSMapView(frame: self.mapViewContainer.frame)
        //self.view.addSubview(self.googleMapsView)
        searchResultController = SearchResultsControllerTableViewController()
        searchResultController.delegate = self
        print("View Appeared")
        searchResultArray = []
    }
    
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        print("Latitute Longitute passed" , lon , lat , title )
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            self.cityTitle = title
            
            if(self.toCities)
            {
                self.toCityLabel.text = self.cityTitle
                self.geoCordinateToLon = String(lon)
                self.geoCordinateToLat = String(lat)
            }
            else
            {
                self.fromCityLabel.text = self.cityTitle
                self.geoCordinateFromLon = String(lon)
                self.geoCordinateFromLat = String(lat)
                print("From Coordinates search page: \(self.geoCordinateFromLat) and \(self.geoCordinateFromLon)")
            }
            
            // let camera  = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 10)
            //self.googleMapsView.camera = camera
            
            marker.title = title
            marker.map = self.googleMapsView
            
            
        }
    }
    
    
    
    override func viewDidLoad() {
        //scrollHandle.contentSize.height = 1000
        
        print("To Radius: ", self.toRadius.value)
        
        print("From Radius: ", self.fromRadius.value)
        
        self.luggageCapacity.delegate = self;
        
        self.seatsOffered.delegate = self;
        //fromCityLabel = UILabel(frame: CGRectMake(7, 200, 370, 100))
        fromCityLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        fromCityLabel.numberOfLines = 0
        fromCityLabel.sizeToFit()
        fromCityLabel.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        //toCityLabel = UILabel(frame: CGRectMake(7, 200, 370, 100))
        toCityLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        toCityLabel.numberOfLines = 0
        
    }
    
    func searchBar(searchBar: UISearchBar,
        textDidChange searchText: String){
            print("Search Bar Called")
            let placesClient = GMSPlacesClient()
            placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error:NSError?) -> Void in
                self.resultsArray.removeAll()
                if results == nil {
                    return
                }
                for result in results!{
                    if let result = result as? GMSAutocompletePrediction{
                        self.resultsArray.append(result.attributedFullText.string)
                    }
                }
                self.searchResultController.reloadDataWithArray(self.resultsArray)
            }
    }
    
    
    @IBAction func rideTypeAction(sender: UISwitch) {
        if(!sender.on){
            returnDateTimeTagLabel.hidden = true
            returnDateTime.hidden = true
            isReturnTrip = false
        }else{
            returnDateTimeTagLabel.hidden = false
            returnDateTime.hidden = false
            isReturnTrip = true
        }
    }
    @IBAction func searchRidePressed(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.stringFromDate(startDateTime.date)
        let returnDate = dateFormatter.stringFromDate(returnDateTime.date)
        
        print(strDate)
        print(returnDate)
        if(rideType.on){
            print("Round trip")
        }else{
            print("One Way")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func editingChanged(sender: UITextField) {
        print("Editing Changes")
    }
    
    @IBAction func editingEnded(sender: UITextField) {
        
        
    }
    var geoCordinateToLat = ""
    var geoCordinateToLon = ""
    var geoCordinateFromLat = ""
    var geoCordinateFromLon = ""
    @IBAction func SearchRidePressed(sender: UIButton) {
        if(luggageCapacity.text!.isEmpty || seatsOffered.text!.isEmpty || fromCityLabel.text!.isEmpty || toCityLabel.text!.isEmpty)
        {
            let alert = UIAlertView()
            alert.title = "Invaid Input"
            alert.message = "All fields are Required Please provide 0 if field not required"
            alert.addButtonWithTitle("Ok")
            alert.show()
            return
            /*displayAlertMessage("All fields are Required")
            return*/
        }
        else
        {
            
        

        
        print("Is Return trip: ",isReturnTrip)
        print("Start time: ",startDateTime.date)
        print("Return time: ",returnDateTime.date)
        if luggageCapacity != nil {
            print("Luggage capacity: ",luggageCapacity.text)
        }
        if seatsOffered != nil {
            print("Seat offered: ",seatsOffered.text)
        }
        var ridedetail = ridedetails()
        ridedetail.email = PFUser.currentUser()?.email!
        if(self.toCityLabel != nil){
            ridedetail.toLocation = (self.toCityLabel.text)!
        }
        if(self.fromCityLabel != nil){
            ridedetail.fromLocation = (self.fromCityLabel.text)!
        }
        
        ridedetail.luggageCapacity = NSNumber(integer: (Int(luggageCapacity.text!))!)
        ridedetail.seatsOffered = NSNumber(integer: (Int(seatsOffered.text!))!)
        ridedetail.startDateTime = startDateTime.date
        ridedetail.returnDateTime = returnDateTime.date
        if(isReturnTrip){
            ridedetail.tripType = "RoundTrip"
        }
        else{
            ridedetail.tripType = "OneWay"
        }
        ridedetail.toString()
        
        
        
        
        var resultingobjectIdToCordMap = [String:String]()
        var resultingobjectIdToDist = [String:Double]()
        // var pfObjArray:PFObject = []
        var resultingCoordInCllLocationForm = [CLLocationCoordinate2DMake]
        let searchStringToPosition = CLLocation(latitude: Double(self.geoCordinateToLat)!, longitude: Double(self.geoCordinateToLon)!)
        let searchStringFromPosition = CLLocation(latitude: Double(self.geoCordinateFromLat)!, longitude: Double(self.geoCordinateFromLon)!)
        print(searchStringToPosition)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        var query = PFQuery(className:"RideDetails")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                for object in objects! {
                    var ridedetailObj = ridedetails()
                    //  resultingCoordinates.append(object.objectForKey("FromLocGeo")! as! String)
                    if object.objectForKey("FromLocGeo") != nil && object.objectForKey("OriginalFromLocGeo") != nil
                    {
                        
                        print("Inside first if geo -> \(object.objectForKey("FromLocGeo"))--\(object.objectForKey("OriginalFromLocGeo"))")
                        //resultingCoordinates[]
                        //print("Object:",object)
                        print("date from parse: ",(object.objectForKey("TripStartDate")! as! NSDate))
                        
                        //let strDate = dateFormatter.dateFromString((object.objectForKey("TripStartDate")! as! String))
                        //let returnDate = dateFormatter.dateFromString((object.objectForKey("TripReturnDate")! as! String))
                        if(ridedetail.tripType == "OneWay"){
                            print("Inside Oneway")
                            let nowStartDate = ridedetail.startDateTime
                            
                            
                            // "Sep 23, 2015, 10:26 AM"
                            let fromParseStartDate = (object.objectForKey("TripStartDate")! as! NSDate)
                           
                            // "Sep 23, 2015, 7:40 AM"
                            
                            
                            
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let dateStartString = dateFormatter.stringFromDate(nowStartDate)
                            let dateStartFromParseString = dateFormatter.stringFromDate(fromParseStartDate)
                            
                           
                            if(dateStartString == dateStartFromParseString && ridedetail.seatsOffered.integerValue < (object.objectForKey("SeatsOffered")! as! NSNumber).integerValue){
                                // resultingobjectIdToCordMap[(object.objectId! as String)] = (object.objectForKey("FromLocGeo")! as! String)
                                let locArr = (object.objectForKey("FromLocGeo")! as! String).characters.split{$0 == ","}.map(String.init)
                                let coordTo = CLLocation(latitude: Double(locArr[1])!, longitude: Double(locArr[0])!)
                                let locArrFrom = (object.objectForKey("OriginalFromLocGeo")! as! String).characters.split{$0 == ","}.map(String.init)
                                let coordFrom = CLLocation(latitude: Double(locArrFrom[1])!, longitude: Double(locArrFrom[0])!)
                                
                                var distinmetersto: CLLocationDistance = searchStringToPosition.distanceFromLocation(coordTo)
                                var distinmetersfrom: CLLocationDistance = searchStringFromPosition.distanceFromLocation(coordFrom)
                                
                                print(" One way distance from: \(distinmetersfrom) distance to: \(distinmetersto)")
                                // 80467 mts = 50 miles for to
                                // 16093 mts = 10 miles for from
                                //     1 mt  = 0.000621371 miles
                                if distinmetersto <= (Double)(self.toRadius.value * 1609) && distinmetersfrom < (Double)(self.fromRadius.value * 1609){
                                    resultingobjectIdToDist[object.objectId!]=distinmetersto * 0.000621371
                                    ridedetailObj.objectid = object.objectId
                                    ridedetailObj.email = (object.objectForKey("Email")! as! String)
                                    
                                    ridedetailObj.toLocation = (object.objectForKey("ToLocation")! as! String)
                                    
                                    
                                    ridedetailObj.fromLocation = (object.objectForKey("FromLocation")! as! String)
                                    
                                    
                                    ridedetailObj.luggageCapacity = (object.objectForKey("LuggageCapacity")! as! NSNumber)
                                    ridedetailObj.seatsOffered = (object.objectForKey("SeatsOffered")! as! NSNumber)
                                    ridedetailObj.startDateTime = (object.objectForKey("TripStartDate")! as! NSDate)
                                    ridedetailObj.returnDateTime = (object.objectForKey("TripReturnDate")! as! NSDate)
                                    
                                    ridedetailObj.tripType = (object.objectForKey("TripType")! as! String)
                                    
                                    ridedetailObj.fare = (object.objectForKey("Fare")! as! String)
                                    
                                    
                                    self.searchResultArray.append(ridedetailObj)
                                    
                                    
                                }
                            }
                        }else{
                            print("Inside Roundtrip")
                            let nowStartDate = ridedetail.startDateTime
                            let nowReturnDate = ridedetail.returnDateTime
                            
                            // "Sep 23, 2015, 10:26 AM"
                            let fromParseStartDate = (object.objectForKey("TripStartDate")! as! NSDate)
                            let fromParseReturnDate = (object.objectForKey("TripReturnDate")! as! NSDate)
                            // "Sep 23, 2015, 7:40 AM"
                            
                           
                            
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let dateStartString = dateFormatter.stringFromDate(nowStartDate)
                            let dateStartFromParseString = dateFormatter.stringFromDate(fromParseStartDate)
                            
                            let dateReturnString = dateFormatter.stringFromDate(nowReturnDate)
                            let dateReturnFromParseString = dateFormatter.stringFromDate(fromParseReturnDate)
                            
                            if dateStartString == dateStartFromParseString {
                                print("Equal date")
                            }
                            
                            if(dateStartString == dateStartFromParseString && dateReturnString == dateReturnFromParseString && ridedetail.seatsOffered.integerValue < (object.objectForKey("SeatsOffered")! as! NSNumber).integerValue){
                                // resultingobjectIdToCordMap[(object.objectId! as String)] = (object.objectForKey("FromLocGeo")! as! String)
                                let locArr = (object.objectForKey("FromLocGeo")! as! String).characters.split{$0 == ","}.map(String.init)
                                let coordTo = CLLocation(latitude: Double(locArr[1])!, longitude: Double(locArr[0])!)
                                let locArrFrom = (object.objectForKey("OriginalFromLocGeo")! as! String).characters.split{$0 == ","}.map(String.init)
                                let coordFrom = CLLocation(latitude: Double(locArrFrom[1])!, longitude: Double(locArrFrom[0])!)
                                
                                var distinmetersto: CLLocationDistance = searchStringToPosition.distanceFromLocation(coordTo)
                                var distinmetersfrom: CLLocationDistance = searchStringFromPosition.distanceFromLocation(coordFrom)
                                
                                print("Roundtrip distance from: \(distinmetersfrom) distance to: \(distinmetersto)")
                                // 80467 mts = 50 miles
                                // 16093 mts = 10 miles for from
                                //     1 mt  = 0.000621371 miles
                                if distinmetersto <= (Double)(self.toRadius.value * 1609) && distinmetersfrom < (Double)(self.fromRadius.value * 1609){
                                    resultingobjectIdToDist[object.objectId!]=distinmetersto * 0.000621371
                                    ridedetailObj.objectid = object.objectId
                                    ridedetailObj.email = (object.objectForKey("Email")! as! String)
                                    
                                    ridedetailObj.toLocation = (object.objectForKey("ToLocation")! as! String)
                                    
                                    
                                    ridedetailObj.fromLocation = (object.objectForKey("FromLocation")! as! String)
                                    
                                    
                                    ridedetailObj.luggageCapacity = (object.objectForKey("LuggageCapacity")! as! NSNumber)
                                    ridedetailObj.seatsOffered = (object.objectForKey("SeatsOffered")! as! NSNumber)
                                    ridedetailObj.startDateTime = (object.objectForKey("TripStartDate")! as! NSDate)
                                    ridedetailObj.returnDateTime = (object.objectForKey("TripReturnDate")! as! NSDate)
                                    
                                    ridedetailObj.tripType = (object.objectForKey("TripType")! as! String)
                                    ridedetailObj.fare = (object.objectForKey("Fare")! as! String)

                                    self.searchResultArray.append(ridedetailObj)
                                }
                            }
                        }
                    }
                }
            } else {
                print(error)
            }
            /* for (parseobjectid,loc) in resultingobjectIdToCordMap{
            let locArr = loc.characters.split{$0 == ","}.map(String.init)
            let coord = CLLocation(latitude: Double(locArr[1])!, longitude: Double(locArr[0])!)
            
            var distinmeters: CLLocationDistance = searchStringToPosition.distanceFromLocation(coord)
            // 80467 mts = 50 miles
            //     1 mt  = 0.000621371 miles
            if distinmeters <= 80467{
            resultingobjectIdToDist[parseobjectid]=distinmeters * 0.000621371
            
            }
            
            }*/
            //print(resultingobjectIdToCordMap)
            print(resultingobjectIdToDist)
            /* print("searchResultArray Count",self.searchResultArray.count)
            var i = 0
            while i < self.searchResultArray.count{
            self.searchResultArray[i].toString()
            i++
            }*/
            self.performSegueWithIdentifier("SearchResults", sender: self)
            
        }
        
        
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if(segue.identifier == "SearchResults"){
            let child:SearchResultController = segue.destinationViewController as! SearchResultController
            child.searchResultArray = self.searchResultArray;
        }
    }
    
    
    
    
}