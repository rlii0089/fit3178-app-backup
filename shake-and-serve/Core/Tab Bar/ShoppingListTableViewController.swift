import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController {
    
    var items: [ShoppingItem] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchItems()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchItems()

        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    
    func fetchItems() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        
        do {
            items = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }
    @IBAction func clearButtonPressed(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Delete all items from Core Data
        for item in items {
            context.delete(item)
        }

        // Save changes
        do {
            try context.save()
        } catch {
            print("Failed to clear items: \(error)")
        }

        // Refresh table view
        items.removeAll()
        tableView.reloadData()
        displayMessage(title: "Cleared", message: "Your shopping list has been cleared.")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.measurement
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            // Delete the item from Core Data
            let itemToDelete = items[indexPath.row]
            context.delete(itemToDelete)

            // Remove the item from the items array
            items.remove(at: indexPath.row)

            // Save changes
            do {
                try context.save()
            } catch {
                print("Failed to delete item: \(error)")
            }

            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
