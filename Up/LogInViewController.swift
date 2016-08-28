//
//  LogInViewController.swift
//  Up
//
//  Created by David Taylor on 8/25/16.
//  Copyright © 2016 Hyper Elephant. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    var ref:FIRDatabaseReference!
    
    var signingUp = false

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        if !signingUp{
            signingUp = true
            usernameTextField.hidden = false
            logInButton.setTitle("Sign Up", forState: UIControlState.Normal)
            signUpButton.setTitle("Already registered? Log in!", forState: UIControlState.Normal)
        } else {
            signingUp = false
            usernameTextField.hidden = true
            logInButton.setTitle("Log In", forState: UIControlState.Normal)
            signUpButton.setTitle("Not registered? Sign up!", forState: UIControlState.Normal)
        }
        
    }
    
    @IBAction func logInButtonPressed(sender: AnyObject) {

        if signingUp{
            if let email = self.emailTextField.text,
                password = self.passwordTextField.text,
                username = self.usernameTextField.text{
                // [START headless_email_auth]
                
                FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
                    // [START_EXCLUDE]
                    if let error = error {
                        self.showAlert(error.localizedDescription)
                        return
                    }
                    let changeRequest = user?.profileChangeRequest()
                    changeRequest?.displayName = username
                    changeRequest?.commitChangesWithCompletion({ error in
                        if let error = error {
                            self.showAlert(error.localizedDescription)
                        }
                    })
                    self.addNewUser(email, username: username, uid: (user?.uid)!)
                    
                    self.performSegueWithIdentifier("logInSegue", sender: nil)
                    // [END_EXCLUDE]
                }
                // [END headless_email_auth]
            } else {
                self.showAlert("email/password/username can't be empty")
            }

            
        }else{
            
        
        emailTextField.text = "test@test.com"
        passwordTextField.text = "testing"
        
            if let email = self.emailTextField.text, password = self.passwordTextField.text {
                    // [START headless_email_auth]
                
                    FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                        // [START_EXCLUDE]
                            if let error = error {
                                self.showAlert(error.localizedDescription)
                                return
                            }
                            self.performSegueWithIdentifier("logInSegue", sender: nil)
                        // [END_EXCLUDE]
                    }
                    // [END headless_email_auth]
            } else {
                self.showAlert("email/password can't be empty")
        }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.hidden = true
        
        ref = FIRDatabase.database().reference()
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegueWithIdentifier("logInSegue", sender: nil)
            } else {
                // No user is signed in.
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNewUser(email: String, username: String, uid: String){
        let ref = FIRDatabase.database().reference()
        let key = ref.child("users").childByAutoId().key
        let newUser = ["email": email,
                     "username": username,
                     "uid": uid]
        let update = ["/users/\(key)": newUser]
        ref.updateChildValues(update)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
