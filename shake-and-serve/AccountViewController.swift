//
//  AccountViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 25/4/2024.
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    
    @IBAction func SignOutButton(_ sender: Any) {
        // Update UserDefaults
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        
        // Navigate to InitialSignInOptionsViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialSignInOptionsViewController = storyboard.instantiateViewController(withIdentifier: "InitialSignInOptionsViewController") as! InitialSignInOptionsViewController
        let navigationController = UINavigationController(rootViewController: initialSignInOptionsViewController)
        self.view.window?.rootViewController = navigationController

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
