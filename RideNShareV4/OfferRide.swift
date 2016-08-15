//  Ride&Share

//

//  Created by Shivam on 11/12/15.

//  Copyright © 2015 uics4. All rights reserved.

//





import UIKit

import Parse

import GoogleMaps



class OfferRide:UIViewController, UITextFieldDelegate, LocateOnTheMap , UISearchBarDelegate {
    
    var cityTitle = ""
        @IBOutlet weak var FromCity: UILabel!
    
    
    
    @IBOutlet weak var toCityLabel: UILabel!
    
    
    
    var fromCities = false
    
    var toCities = false
    
    var geoCordinateFrom = ""
    
    var geoCordinateTo = ""
    
    
    
    
    
    var searchResultController:SearchResultsControllerTableViewController!
    
    var resultsArray = [String]()
    
    var googleMapsView:GMSMapView!
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //self.googleMapsView =  GMSMapView(frame: self.mapViewContainer.frame)
        
        //self.view.addSubview(self.googleMapsView)
        
        searchResultController = SearchResultsControllerTableViewController()
        
        searchResultController.delegate = self
        
        print("View Appeared")
        
    }
    
    
    
    
    
    @IBAction func FindCitiesClicked(sender: AnyObject) {
        
        fromCities = true
        
        toCities = false;
        
        
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        
        self.presentViewController(searchController, animated: true, completion: nil)
        
        
        
    }
    
    
    
    @IBAction func ToCitiesClicked(sender: UIButton) {
        
        fromCities = false
        
        toCities = true;
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        
        self.presentViewController(searchController, animated: true, completion: nil)
        
    }
    
    
    
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        print("Latitute Longitute passed" , lon , lat , title )
        
        
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            
            let marker = GMSMarker(position: position)
            
            self.cityTitle = title
            
            
            
            if(self.toCities)
                
            {self.toCityLabel.text = self.cityTitle
                
                self.geoCordinateTo = String(lon) + "," + String(lat)
                            }
                
            else
                
            {
                
                self.FromCity.text = self.cityTitle
                self.geoCordinateFrom = String(lon) + "," + String(lat)
                            }
                        marker.title = title
            
            marker.map = self.googleMapsView
            
        }
        
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
    
    
    
    
    
    @IBOutlet weak var startDateTime: UIDatePicker!
    
    
    
    @IBOutlet weak var rideType: UISwitch!
    
    @IBOutlet weak var returnDateTime: UIDatePicker!
    
    
    
    @IBOutlet weak var fromLocationPicker: UIPickerView!
    
    
    
    @IBOutlet weak var toLocationPicker: UIPickerView!
    
    @IBOutlet weak var returnDateTimeTagLabel: UILabel!
    
    var selectState1: String!
    
    var selectState2: String!
    
    
    
    
    
    @IBOutlet weak var luggageCapacity: UITextField!
    
    var rideValue: String! = ""
    
    @IBOutlet weak var fare: UITextField!
    
    @IBOutlet weak var seatOffered: UITextField!
    
    @IBOutlet var scrollHandle: UIScrollView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //scrollview.contentSize.height = 1000
                self.luggageCapacity.delegate = self
        
        self.fare.delegate = self
        
        self.seatOffered.delegate = self
        
        //  self.fromLocation.delegate = self;
        
    }
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    @IBAction func rideTypeAction(sender: UISwitch) {
        if(!sender.on){
            
            returnDateTimeTagLabel.hidden = true
            
            returnDateTime.hidden = true
            
        }else{
            
            returnDateTimeTagLabel.hidden = false
            
            returnDateTime.hidden = false
            
        }
        
        
        
    }
    
    
    
    @IBAction func confirmRidePressed(sender: UIButton) {
        
        if(luggageCapacity.text!.isEmpty || seatOffered.text!.isEmpty || FromCity.text!.isEmpty || toCityLabel.text!.isEmpty || fare.text!.isEmpty)
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
        
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        let strDate = dateFormatter.stringFromDate(startDateTime.date)
        
        let returnDate = dateFormatter.stringFromDate(returnDateTime.date)
        
        
        
        print(strDate)
        
        print(returnDate)
        
        if(rideType.on){
            
            rideValue = "RoundTrip"
            
            print("Round trip")
            
        }else{
            
            rideValue = "OneWay"
            
            print("One Way")
            
        }
        
        
        
        let testObject = PFObject(className: "RideDetails")
        
        testObject["Email"] = PFUser.currentUser()?.email
        
        testObject["Fare"] = fare.text
        
        testObject["FromLocGeo"] = geoCordinateTo
        
        testObject["OriginalFromLocGeo"] = geoCordinateFrom
        
        
        testObject["FromLocation"] = FromCity.text
        
        testObject["LuggageCapacity"] =  Int(luggageCapacity.text!)
        
        testObject["SeatsOffered"] = Int(seatOffered.text!)
        
        testObject["ToLocation"] = toCityLabel.text
        
        testObject["TripReturnDate"] = dateFormatter.dateFromString(returnDate)
        
        testObject["TripStartDate"] = dateFormatter.dateFromString(strDate)
        
        testObject["TripType"] = rideValue
        
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            print("Object has been saved.")
            
            var alert = UIAlertView(title: "Success", message: "Submitted", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
        }
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

}







