//
//  CreateAccountViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 25/4/2024.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

    var email: String?
    var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    
    @IBAction func CreateAccountButton(_ sender: Any) {
        if validateFields() {
            createAccount()
        }
    }

    func createAccount() {
        email = EmailTextField.text
        password = PasswordTextField.text
        
        Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
            if error != nil {
                print(error!)
                self.displayMessage(title: "Error", message: "Account creation failed")
            } else {
                print("Account created successfully")
                self.signIn()
            }
        }
    }
    
    func signIn() {
        email = EmailTextField.text
        password = PasswordTextField.text
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (authResult, error) in
            if error != nil {
                print(error!)
                self.displayMessage(title: "Error", message: "Invalid email or password")
            } else {
                print("Login successful")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let bottomNavigationTabBarController = storyboard.instantiateViewController(withIdentifier: "BottomNavigationTabBarController") as! BottomNavigationTabBarController
                self.view.window?.rootViewController = bottomNavigationTabBarController
            }
        }
    }

    func validateFields() -> Bool {
        if NameTextField.text == "" || EmailTextField.text == "" || PasswordTextField.text == "" || ConfirmPasswordTextField.text == "" {
            displayMessage(title: "Error", message: "All fields are required")
            return false
        }
        
        if PasswordTextField.text != ConfirmPasswordTextField.text {
            displayMessage(title: "Error", message: "Passwords do not match")
            return false
        }
        
        return true
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
