//
//  LoginViewController.swift
//  Bird
//
//  Created by Pavel Burdukovskii on 12/04/18.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import UIKit
import Alamofire
class LoginViewController: UIViewController {
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    var id : Int = 0
    
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBAction func login(_ sender: Any) {
         if loginText.text != "" && passText.text != "" {
 
            Alamofire.request(APIManager.instanse.API_BASE_URL + APISelected.auth.rawValue, method: .post, parameters: ["username":loginText.text!, "password":passText.text!]).validate().responseJSON{
                responseJSON in
 
                 switch responseJSON.result {
                case .success(_):
                     if responseJSON.result.value as! Bool != false {
                        self.id = (responseJSON.result.value)! as! Int
                        let a  = UserModel.init(id: self.id, userName: self.loginText.text!, password: self.passText.text!)
                        a.getUserInfo()
                        self.performSegue(withIdentifier: "segue", sender: self)
                    }
                     else {
                       let alert = UIAlertController(title: "", message: "Error, invalide username = \(self.loginText.text!) and password = \(self.passText.text!)", preferredStyle: UIAlertControllerStyle.alert)
                        self.present(alert, animated: true, completion: nil)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5, execute: {
                            alert.dismiss(animated: true, completion: nil)
                        })
                        print("Error, invalide username = \(self.loginText.text!) and password = \(self.passText.text!)")
                    }
                case .failure(let error) :
                    print("Error = ", error)
                }
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
//extension LoginViewController : ViewBuild {
//    internal func stopLoading() {
//        activityIndicator.stopAnimating()
//    }
//
//    internal func startLoading() {
//        activityIndicator.startAnimating()
//    }
//
//    internal func setEmptyData() {
//        view.isHidden = true
//    }
//
//    internal func setData(data: [ViewData]) {
//        view.isHidden = false
//    }
//
//
//
//}
