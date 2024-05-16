//
//  InitialSignInOptionsViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 4/5/2024.
//

import UIKit
import Firebase

class InitialSignInOptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignInLaterButton(_ sender: Any) {
        signIn()
    }
    
    func signIn() {
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                self.displayMessage(title: "Error", message: error.localizedDescription)
            } else {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
