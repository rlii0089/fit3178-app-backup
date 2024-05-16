//
//  RecipeFilterTableViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 16/5/2024.
//

import UIKit

class RecipeFilterTableViewController: UITableViewController, UISearchBarDelegate {
    
    var filterType: String?
    var filterOptions: [String] = []
    var filteredOptions: [String] = []
    
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        fetchFilterOptions()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for \(filterType ?? "Options")"
        searchBar.showsCancelButton = true
        tableView.tableHeaderView = searchBar
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
            if let data = data {
                do {
                    let filterOptionsResponse = try JSONDecoder().decode(FilterOptionsResponse.self, from: data)
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
                    self.filterOptions.sort() // Sort alphabetically
                    self.filteredOptions = self.filterOptions
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
    // UISearchBarDelegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredOptions = filterOptions
        } else {
            filteredOptions = filterOptions.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredOptions = filterOptions
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
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
