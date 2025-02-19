//
//  SettingsViewController.swift
//  CritterCrush
//using switch: https://stackoverflow.com/questions/28555255/how-do-i-keep-uiswitch-state-when-changing-viewcontrollers
//  Created by min joo on 3/9/23.
//GET:
//POST: Change password
//PARAM: User, Token
//200: Success
//400: fail, 201: get json, 401: unauthorized


import UIKit
import Alamofire

class SettingsViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var seePointsSwitch: UISwitch!
    
    var usernameData = ""
    var userEmailData = ""
    var userPasswordData = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editEmailSegue") {
            if let editVC = segue.destination as? EditEmailViewController {
                editVC.currEmail = userEmailLabel.text;
            }
        }
        
        
        
    }
    
    @IBAction func onEdit(_ sender: Any) {}
    
    @IBAction func onLogout(_ sender: Any) {
        
        let signoutAlert = UIAlertController(title: "Sign Out?", message: "Do you want to sign out?", preferredStyle: UIAlertController.Style.alert)
        
        signoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            signoutAlert.dismiss(animated: true, completion: nil)
        }))
        
        signoutAlert.addAction(UIAlertAction(title: "Log Out", style: .default, handler: { (action: UIAlertAction!) in
            // Remove the auth token from keychain
            KeychainHelper.standard.delete(service: "com.crittercrush.authToken", account: "authToken")
            
            // redirect user to login screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "login")
            self.present(loginViewController, animated: true, completion: nil)
        }))
        
        present(signoutAlert, animated: true, completion: nil)
    }
    
    @IBAction func onDelete(_ sender: Any) {
        print("Delete Data clicked")
        
        // Create an additional alert to handle misclick delete account
        let deleteAlert = UIAlertController(title: "Delete", message: "Do you want to delete account?", preferredStyle: UIAlertController.Style.alert)
    
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            deleteAlert.dismiss(animated: true, completion: nil)
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
            let hostName = localhost.hostname
            let url  = "\(hostName)/api/users/userprofile"
            let authToken: String? = KeychainHelper.standard.read(service: "com.crittercrush.authToken", account: "authToken", type: String.self)

            let headers: HTTPHeaders = [
                "Authorization": "\(authToken!)"
            ]
            
            AF.request(url, method: .delete, headers: headers).responseData { response in
                debugPrint(response);
                
                
                // Remove the auth token from keychain
                KeychainHelper.standard.delete(service: "com.crittercrush.authToken", account: "authToken")
                
                // redirect user to login screen
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "login")
                self.present(loginViewController, animated: true, completion: nil)
            }
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    @IBAction func switchStatus(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "seepoints")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seePointsSwitch.isOn =  UserDefaults.standard.bool(forKey: "seepoints")
        userEmailLabel.text = userEmailData
        
        let hostName = localhost.hostname
        let url  = "\(hostName)/api/users/userprofile"
        
        let authToken: String? = KeychainHelper.standard.read(service: "com.crittercrush.authToken", account: "authToken", type: String.self)
        
        let headers: HTTPHeaders = [
            "Authorization": "\(authToken!)"
        ]
        
        // call /api/users/userprofile end point to get user information
        AF.request(url, method: .get, headers: headers).responseData { response in
            debugPrint(response)

            switch response.result {
            case .success(let data):
                do {
                    // get the email and pass it to settings page
                    let asJSON = try JSONSerialization.jsonObject(with: data)
                    if let data = asJSON as? [String: Any] {
                        if let dict = data["data"] as? [String: Any], let email = dict["email"] as? String {
                            self.userEmailLabel.text = email
                        }
                        if let dict = data["data"] as? [String: Any], let username = dict["username"] as? String {
                            self.usernameLabel.text = username
                        }
                    }
                } catch {
                }
            case .failure(_): break
            }
        }
    }
}
