

//
//  HomeController.swift
//  TplResources
//
//  Created by alessio giacobbe on 17/10/16.
//  Copyright © 2016 alessio giacobbe. All rights reserved.
//

import UIKit

class HomeController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var navstack: UIStackView!
    @IBOutlet weak var NewsStack: UIStackView!
    @IBOutlet weak var NewsTItle: UILabel!
    @IBOutlet weak var NewsBigTItle: UILabel!
    @IBOutlet weak var feedstack: UIStackView!
    @IBOutlet weak var addresslabel: UILabel!
    @IBOutlet weak var settings: UIImageView!
    let locationManager = CLLocationManager()
    var location = CLLocation()
    var coordinates = CLLocationCoordinate2D()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GMSServices.provideAPIKey("AIzaSyAG6Yw-fOGqUjLWE0FFI6VMtb9BQtUEV-Q")
        
        self.navigationController!.navigationBar.tintColor = UIColor.black
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        
        if UserDefaults.standard.string(forKey: "Loc_Name") != nil {
            let locaname = replaceoptional(input: UserDefaults.standard.string(forKey: "Loc_Name")!)
            
            NewsBigTItle.text = "Notizie su \(locaname)"
            NewsTItle.text = "Ricevi le ultime notizie su \(locaname)"
        }
        
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }

        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        locationManager.startUpdatingLocation()
        
        let feedtap = UITapGestureRecognizer(target: self, action: Selector("feedtap"))
        feedtap.delegate = self
        feedstack.addGestureRecognizer(feedtap)
        
        let newstap = UITapGestureRecognizer(target: self, action: Selector("newstap"))
        newstap.delegate = self
        NewsStack.addGestureRecognizer(newstap)
        
        let navtap = UITapGestureRecognizer(target: self, action: Selector("navtap"))
        navtap.delegate = self
        navstack.addGestureRecognizer(navtap)
        
        
        let imagerec = UITapGestureRecognizer(target:self, action:Selector("settingschange"))
        settings.addGestureRecognizer(imagerec)
    }
    
    
    func replaceoptional(input: String) -> String {         //sicuramente c'è un modo giusto di fare ques_ ta cosa, ma tutto quello che trovo non funziona, quindi mi arrangio, odio gli optional comunque
        let newString = input.replacingOccurrences(of: "Optional(", with: "")
        let finalString = newString.replacingOccurrences(of: ")", with: "")
        return finalString
    }
    
    
    func settingschange(){
        self.performSegue(withIdentifier: "OptionShow", sender: nil)
    }
    
    func feedtap(){
        self.performSegue(withIdentifier: "feedshow", sender: nil)
    }
    
    
    func newstap(){
        self.performSegue(withIdentifier: "newsshow", sender: nil)
    }
    
    func navtap(){
        self.performSegue(withIdentifier: "navshow", sender: nil)
    }
    
    func settingstap(){
        self.performSegue(withIdentifier: "AfterLogin", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "navshow") {
            var svc = segue.destination as! NavigatoreViewController;
            
            svc.long = coordinates.longitude
            svc.lat = coordinates.latitude
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coordinates = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            //print(myLocation)
            
            if error != nil{
                print("errore nella conversione")
                return
            }
            
            if placemarks!.count > 0 {
                let placemark = (placemarks?[0])! as CLPlacemark
                let address = placemark.thoroughfare!
                self.addresslabel.text = "Rilascia un feedback per la tratta di \(address)"
                //print("via :\(address)")
            }
            
        })
    }

}
