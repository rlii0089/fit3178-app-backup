//
//  RecipeFilterTableViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 16/5/2024.
//

import UIKit

class RecipeFilterTableViewController: UITableViewController {
    
    var filterType: String?
    var filterOptions: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFilterOptions()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func fetchFilterOptions() {
        guard let filterType = filterType else { return }
        var urlString: String
        
        switch filterType {
        case "Category":
            urlString = "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list"
        case "Glass":
            urlString = "https://www.thecocktaildb.com/api/json/v1/1/list.php?g=list"
        case "Ingredient":
            urlString = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"
        default:
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching filter options: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
                do {
                    let filterOptionsResponse = try JSONDecoder().decode(FilterOptionsResponse.self, from: data)
                    print("API Response: \(filterOptionsResponse)")
                    self.filterOptions = filterOptionsResponse.drinks.compactMap { option in
                        if let category = option.strCategory {
                            return category
                        } else if let glass = option.strGlass {
                            return glass
                        } else if let ingredient = option.strIngredient1 {
                            return ingredient
                        }
                        return nil
                    }
                    print("Filter Options: \(self.filterOptions)")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            
        }.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterOptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterOptionCell", for: indexPath)
        cell.textLabel?.text = filterOptions[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = filterOptions[indexPath.row]
        // Pass the selected option back to DrinkRecipeFilterViewController
        if let navController = self.navigationController,
           let previousVC = navController.viewControllers[navController.viewControllers.count - 2] as? DrinkRecipeFilterViewController {
            previousVC.setSelectedFilterOption(option: selectedOption, for: filterType)
            navController.popViewController(animated: true)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
