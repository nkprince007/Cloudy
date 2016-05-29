//
//  ViewController.swift
//  Cloudy
//
//  Created by Naveen Kumar Sangi on 28/05/16.
//  Copyright © 2016 Naveen Kumar Sangi. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let swipeRec = UISwipeGestureRecognizer()

    //Current Weather Outlets
    
    @IBOutlet weak var windBag: UIImageView!
    @IBOutlet weak var umbrella: UIImageView!
    @IBOutlet weak var rainDrop: UIImageView!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var degreeButton: UIButton!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var heatIndex: UIImageView!
    @IBOutlet weak var dayZeroTemperatureLowLabel: UILabel!
    @IBOutlet weak var dayZeroTemperatureHighLabel: UILabel!
    
    @IBOutlet weak var windUILabel: UILabel!
    @IBOutlet weak var rainUILabel: UILabel!
    @IBOutlet weak var humidityUILabel: UILabel!
    
    //Daily Weather Outlets
    
    @IBOutlet weak var dayZeroTemperatureLow: UILabel!
    @IBOutlet weak var dayZeroTemperatureHigh: UILabel!
    
    @IBOutlet weak var dayOneWeekDayLabel: UILabel!
    @IBOutlet weak var dayTwoWeekDayLabel: UILabel!
    @IBOutlet weak var dayThreeWeekDayLabel: UILabel!
    @IBOutlet weak var dayFourWeekDayLabel: UILabel!
    @IBOutlet weak var dayFiveWeekDayLabel: UILabel!
    @IBOutlet weak var daySixWeekDayLabel: UILabel!
    
    @IBOutlet weak var dayOneHighLow: UILabel!
    @IBOutlet weak var dayTwoHighLow: UILabel!
    @IBOutlet weak var dayThreeHighLow: UILabel!
    @IBOutlet weak var dayFourHighLow: UILabel!
    @IBOutlet weak var dayFiveHighLow: UILabel!
    @IBOutlet weak var daySixHighLow: UILabel!
    
    @IBOutlet weak var dayOneImage: UIImageView!
    @IBOutlet weak var dayTwoImage: UIImageView!
    @IBOutlet weak var dayThreeImage: UIImageView!
    @IBOutlet weak var dayFourImage: UIImageView!
    @IBOutlet weak var dayFiveImage: UIImageView!
    @IBOutlet weak var daySixImage: UIImageView!
    
    //Alerts outlets
    
    @IBOutlet weak var wAlerts: UILabel!
    
    
    
    private let apiKey = "a5d4030e5070beefbaceadd48d77bf3e" // https://developer.forecast.io API KEY
    
    var audioPlayer = AVAudioPlayer()
    
    var seenError = false
    var locationFixAchieved = false
    var locationStatus = "Not Started"
    var locationManager: CLLocationManager!
    var userLocation: String!
    var userLatitude: Double!
    var userLongitude: Double!
    var userTemperatureCelsius: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        swipeRec.addTarget(self, action: #selector(ViewController.swipedView))
        swipeRec.direction = .Down
        swipeView.addGestureRecognizer(swipeRec)
        
        refresh()
    }
    
    func swipedView() {
        self.swooshsound()
        refresh()
    }
    
    func refresh() {
        initLocationManager()
        animateDisplay()
    }
    
    //LOCATION SETUP AND LOAD
    
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        print("location manager initialized")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks,error)->Void in
            let pm = placemarks?[0]
            self.displayLocationInfo(pm)
        })
        
        if(locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations
            if let locationObject = locationArray.last {
                let coord = locationObject.coordinate
                self.userLatitude = coord.latitude
                self.userLongitude = coord.longitude
                
                getCurrentWeatherData()
            }
        }
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            print("Locality:\(locality)\nPostalCode:\(postalCode)\nAdministrativeArea:\(administrativeArea)\nCountry:\(country)")
            
            NSLog("Locality:\(locality)\nPostalCode:\(postalCode)\nAdministrativeArea:\(administrativeArea)\nCountry:\(country)")
            
            let string = "\(locality!), \(administrativeArea), \(country)!)"
            
            self.userLocationLabel.text = string
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case .Restricted:
            locationStatus = "Restricted Access to location"
        case .Denied:
            locationStatus = "User denied access to location"
        case .NotDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        NSNotificationCenter.defaultCenter().postNotificationName("LabelHasBeenUpdated",object: nil)
        if shouldIAllow {
            NSLog("Location to Allowed")
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }
    
    func animateDisplay() {
        
        temperatureLabel.alpha = 0.0
        dayOneImage.alpha = 0.0
        dayTwoImage.alpha = 0.0
        dayThreeImage.alpha = 0.0
        dayFourImage.alpha = 0.0
        dayFiveImage.alpha = 0.0
        daySixImage.alpha = 0.0
        dayZeroTemperatureLow.alpha = 0.0
        dayZeroTemperatureHigh.alpha = 0.0
        windSpeedLabel.alpha = 0.0
        humidityLabel.alpha = 0.0
        precipitationLabel.alpha = 0.0
        rainUILabel.alpha = 0.0
        dayOneWeekDayLabel.alpha = 0.0
        dayTwoWeekDayLabel.alpha = 0.0
        dayThreeWeekDayLabel.alpha = 0.0
        dayFourWeekDayLabel.alpha = 0.0
        dayFiveWeekDayLabel.alpha = 0.0
        daySixWeekDayLabel.alpha = 0.0
        dayOneHighLow.alpha = 0.0
        dayTwoHighLow.alpha = 0.0
        dayThreeHighLow.alpha = 0.0
        dayFourHighLow.alpha = 0.0
        dayFiveHighLow.alpha = 0.0
        daySixHighLow.alpha = 0.0
        wAlerts.alpha = 0.0
        
        sendForAnimation()
        
        UIView.animateWithDuration(1.5, animations: {
            self.temperatureLabel.alpha = 1.0
            self.dayOneImage.alpha = 1.0
            self.dayTwoImage.alpha = 1.0
            self.dayThreeImage.alpha = 1.0
            self.dayFourImage.alpha = 1.0
            self.dayFiveImage.alpha = 1.0
            self.daySixImage.alpha = 1.0
            self.dayZeroTemperatureLow.alpha = 1.0
            self.dayZeroTemperatureHigh.alpha = 1.0
            self.windSpeedLabel.alpha = 1.0
            self.humidityLabel.alpha = 1.0
            self.precipitationLabel.alpha = 1.0
            self.rainUILabel.alpha = 1.0
            self.dayOneWeekDayLabel.alpha = 1.0
            self.dayTwoWeekDayLabel.alpha = 1.0
            self.dayThreeWeekDayLabel.alpha = 1.0
            self.dayFourWeekDayLabel.alpha = 1.0
            self.dayFiveWeekDayLabel.alpha = 1.0
            self.daySixWeekDayLabel.alpha = 1.0
            self.dayOneHighLow.alpha = 1.0
            self.dayTwoHighLow.alpha = 1.0
            self.dayThreeHighLow.alpha = 1.0
            self.dayFourHighLow.alpha = 1.0
            self.dayFiveHighLow.alpha = 1.0
            self.daySixHighLow.alpha = 1.0
            self.wAlerts.alpha = 1.0
        })
    }
    
    func sendForAnimation() {
        //DAILY
        self.dayZeroTemperatureLowLabel.transform = CGAffineTransformMakeTranslation(-300, 0)
        self.dayZeroTemperatureHighLabel.transform = CGAffineTransformMakeTranslation(300, 0)
        self.windBag.transform = CGAffineTransformMakeTranslation(0, -600)
        self.umbrella.transform = CGAffineTransformMakeTranslation(0, -600)
        self.rainDrop.transform = CGAffineTransformMakeTranslation(0, -600)
        self.iconView.transform = CGAffineTransformMakeTranslation(-200, 0)
        self.temperatureLabel.transform = CGAffineTransformMakeTranslation(300, 0)
        self.summaryLabel.transform = CGAffineTransformMakeTranslation(0, -200)
        self.heatIndex.transform = CGAffineTransformMakeTranslation(-350, 0)
        self.userLocationLabel.transform = CGAffineTransformMakeTranslation(350, 0)
        self.degreeButton.transform = CGAffineTransformMakeTranslation(350,0)
        self.windUILabel.transform = CGAffineTransformMakeTranslation(-350,0)
        self.humidityUILabel.transform = CGAffineTransformMakeTranslation(350,0)
        self.degreeButton.transform = CGAffineTransformMakeTranslation(350, 0)
        
        
        //WEEKLY
        self.dayOneImage.transform = CGAffineTransformMakeTranslation(0, 100)
        self.dayTwoImage.transform = CGAffineTransformMakeTranslation(0, 100)
        self.dayThreeImage.transform = CGAffineTransformMakeTranslation(0, 100)
        self.dayFourImage.transform = CGAffineTransformMakeTranslation(0, 100)
        self.dayFiveImage.transform = CGAffineTransformMakeTranslation(0, 100)
        self.daySixImage.transform = CGAffineTransformMakeTranslation(0, 100)
        
        //DAILY SPRING ACTION
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.userLocationLabel.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        springWithDelay(0.9, delay: 0.60, animations: {
            self.degreeButton.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        springWithDelay(0.9, delay: 0.25, animations: {
            self.windBag.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        springWithDelay(0.9, delay: 0.35, animations: {
            self.umbrella.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        springWithDelay(0.9, delay: 0.45, animations: {
            self.rainDrop.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.iconView.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.temperatureLabel.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        springWithDelay(0.9, delay: 0.60, animations: {
            self.summaryLabel.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        springWithDelay(0.9, delay: 0.45, animations: {
            self.heatIndex.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.dayZeroTemperatureLowLabel.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.dayZeroTemperatureHighLabel.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.userLocationLabel.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.windUILabel.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.humidityUILabel.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        
        //WEEKLY FORCAST SPRING ACTION
        springWithDelay(0.9, delay: 0.25, animations: {
            self.dayOneImage.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        springWithDelay(0.9, delay: 0.35, animations: {
            self.dayTwoImage.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.dayThreeImage.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        springWithDelay(0.9, delay: 0.55, animations: {
            self.dayFourImage.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        springWithDelay(0.9, delay: 0.65, animations: {
            self.dayFiveImage.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        springWithDelay(0.9, delay: 0.75, animations: {
            self.daySixImage.transform = CGAffineTransformMakeTranslation(0, 0)
            
        })

    }

    // SOUNDS
    
    func swooshsound() {
        
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("swoosh", ofType: "wav")!)
//        print(alertSound)
        
        var error:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: alertSound)
        } catch let error1 as NSError {
            error = error1
            print(error)
            
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        
    }

    
    func getCurrentWeatherData() {
        userLocation = "\(userLatitude),\(userLongitude)"
        
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: "\(userLocation)", relativeToURL:baseURL)
        
        //72.371224,-41.382676 GreenLand (Cold Place!)
        //\(userLocation) (YOUR LOCATION!)
        
        print(userLocation)
        
        let sharedSession = NSURLSession.sharedSession()
        
        let downloadTask = sharedSession.downloadTaskWithURL(forecastURL!,completionHandler: {
        
            (location: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if error == nil {
                
                let dataObject = NSData(contentsOfURL: location!)
                let weatherDictionary = try! NSJSONSerialization.JSONObjectWithData(dataObject!, options:[])
                
                //TEST Connection and API 
//                print(weatherDictionary)
                
                let current = Currently(weatherDictionary: weatherDictionary as! [String : AnyObject])
                
                print(current)
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    
                    //Current data display
                    if let _ = current.temperature {
                        self.temperatureLabel.text = "\(Fahrenheit2Celsius(current.temperature!))"
                    }
                    self.iconView.image = current.icon
                    self.precipitationLabel.text = "\(current.precipProbability!)"
                    self.humidityLabel.text = "\(current.humidity!)"
                    self.summaryLabel.text = "\(current.summary!)"
                    self.windSpeedLabel.text = "\(current.windSpeed!)"
                    
                    let path = NSBundle.mainBundle().resourcePath
                    try! dataObject?.writeToFile(path!+"/contents1.json", options:[])
                }
                
            } else {
                
                if let reason = error {
                    let networkIssueController = UIAlertController(title: "Issue Detected", message: reason.localizedDescription, preferredStyle: .Alert)
                    let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    networkIssueController.addAction(okButton)
                    let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                    networkIssueController.addAction(cancelButton)
                    self.presentViewController(networkIssueController, animated: true, completion: nil)
                    
                } else {
                    print("Error NULL")
                }
                
                let fm = NSFileManager.defaultManager()
                let path = NSBundle.mainBundle().resourcePath
                if let item = fm.contentsAtPath(path!+"/contents.json") {
                
                    let dataObject = item
                    let weatherDictionary = try! NSJSONSerialization.JSONObjectWithData(dataObject, options:[NSJSONReadingOptions.AllowFragments])
                    
//                    print(weatherDictionary)
                    
                    let current = Currently(weatherDictionary: weatherDictionary as! [String : AnyObject])
                    let daily = Daily(weatherDictionary: weatherDictionary as! [String : AnyObject])
//                    print(current)
                    print(daily)
                
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        //Current data display
                        if let _ = current.temperature {
                            self.temperatureLabel.text = "\(Fahrenheit2Celsius(current.temperature!))"
                        }
                        self.iconView.image = current.icon
                        self.precipitationLabel.text = "\(current.precipProbability!)"
                        self.humidityLabel.text = "\(current.humidity!)"
                        self.summaryLabel.text = "\(current.summary!)"
                        self.windSpeedLabel.text = "\(current.windSpeed!)"

                    }
                }
            }
            
        })
        
        downloadTask.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

