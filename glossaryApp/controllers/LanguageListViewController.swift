//
//  LanguageListViewController.swift
//  glossaryApp
//
//  Created by Jonas Haag on 2018-05-31.
//  Copyright © 2018 Jonas Haag. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class LanguageListViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    let USERS = "users"
    let LANGUAGES = "languages"
    var firstLanguages = [String]()
    var secondLanguages = [String]()
    var titleLanguages = [String]()

    @IBOutlet weak var languageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //try! Auth.auth().signOut()
        //Set the navigation back button to false
        
        //Logout button
      /* let addButton = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(tapbutton(sender:))
        )
 
        self.navigationItem.rightBarButtonItem = addButton
        */
        
        let addNewGroupButton = UIBarButtonItem(
            title: "+",
            style: .plain,
            target: self,
            action: #selector(addnewgroupbutton(sender:))
        )
        
        self.navigationItem.rightBarButtonItem = addNewGroupButton
        
        //check if user is signed in
        if(Auth.auth().currentUser == nil){
            performSegue(withIdentifier: "signup", sender: nil)
        }else{
            print("we have a user loged in!: \(String(describing: Auth.auth().currentUser!.uid))")
            ref = Database.database().reference().child(USERS).child((Auth.auth().currentUser?.uid)!)
            
            //Get languages
            ref.observe(.value, with: { (snapshot) in
                let array:NSArray = snapshot.children.allObjects as NSArray
                self.firstLanguages.removeAll()
                self.secondLanguages.removeAll()
                self.titleLanguages.removeAll()

                for child in array {
                    let snap = child as! DataSnapshot
                    if snap.value is NSDictionary {
                        let data:NSDictionary = snap.value as! NSDictionary
                        //print(data)
                        if let getLang = data.value(forKey: self.LANGUAGES) {
                            let getLang2:NSDictionary = getLang as!
                            NSDictionary
                            print(getLang2)
                            let firstLanguage  = getLang2["firstLanguage"]
                            let secondLanguage  = getLang2["secondLanguage"]
                            let titleLanguage  = getLang2["title"]

                            self.firstLanguages.append(firstLanguage as! String)
                            self.secondLanguages.append(secondLanguage as! String)
                            self.titleLanguages.append(titleLanguage as! String)

                            print( self.firstLanguages +  self.secondLanguages + self.titleLanguages)
                        }
                    }
                }
                    self.languageTableView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool){}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @objc func addnewgroupbutton(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addNewGroupSegue", sender: nil)
    }
    /*@objc func tapbutton(sender: UIBarButtonItem) {
        print("you taped logout button")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "login", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    @IBAction func createGlossary(_ sender: Any) {
        performSegue(withIdentifier: "goGlossary", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! GlossaryTableViewCell
        cell.firstWord.text = firstLanguages[indexPath.row]
        cell.secondWord.text = secondLanguages[indexPath.row]
        cell.title.text = titleLanguages[indexPath.row]

        return cell
    }
}
