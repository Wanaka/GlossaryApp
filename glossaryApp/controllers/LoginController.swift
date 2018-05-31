//
//  LoginController.swift
//  glossaryApp
//
//  Created by Jonas Haag on 2018-02-23.
//  Copyright © 2018 Jonas Haag. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController {

    @IBOutlet weak var enterNameField: UITextField!
    @IBOutlet weak var enterPasswordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Login(_ sender: Any) {
        Auth.auth().signIn(withEmail: enterNameField.text!, password: enterPasswordField.text!, completion: { (user, error) in
            if(error != nil){
                print("error at login")
            }else{
                print("login successful")
                self.performSegue(withIdentifier: "logedin", sender: nil)
            }
        })
    }
    @IBAction func goToSignup(_ sender: Any) {
        performSegue(withIdentifier: "goToSignup", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}
