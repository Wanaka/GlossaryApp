//
//  ViewController.swift
//  glossaryApp
//
//  Created by Jonas Haag on 2018-02-22.
//  Copyright © 2018 Jonas Haag. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignupController: UIViewController {
    
    
    @IBOutlet weak var enterNameField: UITextField!
    @IBOutlet weak var enterPasswordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func CreateNewUser(_ sender: Any) {
        Auth.auth().createUser(withEmail: enterNameField.text!, password: enterPasswordField.text!, completion: { (user, error) in
            if(error != nil){
                print("error at signup")
            }else{
                print("signup successful")
                self.performSegue(withIdentifier: "signedUp", sender: nil)
            }
        })
    }
    
    @IBAction func goToLogin(_ sender: Any) {
        performSegue(withIdentifier: "goToLogin", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
    }
}

