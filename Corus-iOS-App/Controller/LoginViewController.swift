//
//  LoginViewController.swift
//  Corus-iOS-App
//
//  Created by Anis Agwan on 04/03/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.textContentType = .oneTimeCode
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        var message = ""
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                
                if let err = error {
                    print("Error logging in, \(err.localizedDescription)")
                    message = "Error logging in, \(err.localizedDescription)"
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    print("Successfully logged in")
                    message = "Successfully logged in"
                    self.performSegue(withIdentifier: "LoginToUser", sender: self)
                }
            }
        }
        
    }
    
}
