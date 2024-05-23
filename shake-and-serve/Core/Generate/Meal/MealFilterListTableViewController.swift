//
//  MealFilterListTableViewController.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 23/5/2024.
//

import UIKit

class MealFilterListTableViewController: UITableViewController, UISearchBarDelegate {
    
    var filterType: MealDBClient.FilterType!
    var filters: [String] = []
    var filteredFilters: [String] = []
    var selectedFilters: [String] = []
    var isMultiSelect: Bool = false
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch isMultiSelect {
        case true:
            navigationItem.title = "Select up to 3 items"
        case false:
            navigationItem.title = "Select 1 item"
        }
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        // Ensure the search bar is always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        fetchFilters()
    }
    
    func fetchFilters() {
        MealDBClient.shared.fetchFilters(type: filterType) { [weak self] filters in
            DispatchQueue.main.async {
                self?.filters = filters ?? []
                self?.filteredFilters = self?.filters ?? []
                self?.tableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredFilters = filters
        } else {
            filteredFilters = filters.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFilters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealFilterCell", for: indexPath)
        cell.textLabel?.text = filteredFilters[indexPath.row]
        cell.accessoryType = selectedFilters.contains(filteredFilters[indexPath.row]) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilter = filteredFilters[indexPath.row]
        if isMultiSelect {
            if selectedFilters.contains(selectedFilter) {
                selectedFilters.removeAll { $0 == selectedFilter }
            } else if selectedFilters.count < 3 {
                selectedFilters.append(selectedFilter)
            }
        } else {
            selectedFilters = [selectedFilter]
        }
        tableView.reloadData()
    }
}
