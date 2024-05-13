//
//  SignInViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 4/5/2024.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    var email: String?
    var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBAction func LoginButton(_ sender: Any) {
        login()
    }
    
    @IBAction func CreateAccountButton(_ sender: Any) {
    }
    
    func login() {
        email = EmailTextField.text
        password = PasswordTextField.text
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (authResult, error) in
            if error != nil {
                print(error!)
                self.displayMessage(title: "Error", message: "Invalid email or password")
            } else {
                print("Login successful")
                self.performSegue(withIdentifier: "loginToHomeSegue", sender: self)
            }
        }
    }

    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
