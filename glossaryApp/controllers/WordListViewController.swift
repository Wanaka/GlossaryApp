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

    @IBOutlet weak var languageSwitch: UIButton!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var wordsTableView: UITableView!
    
    var firstLanguageSegue = ""
    var secondLanguageSegue = ""
    let USERS = "users"
    let LANGUAGES = "languages"
    let WORDLIST = "wordList"
    var getKey = ""
    
    var switchChecked = true
    
    var firstLanguages = [String]()
    var secondLanguages = [String]()
    var titleLanguages = [String]()
    var keys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstLabel.text = firstLanguageSegue
        self.secondLabel.text = secondLanguageSegue
        
        if(Auth.auth().currentUser == nil){
            performSegue(withIdentifier: "signup", sender: nil)
        }else{
            print("we have a user loged in!: \(String(describing: Auth.auth().currentUser!.uid))")
            
            ref = Database.database().reference().child(USERS).child((Auth.auth().currentUser?.uid)!).child(getKey).child(LANGUAGES).child(WORDLIST)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in snapshots {
                        if let postDict = child.value as? Dictionary<String, AnyObject> {
                                self.firstLanguages.append(postDict[self.firstLanguageSegue] as! String)
                                self.secondLanguages.append(postDict[self.secondLanguageSegue] as! String)
                                self.keys.append(child.key as! String)
                        }
                    }
                }
                self.wordsTableView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }

    @IBAction func languageSwitchAction(_ sender: Any) {
        /*if(switchChecked){
            firstLabel.text = secondLanguageSegue
            secondLabel.text = firstLanguageSegue
            switchChecked = false
        } else{
            firstLabel.text = firstLanguageSegue
            secondLabel.text = secondLanguageSegue
            switchChecked = true
        }*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.firstLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! WordListTableViewCell
            cell.firstWord.text = firstLanguages[indexPath.row]
            cell.secondWord.text = secondLanguages[indexPath.row]
            return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ref = Database.database().reference().child(USERS).child((Auth.auth().currentUser?.uid)!)
            self.ref.child(getKey).child(LANGUAGES).child(WORDLIST).child(self.keys[indexPath.row]).removeValue()
            firstLanguages.remove(at: indexPath.row)
            secondLanguages.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
