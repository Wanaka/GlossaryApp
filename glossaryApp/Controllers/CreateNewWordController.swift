//
//  CreateNewWordController.swift
//  glossaryApp
//
//  Created by Jonas Haag on 2018-03-10.
//  Copyright © 2018 Jonas Haag. All rights reserved.
//

import UIKit

class CreateNewWordController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    struct Language{
        var name = String()
    }
    
    var languagesList = [Language]()
    var languagesToAdd = [Language]()
    var languagesToString = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let languages : LanguageListModel = LanguageListModel()
        languagesToString = languages.getLanguages()
        
        for lang in languagesToString{
            languagesToAdd.append(Language(name: lang))
        }
        languagesList = languagesToAdd
        
        searchBar.delegate = self
        searchBar.tintColor = UIColor.gray
        searchBar.barTintColor = UIColor.white
        searchBar.placeholder = "Choose a language"

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // If we haven't typed anything into the search bar then do not filter the results
        searchBar.showsCancelButton = true
        if searchBar.text! == "" {
            languagesList = languagesToAdd
        } else {
            // Filter the results
            languagesList = languagesToAdd.filter { $0.name.lowercased().contains(searchBar.text!.lowercased())
            }
            
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
       
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
        print("Row \(self.languagesList[indexPath.row].name) selected")
        searchBar.text = self.languagesList[indexPath.row].name
        searchBar.showsCancelButton = false
        
    }
}
