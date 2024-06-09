import UIKit
import FirebaseAuth
import FirebaseFirestore

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserName()
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
    
    func fetchUserName() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
        if let document = document, document.exists {
            let data = document.data()
            
            let name = data?["name"] as? String ?? "Anonymous"
            self.NameLabel.text = name
            
            let email = data?["email"] as? String ?? "-"
            self.EmailLabel.text = email
        }
            
        }
    }
    
}
