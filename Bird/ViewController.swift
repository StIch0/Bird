import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchData = [String]()
    var viewData = [BirdViewData]()
    var birdsArray = [String]()
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    let presenter  = BirdPresenter(service: GeneralService())
    let disposeBag = DisposeBag()
     override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        presenter.atachView(view: self as ViewBuild)
        presenter.getData(APISelected.get_bird.rawValue, [:], withName: "", imageArr: [])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchBird()
        birdsArray = DataBaseManager.shared.fetchFromCoreData(entityName: "BirdEntity", key: "birds") as! [String]
 
    }
    func searchBird() {
        searchBar
            .rx
            .text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .debounce(0.5, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            .filter { !$0.isEmpty } // If the new value is really new, filter for non-empty query.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                self.searchData = self.birdsArray.filter { $0.hasPrefix(query) } // We now do our "API Request" to find cities.
                self.tableView.reloadData() // And reload table view data.
            })
            .addDisposableTo(disposeBag)// Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with:event)
        self.view.endEditing(true)
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
        tableView.isHidden = true
    }

    internal func setData(data: [ViewData]) {
        viewData = data as! [BirdViewData]
        tableView.isEditing = false
        birdsArray = (viewData.first?.birds)!
        DataBaseManager.shared.saveContext(birdsArray as AnyObject, entityName: "BirdEntity", key: "birds")
      }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
         return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.text = searchData[indexPath.row]
     }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
         cell.textLabel?.text = searchData[indexPath.row]
        return cell
    }

    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }

    
}
