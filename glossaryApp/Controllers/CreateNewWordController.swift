//
//  CreateNewWordController.swift
//  glossaryApp
//
//  Created by Jonas Haag on 2018-03-10.
//  Copyright © 2018 Jonas Haag. All rights reserved.
//

import UIKit

class CreateNewWordController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var languages : LanguageListModel = LanguageListModel()
        
        print(languages.getLanguages())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
