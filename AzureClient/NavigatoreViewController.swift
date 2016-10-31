//
//  NavigatoreViewController.swift
//  TplResources
//
//  Created by alessio giacobbe on 21/10/16.
//  Copyright © 2016 alessio giacobbe. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class NavigatoreViewController: UIViewController {

    @IBOutlet weak var busimg: UIImageView!
    @IBOutlet weak var to: UITextField!
    @IBOutlet weak var effectscreen: UIVisualEffectView!
    @IBOutlet weak var from: UITextField!
    @IBOutlet weak var mappaview: GMSMapView!
    @IBOutlet weak var blurview: UIVisualEffectView!
    var long:Double!
    var lat:Double!
    var effect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        effect = effectscreen.effect
        effectscreen.effect = nil
        self.navigationController!.navigationBar.tintColor = UIColor.black;
        blurview.layer.cornerRadius = 15
        blurview.clipsToBounds = true
        // Do any additional setup after loading the view.
        print("passati \(long!) e lat \(lat!)")
        let bustap = UITapGestureRecognizer(target: self, action: Selector("bustap"))
        busimg.isUserInteractionEnabled = true
        busimg.addGestureRecognizer(bustap)
        
        
    }
    

    @IBAction func Search(_ sender: AnyObject) {
        self.geodecode(from: self.from.text!, to: self.to.text!)
    }
    
    func geodecode(from: String, to: String ){
        mappaview.clear()
        let frommarker = GMSMarker()
        let tomarker = GMSMarker()
        CLGeocoder().geocodeAddressString(from, completionHandler: {(placemarks, error) in
            if error != nil{
                print(error)
                return
            }
            if (placemarks?.count)! > 0{
                let pl = placemarks?[0]
                let fromcord = pl?.location?.coordinate
                frommarker.position = fromcord!
                frommarker.title = "Partenza"
                frommarker.isFlat = true
                
                self.mappaview.camera = GMSCameraPosition(target: fromcord!, zoom: 15, bearing: 0, viewingAngle: 0)
                CLGeocoder().geocodeAddressString(to, completionHandler: {(placemarks, error) in
                    if error != nil{
                        print(error)
                        return
                    }
                    if (placemarks?.count)! > 0{
                        let pl = placemarks?[0]
                        let tocord = pl?.location?.coordinate
                        tomarker.position = tocord!
                        tomarker.isFlat = true
                        tomarker.title = "destinazione"
                        let directionURL:String = "https://maps.googleapis.com/maps/api/directions/json?origin=\(frommarker.position.latitude),\(frommarker.position.longitude)&destination=\(tomarker.position.latitude),\(tomarker.position.longitude)&key=AIzaSyAG6Yw-fOGqUjLWE0FFI6VMtb9BQtUEV-Q"
                        print("URL \(directionURL)")
                        let request = URLRequest(url: NSURL(string:directionURL)! as URL)
                        let session = URLSession.shared
                        let task = URLSession.shared.dataTask(with: request) {
                            data, response, error in
                            if let data = data, let jsonString = String(data: data, encoding: String.Encoding.utf8) , error == nil {
                                do{
                                    
                                    let jsonfinale = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                    print(jsonfinale)
                                    if let routes = jsonfinale["routes"] as? NSArray{
                                        if let route = routes.firstObject as? NSDictionary{
                                        if let poly = route.value(forKey: "overview_polyline") as? NSDictionary{
                                            print("POLI \(poly.count)")
                                            if let points = poly.value(forKey: "points") as? String{
                                                DispatchQueue.main.async {
                                                    
                                                    let path = GMSPath(fromEncodedPath: points)
                                                    let line = GMSPolyline(path: path)
                                                    
                                                    line.map = self.mappaview
                                                }
                                                
                                            }
                                            
                                            
                                        }else{
                                            print("NO POLI")
                                        }
                                        }
                                    }else{
                                        print("NO ROUTES")
                                    }
                                    
                                }catch {
                                    
                                }
                                
                                print("fatto")
                            } else {
                                print("ERRORE=\(error!.localizedDescription)")
                            }
                        }
                        task.resume()
                        

                    }
                })
                
            }
        })
        frommarker.map = mappaview
        tomarker.map = mappaview
        
    }
    
    func bustap(){
        UIView.animate(withDuration: 0.4, animations: {
            self.effectscreen.effect = self.effect
        })
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
