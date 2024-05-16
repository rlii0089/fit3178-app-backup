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
        createAccount()
    }

    func createAccount() {
        guard let name = NameTextField.text, !name.isEmpty,
              let email = EmailTextField.text, !email.isEmpty,
              let password = PasswordTextField.text, !password.isEmpty,
              let confirmPassword = ConfirmPasswordTextField.text, !confirmPassword.isEmpty
        else {
            displayMessage(title: "Error", message: "All fields are required")
            return
        }
        
        guard let password = PasswordTextField.text, let confirmPassword = ConfirmPasswordTextField.text, password == confirmPassword
        else {
            displayMessage(title: "Error", message: "Passwords do not match")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.displayMessage(title: "Error", message: "Account creation failed, please try again")
                print("Error creating user: \(error.localizedDescription)")
                return
            }
            
            guard let uid = authResult?.user.uid else { return }
            
            // Save user's name to Firestore
            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "name": name,
                "email": email
            ]) { error in
                if let error = error {
                    self.displayMessage(title: "Error", message: "Account creation failed, please try again")
                    print("Error saving user data: \(error.localizedDescription)")
                } else {
                    self.signIn()
                }
            }
        }
    }
    
    func signIn() {
        email = EmailTextField.text
        password = PasswordTextField.text
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (authResult, error) in
            if error != nil {
                print(error!)
                self.displayMessage(title: "Error", message: "Account creation failed, please try again")
                print("Error signing in user: \(error!.localizedDescription)")
            } else {
                print("Sign in successful")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let bottomNavigationTabBarController = storyboard.instantiateViewController(withIdentifier: "BottomNavigationTabBarController") as! BottomNavigationTabBarController
                self.view.window?.rootViewController = bottomNavigationTabBarController
            }
        }
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
