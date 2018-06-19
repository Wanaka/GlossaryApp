import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class GlossaryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,
UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var languageGroupCollectionView: UICollectionView!
    @IBOutlet weak var translateThisText: UITextField!
    @IBOutlet weak var firstLanguageOutlet: UIButton!
    @IBOutlet weak var secondLanguageOutlet: UIButton!
    @IBOutlet weak var translatedText: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var closePicker: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    
    var ref: DatabaseReference!
    let USERS = "users"
    let LANGUAGES = "languages"
    var firstLanguages = [String]()
    var secondLanguages = [String]()
    var titleLanguages = [String]()
    var firstCodes = [String]()
    var secondCodes = [String]()
    var keys = [String]()
    
    var checkFirstLanguageButton = true
    var checkSecondLanguageButton = true
    var fL = false
    var sL = false
    var switchChecked = true
    var heartClicked = true
    
    var setFirstLanguage = ""
    var setSecondLanguage = ""
    var setFirstCode = ""
    var setSecondCode = ""
    var f = ""
    var s = ""
    var getKey = ""
    var wordKey = ""

    var sendFirstLanguageDB = ""
    var sendSecondLanguageDB = ""
    
    var languages = LanguageModel()
    var languageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference().child(USERS).child((Auth.auth().currentUser?.uid)!)
        
        languagePicker.delegate = self
        languagePicker.dataSource = self
        
        languagePicker.isHidden = true
        closePicker.isHidden = true
        translateButton.isHidden = false
        heartButton.isHidden = true
    
        languageCount = languages.getLanguages().count

        navigationItem.hidesBackButton = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        //check if user is signed in
        if(Auth.auth().currentUser == nil){
            performSegue(withIdentifier: "signup", sender: nil)
        }else{
            print("we have a user loged in!: \(String(describing: Auth.auth().currentUser!.uid))")
        }
        
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
                            let firstLanguage  = getLang2["firstLanguage"]
                            let secondLanguage  = getLang2["secondLanguage"]
                            let titleLanguage  = getLang2["title"]
                            let firstCode  = getLang2["firstCode"] as! String
                            let secondCode  = getLang2["secondCode"] as! String
                            let key = snap.key

                            self.keys.append(key)

                            self.firstCodes.append(firstCode)
                            self.secondCodes.append(secondCode)
                            self.firstLanguages.append(firstLanguage as! String)
                            self.secondLanguages.append(secondLanguage as! String)
                            self.titleLanguages.append(titleLanguage as! String)
                        }
                    }
                }
                self.languageGroupCollectionView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func mainTranslationAction(_ sender: Any) {
        firstLanguageOutlet.isEnabled = true
        secondLanguageOutlet.isEnabled = true
        heartButton.isHidden = true
    }

    @IBAction func heartButtonAction(_ sender: Any) {
        if(heartClicked){
            heartButton.setImage(UIImage(named: "heart filled"), for: .normal)
            heartClicked = false
            
            //save to db
            let newRef = self.ref.child(getKey).child("languages").child("wordList").childByAutoId()
                newRef.setValue([sendFirstLanguageDB: translateThisText.text, sendSecondLanguageDB: translatedText.text])
            self.wordKey = newRef.key
        } else{
            heartButton.setImage(UIImage(named: "heart not filled"), for: .normal)
            heartClicked = true
            self.ref.child(getKey).child("languages").child("wordList").child(self.wordKey).removeValue()
        }
        
    }
    
    @IBAction func languageSwitch(_ sender: Any) {
        //should check if bool is true or false to change first language and second language
        if(switchChecked){
            //change first language to second and vice verse
            firstLanguageOutlet.setTitle(setSecondLanguage, for: .normal)
            secondLanguageOutlet.setTitle(setFirstLanguage, for: .normal)
            sendFirstLanguageDB = setSecondLanguage
            sendSecondLanguageDB = setFirstLanguage
            switchChecked = false
        } else{
            //go back to starting point
            firstLanguageOutlet.setTitle(setFirstLanguage, for: .normal)
            secondLanguageOutlet.setTitle(setSecondLanguage, for: .normal)
            sendFirstLanguageDB = setFirstLanguage
            sendSecondLanguageDB = setSecondLanguage
            switchChecked = true
        }
    }
    
    @IBAction func closePicker(_ sender: Any) {
        languagePicker.isHidden = true
        closePicker.isHidden = true
    }
    
    @objc func tapbutton(sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "login", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func firstLanguageAction(_ sender: Any) {
        if(checkFirstLanguageButton){
            //firstLanguageOutlet.setTitle(languages.getLanguages()[0], for: .normal)
            //setFirstCode = languages.getCodes()[0]
            fL = true
            sL = false
            languagePicker.isHidden = false
            closePicker.isHidden = false
        } else{
            fL = false
            checkFirstLanguageButton = true
            languagePicker.isHidden = true
            closePicker.isHidden = true
        }
    }
    
    @IBAction func secondLanguageAction(_ sender: Any) {
        if(checkSecondLanguageButton){
            sL = true
            fL = false
            languagePicker.isHidden = false
            closePicker.isHidden = false
        } else{
            sL = false
            checkSecondLanguageButton = true
            languagePicker.isHidden = true
            closePicker.isHidden = true
        }
    }
    
    @IBAction func translateButtonAction(_ sender: Any) {
        heartButton.setImage(UIImage(named: "heart not filled"), for: .normal)
        heartClicked = true
        
        var params = ROGoogleTranslateParams()
        let translator = ROGoogleTranslate()
        translator.apiKey = "AIzaSyA7yKH_0jFv_rvLSvt8oCbHhk3bi9oEI0M" // Add your API Key here
        
        if(switchChecked){
            params.source = setFirstCode
            params.target = setSecondCode
        } else{
            params.source = setSecondCode
            params.target = setFirstCode
        }
        
        params.text = translateThisText.text ?? "The textfield is empty"
        
        translator.translate(params: params) { (result) in
            DispatchQueue.main.async {
                self.translatedText.text = "\(result)"
            }
        }
    }
    
    // data method to return the number of column shown in the picker.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // data method to return the number of row shown in the picker.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return languageCount
    }
    
    // delegate method to return the value shown in the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return languages.getLanguages()[row] as? String
    }
    
    // delegate method called when the row was selected.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if(fL){
                sL = false
                firstLanguageOutlet.setTitle(languages.getLanguages()[row], for: .normal)
                setFirstLanguage = languages.getLanguages()[row]
                setFirstCode = languages.getCodes()[row]

                languagePicker.isHidden = true
                closePicker.isHidden = true
            }
            if(sL){
                fL = false
                secondLanguageOutlet.setTitle(languages.getLanguages()[row], for: .normal)
                setSecondLanguage = languages.getLanguages()[row]
                setSecondCode = languages.getCodes()[row]

                languagePicker.isHidden = true
                closePicker.isHidden = true
            }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleLanguages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! languageGroupsCollectionViewCell
        cell.title.text = self.titleLanguages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        heartButton.isHidden = false
        firstLanguageOutlet.isEnabled = false
        secondLanguageOutlet.isEnabled = false
        
        setFirstLanguage = self.firstLanguages[indexPath.row]
        setSecondLanguage = self.secondLanguages[indexPath.row]
        
        sendFirstLanguageDB = setFirstLanguage
        sendSecondLanguageDB = setSecondLanguage
        
        firstLanguageOutlet.setTitle(setFirstLanguage, for: .normal)
        secondLanguageOutlet.setTitle(setSecondLanguage, for: .normal)
        
        setFirstCode = self.firstCodes[indexPath.row]
        setSecondCode = self.secondCodes[indexPath.row]
        
        getKey = keys[indexPath.row]
    }
}
