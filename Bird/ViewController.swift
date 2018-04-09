//
//  ViewController.swift
//  Bird
//
//  Created by Pavel Burdukovskii on 08/04/18.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchData = [String]()
    var viewData = [BirdViewData]()
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    let presenter  = BirdPresenter(service: GeneralService())
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        presenter.atachView(view: self as ViewBuild)
        presenter.getData(APISelected.get_bird.rawValue, [:], withName: "", imageArr: [])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
//        for (_, index) in viewData.enumerated(){
//            print("Index = ", index.birds)
//        }
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchData[indexPath.row]
        return cell
    }

    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData.count
    }

    
}
