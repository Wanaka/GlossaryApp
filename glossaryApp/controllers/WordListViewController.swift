//
//  wordListViewController.swift
//  glossaryApp
//
//  Created by Jonas Haag on 2018-06-10.
//  Copyright © 2018 Jonas Haag. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class WordListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    var ref: DatabaseReference!

    @IBOutlet weak var wordsTableView: UITableView!
    
    let USERS = "users"
    let LANGUAGES = "languages"
    var firstLanguages = [String]()
    var secondLanguages = [String]()
    var titleLanguages = [String]()
    var keys = [String]()
    var getKey = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("key from last prev. view" + getKey)
        
        if(Auth.auth().currentUser == nil){
            performSegue(withIdentifier: "signup", sender: nil)
        }else{
            print("we have a user loged in!: \(String(describing: Auth.auth().currentUser!.uid))")
            ref = Database.database().reference().child(USERS).child((Auth.auth().currentUser?.uid)!).child(getKey)
            
            ref.observe(.value, with: { (snapshot) in
                let array:NSArray = snapshot.children.allObjects as NSArray
                self.firstLanguages.removeAll()
                self.secondLanguages.removeAll()
                self.titleLanguages.removeAll()
                
                for child in array {
                    let snap = child as! DataSnapshot
                    if snap.value is NSDictionary {
                        let data:NSDictionary = snap.value as! NSDictionary
                        if let getLang = data.value(forKey: self.LANGUAGES) {
                            let getLang2:NSDictionary = getLang as!
                            NSDictionary
                            print("Result from DB", getLang2)
                            //let firstLanguage  = getLang2["firstLanguage"]
                     
                            //elf.titleLanguages.append(titleLanguage as! String)
                            
                        }
                    }
                }
                self.wordsTableView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        //cell.firstWord.text = firstLanguages[indexPath.row]
    
        
        return cell
        
    }
}
