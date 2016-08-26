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

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func logInButtonPressed(sender: AnyObject) {
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegueWithIdentifier("logInSegue", sender: nil)
        }
        ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
