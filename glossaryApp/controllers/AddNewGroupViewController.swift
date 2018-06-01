import UIKit

class AddNewGroupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    

    // UIPickerView.
    let myUIPicker = UIPickerView()

    @IBOutlet weak var saveGroup: UIButton!
    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var firstLanguageOutlet: UIButton!
    
    var checkFirstLanguageButton = false
    
    var languagesToString = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        languagePicker.delegate = self
        languagePicker.dataSource = self
        languagePicker.isHidden = true
        saveGroup.isHidden = false
        
        let languages : LanguageListModel = LanguageListModel()
        languagesToString = languages.getLanguages()
        
        print("languagesList",  self.languagesToString)
    }

    @IBAction func firstLanguage(_ sender: Any) {
        print("lang check", checkFirstLanguageButton)
        checkFirstLanguageButton != checkFirstLanguageButton
        
        if(checkFirstLanguageButton){
            checkFirstLanguageButton = false
            languagePicker.isHidden = false
            saveGroup.isHidden = true
        } else{
            checkFirstLanguageButton = true
            languagePicker.isHidden = true
            saveGroup.isHidden = false
        }
        
    }
    
    @IBAction func saveButtonFunction(_ sender: UIButton) {
    }
    
    
    // data method to return the number of column shown in the picker.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // data method to return the number of row shown in the picker.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languagesToString.count
    }
    
    // delegate method to return the value shown in the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languagesToString[row] as? String
        
    }
   /*
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        label.textAlignment = .center
        label.text = languagesToAdd[row] as? String
        view.addSubview(label)
        
        return view
    }
    
    */
 
    // delegate method called when the row was selected.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row: \(row)")
        print("value: \(languagesToString[row])")
        firstLanguageOutlet.setTitle(languagesToString[row], for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
