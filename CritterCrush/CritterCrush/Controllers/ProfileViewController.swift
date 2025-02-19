//
//  ProfileViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 3/5/23.
//
//MARK: API CALLS
//GET: user stats
//PARAM: userID (logged in)
//400: fail, 201: get json, 401: unauthorized

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //PROGRAM BUTTON TO GO TO SETTINGS
    // @IBOutlet var speciesTitle: UILabel!
     @IBOutlet weak var tableView: UITableView!
     
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var crittercrushPointsLabel: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    //let speciesList = listSpecies
     
     //let speciesList:Array<Species> = [SLF,ALB,EAB,SPM]
    
    
    //show navbar:
    //https://stackoverflow.com/a/39679506
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //hide navbar
    
     override func viewDidLoad() {
         super.viewDidLoad()
         
         
         let boo = UserDefaults.standard.bool(forKey: "seepoints")
         print("seepoints: \(boo)")
         self.totalPointsLabel.isHidden =  !(UserDefaults.standard.bool(forKey: "seepoints"))
         
         //labels
         usernameLabel.text = user.username
         
         let hostName = localhost.hostname
         let url  = "\(hostName)/api/users/userprofile"
         let loginuser: Int = UserDefaults.standard.object(forKey: "userid") as! Int
         
         let param: [String:Int] = [
                         "userid": loginuser
                     ]

         // call /api/users/userprofile end point to get user information
         AF.request(url, method: .get, parameters: param).responseData { response in
             debugPrint(response)

             switch response.result {
             case .success(let data):
                 do {
                     // get the email and pass it to settings page
                     let asJSON = try JSONSerialization.jsonObject(with: data)
                     if let data = asJSON as? [String: Any] {
                         if let dict = data["data"] as? [String: Any], let username = dict["username"] as? String {
                             self.usernameLabel.text = username
                             print(username)
                         }
                     }
                 } catch {
                 }
             case .failure(_): break
             }
         }
         getScore()

         let nib = UINib(nibName:"SpeciesCell", bundle: nil)
         tableView.register(nib, forCellReuseIdentifier: "SpeciesCell")
         tableView.delegate = self
         tableView.dataSource = self
         // Do any additional setup after loading the view.
         self.tableView.reloadData()
     }
     
    func getScore(){
        let hostName = localhost.hostname
        let url  = "\(hostName)/api/reports/count"
        let loginuser: Int = UserDefaults.standard.object(forKey: "userid") as! Int
        
        let param: [String:Int] = [ "userid": loginuser]
        AF.request(url, method: .get, parameters: param).responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                do {
                    // get the email and pass it to settings page
                    let asJSON = try JSONSerialization.jsonObject(with: data)
                    if let data = asJSON as? [String: Any] {
                        if let dict = data["data"] as? [String:Any], let count = dict["count"] {
                            self.crittercrushPointsLabel.text = String(describing: count)
                        }
                        if let dict = data["data"] as? [String:Any], let score = dict["score"] {
                            self.totalPointsLabel.text = String(describing: score)
                        }
                        
                    }
                } catch {
                }
            case .failure(_): break
            }
        }
        
    }
     //MARK: table
     
     //TableView: icons of our bugs
     // 2 columns
     //links to species detail view

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
         self.performSegue(withIdentifier: "showDetailReport", sender: self)
         tableView.deselectRow(at: indexPath, animated: true)
         
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
         return speciesList.count
     }
     
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = tableView.dequeueReusableCell(withIdentifier: "SpeciesCell", for: indexPath) as! SpeciesCell
         
         cell.nameLabel.text = speciesList[indexPath.row].name
         
         cell.scienceLabel.text = speciesList[indexPath.row].science
         
         
         cell.reportCount.text = ("Submissions")
         
         let hostName = localhost.hostname
         let url  = "\(hostName)/api/reports/count"
         let loginuser: Int = UserDefaults.standard.object(forKey: "userid") as! Int
         
         let param: [String:Int] = [
                         "userid": loginuser,
                         "speciesid": speciesList[indexPath.row].id
                     ]

         // call /api/users/userprofile end point to get user information
         AF.request(url, method: .get, parameters: param).responseData { response in
             debugPrint(response)

             switch response.result {
             case .success(let data):
                 do {
                     // get the email and pass it to settings page
                     let asJSON = try JSONSerialization.jsonObject(with: data)
                     if let data = asJSON as? [String: Any] {
                         if let dict = data["data"] as? [String:Any], let count = dict["count"] {
                             cell.reportCount.text = "\(String(describing: count)) Submissions"
                         }
                         
                     }
                 } catch {
                 }
             case .failure(_): break
             }
         }
         
         let imgName = "bugicon\(speciesList[indexPath.row].id)"
         cell.iconImage.image = UIImage(named: imgName)
         
         return cell
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0;
    }

     // MARK: - Navigation
    
    let detailSegueIdentifier = "showDetailReport"
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if  segue.identifier == detailSegueIdentifier,
             let destination = segue.destination as? DetailSubmissionViewController,
             let bugIndex = tableView.indexPathForSelectedRow?.row
         {
             destination.titleStringViaSegue = speciesList[bugIndex].name
             destination.bugID = speciesList[bugIndex].id
         }
     }
}
