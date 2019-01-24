//
//  ViewController.swift
//  Breathe Dp
//
//  Created by Serena Hacker
//  Copyright © 2018 Serena Hacker. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

//extension UILabel{
//    var minHeight: CGFloat{
//        get{
//            let factLabel = UILabel(frame:CGRect(x: 0, y: 0, width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude))
//            factLabel.numberOfLines = 0
//            factLabel.lineBreakMode = .byWordWrapping
//            factLabel.font = self.font
//            factLabel.text = self.text
//            return factLabel.frame.height
//        }
//    }
//
//
//}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let man = CLLocationManager()
    var hoursLabel: UILabel!
    var minsLabel: UILabel!
    var dateLabel: UILabel!
    var factLabel: UILabel!
    let date = Date()
    let calendar = Calendar.current

    //hours and minutes spent outside - reset to 0 every day at midnight
    var hours = 0
    var mins = 0
    
    @objc func resetTime(){
        hours = 0
        mins = 0
    }
    
    let cDate = Date(timeIntervalSinceReferenceDate: 0)
    //Make this reset to zero at midnight. (To do)
    lazy var timer = Timer (fireAt: cDate, interval: 86400, target: self, selector: #selector(ViewController.resetTime), userInfo: nil, repeats: true)
    
     //Want to do this only every 1 minute
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        print(lat)
        print(long)
        

        var location2D:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        
        
        
        let PS = GMSPanoramaService()
    
        
        PS.requestPanoramaNearCoordinate(location2D, radius:10, callback: {(GMSPanorama: GMSPanorama?, Error: Error?) in
            // put source: argument back in to requestPanorama...
            
            if GMSPanorama != nil {
                print ("outside")
                self.mins += 1
            }
            else{
                print("inside")
            }
            
        })
        //prints number of hours and minutes onto screen
        hours = mins/60
        mins %= 60
        
        hoursLabel.textColor = UIColor.white
        hoursLabel.text = "\(hours) hours"
        hoursLabel.font = UIFont.systemFont(ofSize: 40)
        hoursLabel.sizeToFit()
        hoursLabel.center = CGPoint(x: 100, y: 200)
        view.addSubview(hoursLabel)
        
        minsLabel.textColor = UIColor.white
        minsLabel.text = "\(mins) minutes"
        minsLabel.font = UIFont.systemFont(ofSize: 40)
        minsLabel.sizeToFit()
        minsLabel.center = CGPoint(x: 100, y: 300)
        view.addSubview(minsLabel)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        if let clErr = error as? CLError {
            switch clErr {
            case CLError.locationUnknown:
                print("location unknown")
            case CLError.denied:
                print("denied")
            default:
                print("other Core Location error")
            }
        } else {
            print("other error:", error.localizedDescription)
        }
    }
    
    
    @objc func checkLocation(){
        man.requestLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 71/255.0, green: 181/255.0, blue: 241/255.0, alpha: 1.0)
        man.delegate = self
        man.desiredAccuracy = kCLLocationAccuracyBest
        man.requestAlwaysAuthorization()
        man.requestWhenInUseAuthorization()
        man.allowsBackgroundLocationUpdates = true
        _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(ViewController.checkLocation), userInfo: nil, repeats: true)
        

        
        //print date at top of screen
        dateLabel = UILabel()
        dateLabel.textColor = UIColor.white
        dateLabel.font = UIFont.init(name: "HelveticaNeue", size: 30)
        dateLabel.text = String (format: "%02d, %02d, %04d",calendar.component(.month, from: date), calendar.component(.day, from: date), calendar.component(.year, from: date))
        dateLabel.sizeToFit()
        dateLabel.center = CGPoint(x: 100, y: 50)
        view.addSubview(dateLabel)
        
        
        hoursLabel = UILabel()
        minsLabel = UILabel()
        
        
        
        //var funFacts = ["test", "The outdoors provides sensory stimulation to eliminate boredom, boosts serotonin levels to improve mood, and allows for more interaction between people to improve self esteem, and prevent feelings of loneliness and depression.", "2"]
//        factLabel = UILabel()
//        factLabel.textColor = UIColor.white
//        factLabel.font = UIFont.init(name: "HelveticaNeue", size: 20)
//        factLabel.text = funFacts[1]
//        factLabel.sizeToFit()
//        factLabel.center = CGPoint(x: 25, y: 570)
//        factLabel.lineBreakMode = .byWordWrapping
//        view.addSubview(factLabel)
        
        
        
        //man.startMonitoringSignificantLocationChanges()
        //man.stopMonitoringSignificantLocationChanges()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}
