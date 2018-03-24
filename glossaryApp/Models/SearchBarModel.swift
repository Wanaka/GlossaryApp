//
//  SearchBarModel.swift
//  glossaryApp
//
//  Created by Jonas Haag on 2018-03-24.
//  Copyright © 2018 Jonas Haag. All rights reserved.
//

import UIKit

class SearchBarModel: NSObject {

    var searchBar:UISearchBar = UISearchBar()
    
    struct Language{
        var name = String()
    }
    
    var languagesList = [Language]()
    var languagesToAdd = [Language]()
    var languagesToString = [String]()
    
    override init(delegate: UISearchBarDelegate){
    searchBar.delegate = delegate
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
}
