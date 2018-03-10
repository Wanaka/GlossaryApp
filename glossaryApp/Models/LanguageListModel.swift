//
//  LanguageListModel.swift
//  glossaryApp
//
//  Created by Jonas Haag on 2018-03-10.
//  Copyright © 2018 Jonas Haag. All rights reserved.
//

import UIKit

class LanguageListModel: NSObject {

    var languages = NSLocale.isoLanguageCodes
    let locale = NSLocale(localeIdentifier: "sv") //Default language, change this later
    var translateLanguages = [String]()
    
    struct LanguageListModel {
    }
    
    func getLanguages() -> [String]{
        for language in languages {
            var getLanguage = locale.displayName(forKey: NSLocale.Key.identifier, value: language)
            
            if(getLanguage == nil){
                print("I found a nil!")
            } else{
                translateLanguages.append(getLanguage!)
            }
        }
        return translateLanguages
    }
}
