//
//  CreateNewWordController.swift
//  glossaryApp
//
//  Created by Jonas Haag on 2018-03-10.
//  Copyright © 2018 Jonas Haag. All rights reserved.
//

import UIKit

class CreateNewWordController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var firstSearchBar: UISearchBar!
    @IBOutlet weak var secondSearchBar: UISearchBar!
    
    var whichTableView = true
    var firstLanguage : String = ""
    var secondLanguage : String = ""
    
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
        firstSearchBar.delegate = self
        firstSearchBar.tintColor = UIColor.gray
        firstSearchBar.barTintColor = UIColor.white
        firstSearchBar.placeholder = "Choose a first language"
        
        secondSearchBar.delegate = self
        secondSearchBar.tintColor = UIColor.gray
        secondSearchBar.barTintColor = UIColor.white
        secondSearchBar.placeholder = "Choose a second language"

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar == firstSearchBar){
            whichTableView = true
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
        if(searchBar == secondSearchBar){
            whichTableView = false
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
        if(whichTableView){
            print("Row \(self.languagesList[indexPath.row].name) selected")
            firstSearchBar.text = self.languagesList[indexPath.row].name
            firstSearchBar.showsCancelButton = false
            tableView.allowsSelection = true
            firstLanguage = firstSearchBar.text!
        } else{
            print("Row \(self.languagesList[indexPath.row].name) selected")
            secondSearchBar.text = self.languagesList[indexPath.row].name
            secondSearchBar.showsCancelButton = false            
            tableView.isHidden = true
            secondLanguage = secondSearchBar.text!
            print("second: \(secondLanguage)")
        }
        
    }
}
