//
//  RegisterViewController.swift
//  Corus-iOS-App
//
//  Created by Anis Agwan on 04/03/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class RegisterViewController: UIViewController {
    let genderList = ["Male", "Female", "Other"]
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var selectedGender: String?
    private var datePicker: UIDatePicker?
    
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.textContentType = .none
        passwordField.textContentType = .none
        createPickerView()
        dismissPickerView()
        createDatePicker()
        dismissDatePicker()
    }
    
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text, let name = nameField.text, let dob = dobField.text, let gender = genderField.text, let city = cityField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                var message = ""
                
                if let err = error {
                    print("Error creating new user \(err.localizedDescription)")
                    message = "Error creating new user \(err.localizedDescription)"
                } else {
                    self.db.collection("profile").addDocument(data: [
                        "email": email,
                        "name":name,
                        "date of birth": dob,
                        "gender": gender,
                        "city": city
                    ]) { (error) in
                        if let errData = error {
                            print("Error saving data, \(errData)")
                        } else {
                            print("Successfully saved data")
                        }
                    }
                    print("User created successfully, now go to Login page to sign in")
                    message = "User created successfully, now go to Login page to sign in"
                    self.navigationController?.popToRootViewController(animated: true)
                }
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            }
        }
    }

//MARK: - Picker View for Gender selection

extension RegisterViewController:  UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
    func createPickerView() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
           genderField.inputView = pickerView
    }
    
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       genderField.inputAccessoryView = toolBar
    }
    @objc func action() {
          view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = genderList[row]
        genderField.text = selectedGender
    }
}

//MARK: - Date Picker

extension RegisterViewController {
    func createDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        datePicker?.addTarget(self, action: #selector(RegisterViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        dobField.inputView = datePicker
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        dobField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    func dismissDatePicker() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
