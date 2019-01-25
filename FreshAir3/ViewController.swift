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


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let man = CLLocationManager()
    var hoursLabel: UILabel!
    var minsLabel: UILabel!
    var dateLabel: UILabel!
    var factLabel: UILabel!
    let date = Date()
    let calendar = Calendar.current
    var labelNum = 0
    let shapeLayer = CAShapeLayer()
    let goalHours = 1
    let goalMins = 0

    
    var funFacts = ["The outdoors provides sensory stimulation to eliminate boredom, boosts serotonin levels to improve mood, and allows for more interaction between people to improve self esteem, and prevent feelings of loneliness and depression.", "When the skin is exposed to sunlight for 15 minutes or more, cholesterol in the skin starts to transform into vitamin D, which lowers blood cholesterol levels. This is helpful in preventing cardiovascular diseases such as heart attack, TIA, stroke, and peripheral artery disease.", "There are many fun ways to go outside and get some fresh air: walk to school/work, garden, read outside, play/watch outdoor sports, have a picnic, or attend an outdoor recreational activity.",  "Plants emit airborne chemicals called phytoncides which not only protect them from insects and rot, but in humans, can result in greater physical relaxation, lower blood pressure, improved heart rate, and lower amounts of the stress hormone cortisol.", "While people are indoors, they inhale dust, waste, and toxins. Breathing stale air for a long period of time can lead to a buildup of toxins causing fatigue, headaches, anxiety, and respiratory illnesses.","Absorption of vitamin D through the skin reduces risk of developing bone diseases like osteoporosis and osteomalacia.", "Exposure to sunshine and fresh air can lead to an increase in white blood cell (eg. neutrophils and monocytes) production. Fresh air also enables white blood cells to function, by providing them with lots of oxygen. This results in stronger immune function and thus greater protection against disease.", "Daylight at the same time every day can help a person develop a regulated sleep pattern by delaying the release the sleep-inducing hormone called melatonin, so that it is easier to fall asleep when the sun goes down.", "Absorption of vitamin D through the skin can lower the risk of cancer (breast, ovarian, prostate, colon), and other diseases like MS, type 1 diabetes, and heart disease."]
    
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
        
        //_ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(ViewController.checkLocation), userInfo: nil, repeats: true)
        
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
    
    @objc func changeFact(){
        if (labelNum < 8){
            labelNum += 1;
        }
        else {
            labelNum = 0;
        }
        factLabel.text = funFacts[labelNum]
        view.addSubview(factLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 81/255.0, green: 185/255.0, blue: 237/255.0, alpha: 1.0)
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
        
        
        factLabel = UILabel()
        factLabel.textColor = UIColor.white
        factLabel.font = UIFont.init(name: "HelveticaNeue-Thin", size: 20)
        factLabel.numberOfLines = 0
        //factLabel.center = CGPoint(x: 25, y: 570)
        factLabel.frame = CGRect(x: 10, y: 430, width: 350, height: 190)
        factLabel.textAlignment = .center
        //factLabel.sizeToFit()
        factLabel.lineBreakMode = .byWordWrapping
        factLabel.text = funFacts[labelNum]
        view.addSubview(factLabel)
        _ = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector:  #selector(ViewController.changeFact), userInfo: nil, repeats: true)
        
        
        var centre = view.center
        centre.y -= 80
        
       let trackLayer = CAShapeLayer()
        let circularPath1 = UIBezierPath(arcCenter: centre, radius: 140, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)
        
        
        trackLayer.path = circularPath1.cgPath
        trackLayer.strokeColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.6).cgColor
        trackLayer.lineWidth = 15
        trackLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackLayer)
        mins = 40
        shapeLayer.strokeEnd = 0
        let percentage = (CGFloat(60*hours + mins)/CGFloat(60*goalHours + goalMins))
        let circularPath2 = UIBezierPath(arcCenter: centre, radius: 140, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi*percentage - CGFloat.pi/2, clockwise: true)
    
        shapeLayer.path = circularPath2.cgPath
        //shapeLayer.strokeEnd = percentage
        
        view.layer.addSublayer(shapeLayer)
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        //shapeLayer.strokeEnd = 0
       
        
        
        
        
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 3
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "turn")
        
 
        
        //man.startMonitoringSignificantLocationChanges()
        //man.stopMonitoringSignificantLocationChanges()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}
