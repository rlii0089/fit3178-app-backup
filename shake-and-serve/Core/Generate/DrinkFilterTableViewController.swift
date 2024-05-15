//
//  DrinkFilterTableViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 9/5/2024.
//

import UIKit

class DrinkFilterTableViewController: UITableViewController {

    weak var delegate: DrinkFilterDelegate?
    var filterOptions: [String] = []
    var selectedFilters: [String] = []
    var filterType: String = ""

    private let cocktailBaseURL = "https://www.thecocktaildb.com/api/json/v1/1"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FilterCell")
        tableView.allowsMultipleSelection = true
        
        fetchFilterOptions()
    }

    @IBAction func ApplyButton(_ sender: Any) {
        delegate?.didSelectFilters(filters: selectedFilters, filterType: filterType)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterOptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        
        cell.textLabel?.text = filterOptions[indexPath.row]
        
        if selectedFilters.contains(filterOptions[indexPath.row]) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            cell.accessoryType = .checkmark
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = filterOptions[indexPath.row]
        if !selectedFilters.contains(selectedOption) {
            selectedFilters.append(selectedOption)
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deselectedOption = filterOptions[indexPath.row]
        if let index = selectedFilters.firstIndex(of: deselectedOption) {
            selectedFilters.remove(at: index)
        }
        tableView.reloadData()
    }
    
    func fetchFilterOptions() {
        switch filterType {
        case "Category":
            fetchCategories()
        case "Glass":
            fetchGlasses()
        case "Ingredient":
            fetchIngredients()
        default:
            break
        }
    }
    
    func fetchCategories() {
        let categoryURL = "\(cocktailBaseURL)/list.php?c=list"

        if let url = URL(string: categoryURL) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let dictionary = json as? [String: Any], let categories = dictionary["drinks"] as? [[String: String]] {
                            for category in categories {
                                if let categoryName = category["strCategory"] {
                                    self.filterOptions.append(categoryName)
                                }
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }

        tableView.reloadData()
    }
    
    func fetchGlasses() {
        
        let glassURL = "\(cocktailBaseURL)/list.php?g=list"

        if let url = URL(string: glassURL) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let dictionary = json as? [String: Any], let glasses = dictionary["drinks"] as? [[String: String]] {
                            for glass in glasses {
                                if let glassName = glass["strGlass"] {
                                    self.filterOptions.append(glassName)
                                }
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }

        tableView.reloadData()
    }
    
    func fetchIngredients() {
        
        let ingredientURL = "\(cocktailBaseURL)/list.php?i=list"

        if let url = URL(string: ingredientURL) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let dictionary = json as? [String: Any], let ingredients = dictionary["drinks"] as? [[String: String]] {
                            for ingredient in ingredients {
                                if let ingredientName = ingredient["strIngredient1"] {
                                    self.filterOptions.append(ingredientName)
                                }
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
        
        tableView.reloadData()
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
