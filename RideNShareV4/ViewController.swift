//
//  ViewController.swift
//  Ride&Share
//
//  Created by uics4 on 11/1/15.
//  Copyright © 2015 uics4. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps


class ViewController: UIViewController , UITextFieldDelegate   {
    
    
    @IBOutlet weak var LoginEmailIdOutlet: UITextField!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    @IBOutlet weak var EmailIdOutlet: UITextField!
    
    @IBOutlet weak var FName: UITextField!
    
    @IBOutlet weak var LName: UITextField!
    
    
    @IBOutlet weak var PhoneNo: UITextField!
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(PFUser.currentUser() != nil){
            
            
            gotoList()
            
            
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignUpPressed(sender: UIButton) {
        print(FName.text)
        
        if(EmailIdOutlet.text!.isEmpty || FName.text!.isEmpty || LName.text!.isEmpty || PhoneNo.text!.isEmpty)
        {
            let alert = UIAlertView()
            alert.title = "Invaid Input"
            alert.message = "All fields are Required"
            alert.addButtonWithTitle("Ok")
            alert.show()
            return
            /*displayAlertMessage("All fields are Required")
             return*/
        }
        

        
        
        var testObject = PFObject(className: "SignUpData")
        /* testObject["FirstName"] = FName.text!
        testObject["LastName"] = LName.text!
        
        testObject["PhoneNumber"] = PhoneNo.text!
        testObject["Email"] = EmailIdOutlet.text!
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
        print("Object has been saved.")
        }*/
        
        testObject.setObject(FName.text!, forKey: "FirstName")
        testObject.setObject(LName.text!, forKey: "LastName")
        testObject.setObject(PhoneNo.text!, forKey: "PhoneNumber")
        testObject.setObject(EmailIdOutlet.text!, forKey: "Email")
        
        testObject.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                print("Object Uploaded")
            } else {
                print("Error: \(error) \(error!.userInfo)")
            }
        }
        
    /* func displayAlertMessage(userMessage : String)
        {
            var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: <#T##UIAlertControllerStyle#>)
           
           // let okAction1 = UIAlertAction(title: "OK", style: UIAlertActionStyle, handler: nil)
            
            myAlert.addAction(okAction1)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
        
        }*/
        
        
        var newUser = PFUser()
        newUser.username = self.EmailIdOutlet.text
        newUser.password = "Default"
        newUser.email = self.EmailIdOutlet.text
        newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
            
            //         self.actInd.stopAnimating()
            
            if ((error) != nil) {
                
                var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
            }else {
                
                var alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
                
                
            }
            
        })
        self.gotoListSignup()
        
        
    }
    
    @IBAction func EmailTextEmpty()
    {
        if (EmailIdOutlet.text!.isEmpty) {
            let alert = UIAlertView()
            alert.title = "E-Mail Id Empty"
            alert.message = "Please Enter E-Mail Id"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
    
    @IBAction func FirstNameTextEmpty()
    {
        if (FName.text!.isEmpty) {
            let alert = UIAlertView()
            alert.title = "First Name Empty"
            alert.message = "Please Enter First Name"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }

    
    @IBAction func LastNameTextEmpty()
    {
        if (LName.text!.isEmpty) {
            let alert = UIAlertView()
            alert.title = "Last Name Empty"
            alert.message = "Please Enter Last Name"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }

    
    @IBAction func PhoneNoEmpty()
    {
        if (PhoneNo.text!.isEmpty) {
            let alert = UIAlertView()
            alert.title = "Phone Number Empty"
            alert.message = "Please Enter Phone Number"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
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
    func gotoList()
    {
        performSegueWithIdentifier("loginDone", sender: self)
    }
    
    func gotoListSignup()
    {
        performSegueWithIdentifier("LoginPage", sender: self)
    }
    @IBAction func LoginPressed(sender: UIButton) {
        //
        //        if(PFUser.currentUser() != nil){
        //
        //            gotoList()
        //            print("Invalid Login In goto")
        //
        //        }
        //        else{
        
        var username = self.LoginEmailIdOutlet.text
        var password = "Default"
        
        
        
        //    self.actInd.startAnimating()
        
        PFUser.logInWithUsernameInBackground(username!, password: password, block: { (user, error) -> Void in
            
            //         self.actInd.stopAnimating()
            
            if ((user) != nil) {
                
                var alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                print("Login Done")
                self.gotoList()
                
            }else {
                
                var alert = UIAlertView(title: "Error", message: "\(error?.localizedDescription)", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                print("Invalid Login")
            }
            
        })
        
        
        
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "LoginPage" {
            
            
            if (EmailIdOutlet.text!.isEmpty) {
                let alert = UIAlertView()
                alert.title = "No Text"
                alert.message = "Please Enter E-Mail Id"
                alert.addButtonWithTitle("Ok")
                alert.show()
                return false
            }
            else if (FName.text!.isEmpty) {
                let alert = UIAlertView()
                alert.title = "No Text"
                alert.message = "Please Enter First Name"
                alert.addButtonWithTitle("Ok")
                alert.show()
                return false
            }
            else if (LName.text!.isEmpty) {
                let alert = UIAlertView()
                alert.title = "No Text"
                alert.message = "Please Enter First Name"
                alert.addButtonWithTitle("Ok")
                alert.show()
                return false
            }
            else if (PhoneNo.text!.isEmpty) {
                let alert = UIAlertView()
                alert.title = "No Text"
                alert.message = "Please Enter First Name"
                alert.addButtonWithTitle("Ok")
                alert.show()
                return false
            }
                
            else {
                return true
            }
        }
        return true
    
    }
    
    
}

