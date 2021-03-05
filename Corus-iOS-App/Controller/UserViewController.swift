//
//  UserViewController.swift
//  Corus-iOS-App
//
//  Created by Anis Agwan on 04/03/21.
//

import UIKit
import Firebase

class UserViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        loadData()
    }
    
    func loadData() {
        db.collection("profile").getDocuments { (querySnapshot, error) in
            if let err = error {
                print("Issue retrieving data from firestore, \(err)")
            } else {
                if let snapshotDocs = querySnapshot?.documents {
                    for doc in snapshotDocs {
                        let data = doc.data()
                        if let email = data["email"] as? String, let name = data["name"] as? String, let gender = data["gender"] as? String, let city = data["city"] as? String, let dob = data["date of birth"] as? String {
                            if let currUser = Auth.auth().currentUser?.email {
                                if email == currUser {
                                    DispatchQueue.main.async {
                                        self.nameLabel.text = name
                                        self.emailLabel.text = email
                                        self.genderLabel.text = gender
                                        self.cityLabel.text = city
                                        self.dobLabel.text = dob
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
}
