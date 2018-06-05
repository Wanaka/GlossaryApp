import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class GlossaryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref: DatabaseReference!

    @IBOutlet weak var translateThisText: UITextField!
    @IBOutlet weak var firstLanguageOutlet: UIButton!
    @IBOutlet weak var secondLanguageOutlet: UIButton!
    @IBOutlet weak var translatedText: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var closePicker: UIButton!

    var checkFirstLanguageButton = true
    var checkSecondLanguageButton = true
    var fL = false
    var sL = false
    
    var setFirstLanguage = ""
    var setSecondLanguage = ""
    var setFirstCode = ""
    var setSecondCode = ""
    
    var languages = LanguageModel()
    var languageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        languagePicker.delegate = self
        languagePicker.dataSource = self
        
        languagePicker.isHidden = true
        closePicker.isHidden = true
        translateButton.isHidden = false
    
        languageCount = languages.getLanguages().count
        
        print("amount of lang", languageCount)
        

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
        
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closePicker(_ sender: Any) {
        languagePicker.isHidden = true
        closePicker.isHidden = true
    }
    @objc func tapbutton(sender: UIBarButtonItem) {
        print("you taped logout button")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "login", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    @IBAction func firstLanguageAction(_ sender: Any) {
        print("lang check", checkFirstLanguageButton)
        
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
        print("lang check", checkSecondLanguageButton)
        
        if(checkSecondLanguageButton){
            //secondLanguageOutlet.setTitle(languages.getLanguages()[0], for: .normal)
            //setSecondCode = languages.getCodes()[0]
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
        var params = ROGoogleTranslateParams()
        let translator = ROGoogleTranslate()
        translator.apiKey = "AIzaSyA7yKH_0jFv_rvLSvt8oCbHhk3bi9oEI0M" // Add your API Key here

        params.source = setFirstCode
        params.target = setSecondCode
        
        params.text = translateThisText.text ?? "The textfield is empty"
        
        print("params",  params.text)
        translator.translate(params: params) { (result) in
            print("result", result)

            DispatchQueue.main.async {
                print("result", result)
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
            print("row: \(row)")
            print("value: \(languages.getLanguages()[row])")
            firstLanguageOutlet.setTitle(languages.getLanguages()[row], for: .normal)
            setFirstLanguage = languages.getLanguages()[row]
            setFirstCode = languages.getCodes()[row]
            print("code: ", setFirstCode)
            

        }
        
        if(sL){
            fL = false
            print("row: \(row)")
            print("value: \(languages.getLanguages()[row])")
            secondLanguageOutlet.setTitle(languages.getLanguages()[row], for: .normal)
            setSecondLanguage = languages.getLanguages()[row]
            setSecondCode = languages.getCodes()[row]
            print("code: ", setSecondCode)
            

        }
    }

}
