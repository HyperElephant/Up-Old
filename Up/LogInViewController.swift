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
    
    @IBOutlet weak var emailCheckmark: CheckmarkView!
    @IBOutlet weak var passwordCheckmark: CheckmarkView!
    @IBOutlet weak var usernameCheckmark: CheckmarkView!
    
    
    @IBAction func emailEntered(_ sender: AnyObject) {
        if emailTextField.text!.contains("@") {
            emailCheckmark.isHidden = false
        } else {
            emailCheckmark.isHidden = true
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        if !signingUp{
            signingUp = true
            usernameTextField.isHidden = false
            logInButton.setTitle("Sign Up", for: UIControlState())
            signUpButton.setTitle("Already registered? Log in!", for: UIControlState())
        } else {
            signingUp = false
            usernameTextField.isHidden = true
            logInButton.setTitle("Log In", for: UIControlState())
            signUpButton.setTitle("Not registered? Sign up!", for: UIControlState())
        }
        
    }
    
    @IBAction func logInButtonPressed(_ sender: AnyObject) {

        if signingUp{
            if let email = self.emailTextField.text,
                let password = self.passwordTextField.text,
                let username = self.usernameTextField.text{
                // [START headless_email_auth]
                
                FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                    // [START_EXCLUDE]
                    if let error = error {
                        self.showAlert(error.localizedDescription)
                        return
                    }
                    let changeRequest = user?.profileChangeRequest()
                    changeRequest?.displayName = username
                    changeRequest?.commitChanges(completion: { error in
                        if let error = error {
                            self.showAlert(error.localizedDescription)
                        }
                    })
                    self.addNewUser(email, username: username, uid: (user?.uid)!)
                    
                    self.performSegue(withIdentifier: "logInSegue", sender: nil)
                    // [END_EXCLUDE]
                }
                // [END headless_email_auth]
            } else {
                self.showAlert("email/password/username can't be empty")
            }

            
        }else{
            if let email = self.emailTextField.text, let password = self.passwordTextField.text {
                    // [START headless_email_auth]
                
                    FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                        // [START_EXCLUDE]
                            if let error = error {
                                self.showAlert(error.localizedDescription)
                                return
                            }
                            self.performSegue(withIdentifier: "logInSegue", sender: nil)
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
        
        usernameTextField.isHidden = true
        
        ref = FIRDatabase.database().reference()
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "logInSegue", sender: nil)
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
    
    func addNewUser(_ email: String, username: String, uid: String){
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
