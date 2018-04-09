//
//  ViewController.swift
//  Bird
//
//  Created by Pavel Burdukovskii on 08/04/18.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var viewData = [BirdViewData]()
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    let presenter  = BirdPresenter(service: GeneralService())
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        presenter.atachView(view: self as ViewBuild)
        presenter.getData(APISelected.get_bird.rawValue, [:], withName: "", imageArr: [])
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController : ViewBuild {
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
        viewData = data as! [BirdViewData]
        for (_, index) in viewData.enumerated(){
            print("Index = ", index.birds)
        }
    }


}
