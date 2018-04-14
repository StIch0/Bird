import UIKit
import RxSwift
import RxCocoa
import CoreLocation
class ViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchData = [String]()
    var viewData = [BirdViewData]()
    var birdsArray = [String]()
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    let presenter  = BirdPresenter(service: GeneralService())
    let disposeBag = DisposeBag()
    let db = DataBaseManager.shared
    var images : [UIImage] = Array()
    var locationManager = CLLocationManager()

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func btnPostData(_ sender: Any) {
        
        let postPresenter = ResultPresenter(service: GeneralService())
        var postViewData = [ResultViewData]()
        postPresenter.atachView(view: self as ViewBuild)
        postPresenter.getData(APISelected.coords_from_app.rawValue, [:], withName: "", imageArr: images)
        
    }
    @IBAction func btnOpenCamera(_ sender: Any) {
        //open camera, photo, save in collection view, add in array.
        
    }
    
    @IBAction func findLocation(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
         }
        
    }

     override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get current gps location
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        
        activityIndicator.hidesWhenStopped = true
        presenter.atachView(view: self as ViewBuild)
        //get bird data
        presenter.getData(APISelected.get_bird.rawValue, [:], withName: "", imageArr: [])
        //table view settings
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //search bird with use RxSwift
        searchBird()
        //get list of birds with help CoreData
        birdsArray = db.fetchFromCoreData(entityName: "BirdEntity", key: "birds") as! [String]
 
    }
    //get current position
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("location = " ,  locValue.longitude,locValue.latitude)
//        let userLocation :CLLocation = locations[0] as CLLocation
//        
//        print("user latitude = \(userLocation.coordinate.latitude)")
//        print("user longitude = \(userLocation.coordinate.longitude)")
//        
//        print("\(userLocation.coordinate.latitude)")
//        print("\(userLocation.coordinate.longitude)")
//        
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
//            if (error != nil){
//                print("error in reverseGeocode")
//            }
//            let placemark = placemarks! as [CLPlacemark]
//            if placemark.count>0{
//                let placemark = placemarks![0]
//                print(placemark.locality!)
//                print(placemark.administrativeArea!)
//                print(placemark.country!)
//                
//                print("\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)")
//            }
//        }
//
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
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
    //hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with:event)
        self.view.endEditing(true)
    }
    
}

extension ViewController : ViewBuild {
    //use for activityIndicator, start and stop this
    internal func stopLoading() {
        activityIndicator.stopAnimating()
    }

    internal func startLoading() {
        activityIndicator.startAnimating()
    }

    internal func setEmptyData() {
        tableView.isHidden = true
    }
    //set data, from request
    internal func setData(data: [ViewData]) {
        viewData = data as! [BirdViewData]
        tableView.isEditing = false
        birdsArray = (viewData.first?.birds)!
        //save list of birds
        db.saveContext(birdsArray as AnyObject, entityName: "BirdEntity", key: "birds")
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
