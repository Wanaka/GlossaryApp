//
//  CreateNewWordController.swift
//  glossaryApp
//
//  Created by Jonas Haag on 2018-03-10.
//  Copyright © 2018 Jonas Haag. All rights reserved.
//

import UIKit

class CreateNewWordController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    struct Language{
        var name = String()
    }
    
    var languagesList = [Language]()
    var l = [Language]()
    var languagesToString = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.isHidden = true
        let languages : LanguageListModel = LanguageListModel()
        languagesToString = languages.getLanguages()
        
        for lang in languagesToString{
            l.append(Language(name: lang))
        }
        print(l)

        languagesList = l
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }

    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            tableView.isHidden = true
        } else {
            // Filter the results
            tableView.isHidden = false
            languagesList = l.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
        
        self.tableView.reloadData()
    }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.languagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")

        cell.textLabel?.text = String(self.languagesList[indexPath.row].name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) selected")
    }
}
