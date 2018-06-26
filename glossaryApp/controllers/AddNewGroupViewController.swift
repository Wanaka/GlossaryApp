import UIKit
import Firebase

class AddNewGroupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var ref: DatabaseReference!

    @IBOutlet weak var saveGroup: UIButton!
    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var firstLanguageOutlet: UIButton!
    @IBOutlet weak var secondLanguageOutlet: UIButton!
    @IBOutlet weak var setTitleInput: UITextField!
    @IBOutlet weak var closePicker: UIButton!
    
    var checkFirstLanguageButton = true
    var checkSecondLanguageButton = true
    var fL = false
    var sL = false
    
    var setFirstLanguage = ""
    var setSecondLanguage = ""
    var setTitle = ""
    var setFirstCode = ""
    var setSecondCode = ""
    
    var languages = LanguageModel()
    var languageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()

        setTitleInput.delegate = self
        
        languagePicker.delegate = self
        languagePicker.dataSource = self
        
        languagePicker.isHidden = true
        closePicker.isHidden = true
        saveGroup.isHidden = false
        
        languageCount = languages.getLanguages().count

        print("amount of lang", languageCount)

    }

    @IBAction func secondLanguage(_ sender: Any) {
        print("lang check", checkSecondLanguageButton)
        
        if(checkSecondLanguageButton){
            secondLanguageOutlet.setTitle(languages.getLanguages()[0], for: .normal)
            sL = true
            fL = false
            languagePicker.isHidden = false
            closePicker.isHidden = false
            saveGroup.isHidden = true
        } else{
            sL = false
            checkSecondLanguageButton = true
            languagePicker.isHidden = true
            closePicker.isHidden = true
            saveGroup.isHidden = false
        }
    }
    
    @IBAction func firstLanguage(_ sender: Any) {
        print("lang check", checkFirstLanguageButton)
        
        if(checkFirstLanguageButton){
            firstLanguageOutlet.setTitle(languages.getLanguages()[0], for: .normal)
            fL = true
            sL = false
            languagePicker.isHidden = false
            closePicker.isHidden = false
            saveGroup.isHidden = true
        } else{
            fL = false
            checkFirstLanguageButton = true
            languagePicker.isHidden = true
            closePicker.isHidden = true
            saveGroup.isHidden = false
        }
    }
    
    @IBAction func closePicker(_ sender: Any) {
        languagePicker.isHidden = true
        closePicker.isHidden = true
        saveGroup.isHidden = false
    }
    
    @IBAction func saveButtonFunction(_ sender: UIButton) {
        if(setTitleInput.text != ""){
            setTitle = setTitleInput.text!
            self.ref.child("users").child((Auth.auth().currentUser?.uid)!).childByAutoId().child("languages")
                .setValue(["title": setTitle,"firstLanguage": setFirstLanguage, "firstCode": setFirstCode, "secondLanguage": setSecondLanguage, "secondCode": setSecondCode])
            self.dismiss(animated: true, completion: {})
        }
    }
 
    
    @IBAction func dismissView(_ sender: Any) { self.dismiss(animated: true, completion:nil) }
    
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
        }
        
        if(sL){
            fL = false
            print("row: \(row)")
            print("value: \(languages.getLanguages()[row])")
            secondLanguageOutlet.setTitle(languages.getLanguages()[row], for: .normal)
            setSecondLanguage = languages.getLanguages()[row]
            setSecondCode = languages.getCodes()[row]

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.setTitleInput.resignFirstResponder()
        return true
    }
}
