//
//  MainController.swift
//  glossaryApp
//
//  Created by Jonas Haag on 2018-02-22.
//  Copyright © 2018 Jonas Haag. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        let addButton = UIBarButtonItem(
        title: "Logout",
        style: .plain,
        target: self,
        action: #selector(tapbutton(sender:))
        )
        self.navigationItem.rightBarButtonItem = addButton
        
        //check if user is signed in
        if(Auth.auth().currentUser == nil){
            performSegue(withIdentifier: "signup", sender: nil)
        }else{
            testLabel.text = Auth.auth().currentUser!.email
            print("we have a user loged in!: \(String(describing: Auth.auth().currentUser!.uid))")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tapbutton(sender: UIBarButtonItem) {
        print("you taped logout button")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "login", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "signup"){
            print("we did segue!")
        }
    }
}
