//
//  MainController.swift
//  glossaryApp
//
//  Created by Jonas Haag on 2018-02-22.
//  Copyright © 2018 Jonas Haag. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class MainController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    let USERS = "users"
    let LANGUAGES = "languages"
    var firstLanguages = [String]()
    var secondLanguages = [String]()
    @IBOutlet weak var languageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            //try! Auth.auth().signOut()
        //DB reference to get languages
        
        //Set the navigation back button to false
        navigationItem.hidesBackButton = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        //Logout button
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
            print("we have a user loged in!: \(String(describing: Auth.auth().currentUser!.uid))")
            ref = Database.database().reference().child(USERS).child((Auth.auth().currentUser?.uid)!)

            //Get languages
            ref.observe(.value, with: { (snapshot) in
               
                let value = snapshot.value as? NSDictionary
                /*let firstLanguage = (value!["firstLanguage"] as? String)!
                let secondLanguage = (value!["secondLanguage"] as? String)!
                self.firstLanguages.append(firstLanguage)
                self.secondLanguages.append(secondLanguage)
 */
                //print("firstL: \(self.firstLanguages), secondL: \(self.secondLanguages)")
                print("firstL: \(value)")

                
                DispatchQueue.main.async{
                    self.languageTableView.reloadData()
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! GlossaryTableViewCell
        cell.firstWord.text = firstLanguages[indexPath.row]
        cell.secondWord.text = secondLanguages[indexPath.row]
        return cell
    }
}
