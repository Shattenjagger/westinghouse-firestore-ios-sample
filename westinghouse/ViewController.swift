//
//  ViewController.swift
//  westinghouse
//
//  Created by Danila Balabaev on 18/07/2019.
//  Copyright © 2019 Danila Balabaev. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
        
    }


    @IBAction func loginClick(_ sender: UIButton) {
        guard let email = emailField.text, email != "" else {
            statusLabel.text = "Email should not be empty"
            return
        }
        
        guard let password = passwordField.text, password != "" else {
            statusLabel.text = "Password should not be empty"
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let strongSelf = self else { return }
            if let u = user {
                strongSelf.statusLabel.text = "User: " + u.user.uid
            } else {
                strongSelf.statusLabel.text = "Unknown user"
            }
        }
    }
    
    @IBAction func setDataClick(_ sender: Any) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let data: [String:Any] = [
            "RECID": "1234",
            "Product_FullName": "Awesome product",
            "Product_Code": "AP01",
            "Valid": true,
            "TName": "Some name",
            "Support_Page": "https://www.google.com",
            "Expire_Date": Timestamp(date: Date()),
            "Comm_Type": "wifi",
            "Product_Category": "Bestsellers",
            "Licensee_Name": "Bill Gates",
            "Product_Model": "Awesomo",
            "Special_Message": "Be aware of robots",
            "Customer_SKU": "019101901910",
            "Appstore_Fallover": "aaa",
            "Intial_Support_Date": Timestamp(date: Date()),
            "Product_Discontinued": false,
            "Suggested_Product_Replacement": "",
            "Product_Version": "1X",
            "Product_Firmware": "1.01B",
            // I would highly reccomend to save binary data outside of database
            // Almost at any case it usually a bad idea, but if you really need it - use NDData as far as Firestore supports binary data
            "Product_Image1": NSData(),
            "Product_Image2": NSNull(),
            "Product_Training_Video": "https://www.youtube.com",
            "userID": uid
        ]
        
        db.collection("preferences").document("1234").setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    @IBAction func getDataClick(_ sender: Any) {
        let docRef = db.collection("preferences").document("1234")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
}

