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
    var keys = [String]()

    var sendKeys = ""
    var firstLanguageSend = ""
    var secondLanguageSend = ""

    @IBOutlet weak var languageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                            let key = snap.key
                            
                            self.keys.append(key)
                            
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "goToGroup")
        {
            let destinationVC = segue.destination as? WordListViewController
            destinationVC?.getKey = sendKeys
            destinationVC?.firstLanguageSegue = self.firstLanguageSend
            destinationVC?.secondLanguageSegue = self.secondLanguageSend
        }
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendKeys = self.keys[indexPath.row]
        self.firstLanguageSend = firstLanguages[indexPath.row]
        self.secondLanguageSend = secondLanguages[indexPath.row]
        performSegue(withIdentifier: "goToGroup", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        sendKeys = self.keys[indexPath.row]
        if editingStyle == .delete {
            ref = Database.database().reference().child(USERS).child((Auth.auth().currentUser?.uid)!)
            self.ref.child(sendKeys).removeValue()
            
            firstLanguages.remove(at: indexPath.row)
            secondLanguages.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
    }
}
