//
//  LanguageModel.swift
//  glossaryApp
//
//  Created by Jonas Haag on 2018-06-05.
//  Copyright © 2018 Jonas Haag. All rights reserved.
//

import UIKit

class LanguageModel: NSObject {

    var languageList = ["Swedish,sv", "German,de", "Spanish,es", "Catalan,cat", "English,en"]
    var languages: [String] = []
    var languageCode: [String] = []
    
    struct LanguageModel {
    }
    
    func split(){
        
        var splited: [String] = []
        for value in languageList.sorted() {
            splited = value.components(separatedBy: ",")
            languages.append(splited[0])
            languageCode.append(splited[1])
        }
    }
    func getLanguages() -> [String]{
        split()
        return languages
    }
    
    func getCodes() -> [String]{
        split()
        return languageCode
    }

}
