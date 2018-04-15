

import UIKit
import Alamofire
class LoginViewController: UIViewController {
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    var id : Int = 0
    let presenter = ResultPresenter(service: GeneralService())
    var loginViewData = [ResultViewData]()
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBAction func login(_ sender: Any) {
         if loginText.text != "" && passText.text != "" {
            presenter.getData(APISelected.auth.rawValue,
                              ["username": loginText.text! as AnyObject,
                               "password":passText.text! as AnyObject],
                              withName: "",
                              imageArr: [])
                   }
        
//        checViewData(loginViewData)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.atachView(view: self)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func checViewData(_ data: [ResultViewData]) {
        if data.first?.result != false {
            //Attention!!!!
            let _ = UserModel.init(id: (data.first?.id)!, userName: loginText.text!, password: passText.text!)
            performSegue(withIdentifier: "segue", sender: self)
        }
        else {
            let alert = UIAlertController(title: "Invalid username and password", message: " \(loginText.text!) , \(passText.text!)", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute:  {
                alert.dismiss(animated: true, completion: nil)
            })
        }
 
    }
    
}
extension LoginViewController : ViewBuild {
    internal func stopLoading() {
        activityIndicator.stopAnimating()
    }

    internal func startLoading() {
        activityIndicator.startAnimating()
    }

    internal func setEmptyData() {
        view.isHidden = true
    }

    internal func setData(data: [ViewData]) {
        view.isHidden = false
        loginViewData = data as! [ResultViewData]
        checViewData(loginViewData)
        print("loginViewData = ",loginViewData)
    }
}
