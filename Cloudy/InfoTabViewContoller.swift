//
//  InfoTabViewContoller.swift
//  Cloudy
//
//  Created by Naveen Kumar Sangi on 30/05/16.
//  Copyright © 2016 Naveen Kumar Sangi. All rights reserved.
//

import UIKit
import AVFoundation

class InfoTabViewController: UIViewController {
    var detailItem: [String: AnyObject]?
    let urlString = "http://developer.forecast.io"

    // URL FOR DEVS

    @IBOutlet weak var forecastLink: UIButton!

    // VALUE OUTLETS

    @IBOutlet weak var realFeelValue: UILabel!
    @IBOutlet weak var cloudCoverValue: UILabel!
    @IBOutlet weak var ozoneValue: UILabel!
    @IBOutlet weak var precipitationValue: UILabel!
    @IBOutlet weak var pressureValue: UILabel!
    @IBOutlet weak var visibilityValue: UILabel!
    @IBOutlet weak var windDirectionValue: UILabel!

    // CORRESPONDING LABEL OUTLETS

    @IBOutlet weak var realFeelLabel: UILabel!
    @IBOutlet weak var cloudCoverLabel: UILabel!
    @IBOutlet weak var ozoneLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!

    // BACK BUTTON OUTLET
    @IBOutlet weak var backButton: UIButton!
    


    var audioPlayer = AVAudioPlayer()

    @IBAction func openForecastLink(sender: UIButton) {
        if let url = NSURL(string: urlString) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    override func viewDidLoad() {
        alert()
        alphaAdjust()
        displayData()
    }

    override func viewDidAppear(animated: Bool) {
        animate()
    }

    // SOUNDS

    func alert() {
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("popit", ofType: "wav")!)
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

    // ANIMATIONS

    func animate() {

        let initialDelay = 0.1

        self.realFeelLabel.transform = CGAffineTransformMakeTranslation(-300, 0)
        self.realFeelValue.transform = CGAffineTransformMakeTranslation(300, 0)
        self.ozoneLabel.transform = CGAffineTransformMakeTranslation(-300, 0)
        self.ozoneValue.transform = CGAffineTransformMakeTranslation(300, 0)
        self.precipitationLabel.transform = CGAffineTransformMakeTranslation(-300, 0)
        self.precipitationValue.transform = CGAffineTransformMakeTranslation(300, 0)
        self.cloudCoverLabel.transform = CGAffineTransformMakeTranslation(-300, 0)
        self.cloudCoverValue.transform = CGAffineTransformMakeTranslation(300, 0)
        self.pressureLabel.transform = CGAffineTransformMakeTranslation(-300, 0)
        self.pressureValue.transform = CGAffineTransformMakeTranslation(300, 0)
        self.visibilityLabel.transform = CGAffineTransformMakeTranslation(-300, 0)
        self.visibilityValue.transform = CGAffineTransformMakeTranslation(300, 0)
        self.windDirectionLabel.transform = CGAffineTransformMakeTranslation(-300, 0)
        self.windDirectionValue.transform = CGAffineTransformMakeTranslation(300, 0)

        UIView.animateWithDuration(initialDelay, animations: {

            self.realFeelLabel.alpha = 1.0
            self.realFeelValue.alpha = 1.0
            self.ozoneLabel.alpha = 1.0
            self.ozoneValue.alpha = 1.0
            self.precipitationLabel.alpha = 1.0
            self.precipitationValue.alpha = 1.0
            self.cloudCoverLabel.alpha = 1.0
            self.cloudCoverValue.alpha = 1.0
            self.pressureLabel.alpha = 1.0
            self.pressureValue.alpha = 1.0
            self.visibilityLabel.alpha = 1.0
            self.visibilityValue.alpha = 1.0
            self.windDirectionLabel.alpha = 1.0
            self.windDirectionValue.alpha = 1.0

        })

        springWithDelay(0.9, delay: initialDelay, animations: {
            self.realFeelLabel.transform = CGAffineTransformMakeTranslation(0, 0)
            self.realFeelValue.transform = CGAffineTransformMakeTranslation(0, 0)
        })

        springWithDelay(0.9, delay: initialDelay+0.1, animations: {
            self.cloudCoverLabel.transform = CGAffineTransformMakeTranslation(0, 0)
            self.cloudCoverValue.transform = CGAffineTransformMakeTranslation(0, 0)
        })

        springWithDelay(0.9, delay: initialDelay+0.2, animations: {
            self.ozoneLabel.transform = CGAffineTransformMakeTranslation(0, 0)
            self.ozoneValue.transform = CGAffineTransformMakeTranslation(0, 0)
        })

        springWithDelay(0.9, delay: initialDelay+0.3, animations: {
            self.precipitationLabel.transform = CGAffineTransformMakeTranslation(0, 0)
            self.precipitationValue.transform = CGAffineTransformMakeTranslation(0, 0)
        })

        springWithDelay(0.9, delay: initialDelay+0.4, animations: {
            self.pressureLabel.transform = CGAffineTransformMakeTranslation(0, 0)
            self.pressureValue.transform = CGAffineTransformMakeTranslation(0, 0)
        })        

        springWithDelay(0.9, delay: initialDelay+0.5, animations: {
            self.visibilityLabel.transform = CGAffineTransformMakeTranslation(0, 0)
            self.visibilityValue.transform = CGAffineTransformMakeTranslation(0, 0)
        })

        springWithDelay(0.9, delay: initialDelay+0.6, animations: {
            self.windDirectionLabel.transform = CGAffineTransformMakeTranslation(0, 0)
            self.windDirectionValue.transform = CGAffineTransformMakeTranslation(0, 0)
        })

        springWithDelay(0.9, delay: initialDelay+0.7, animations: {
            self.forecastLink.alpha = 1.0
            self.forecastLink.transform = CGAffineTransformMakeScale(1, 1)
        })

        springWithDelay(0.9, delay: initialDelay+0.8, animations: {
            self.backButton.alpha = 1.0
            self.backButton.transform = CGAffineTransformMakeScale(1, 1)
            self.backButton.transform = CGAffineTransformMakeRotation(0)
        })

    }

    func displayData() {
        if let weatherDictionary = detailItem {

            //needs Addition of UNITS module

            let current = Currently(weatherDictionary: weatherDictionary)
            self.realFeelValue.text = " " + valueAssign(current.apparentTemperature) + " °F"
            self.cloudCoverValue.text = " " + valueAssign(current.cloudCover)
            self.precipitationValue.text = " " + valueAssign(current.precipIntensity)
            self.ozoneValue.text = " " + valueAssign(current.ozone)
            self.pressureValue.text = " " + valueAssign(current.pressure) + " mb"
            self.visibilityValue.text = " " + valueAssign(current.visibility) + " m"
            self.windDirectionValue.text = " " + getDirection(valueAssign(current.windBearing))
        }
    }

    func getDirection(x: String) -> String {
        var res = ""
        if let value = Int(x) {
            if value >= -180 && value <= 180 {
                res += "N"
                if value >= 0 {
                    res += "E"
                } else {
                    res += "W"
                }
            } else {
                res += "S"
                if value >= 90 {
                    res += "E"
                } else {
                    res += "W"
                }
            }
        }
        return res + x
    }

    func valueAssign(param: AnyObject?) -> String {
        if param == nil {
            return "−−:−−"
        } else if let value = param as? String where value != "" {
            return value
        } else if let value = param as? Double {
            return "\(value)"
        } else if let value = param as? Int {
            return "\(value)"
        } else {
            return "−−:−−"
        }
    }

    func alphaAdjust() {

        self.realFeelLabel.alpha = 0.0
        self.realFeelValue.alpha = 0.0
        self.ozoneLabel.alpha = 0.0
        self.ozoneValue.alpha = 0.0
        self.precipitationLabel.alpha = 0.0
        self.precipitationValue.alpha = 0.0
        self.cloudCoverLabel.alpha = 0.0
        self.cloudCoverValue.alpha = 0.0
        self.pressureLabel.alpha = 0.0
        self.pressureValue.alpha = 0.0
        self.visibilityLabel.alpha = 0.0
        self.visibilityValue.alpha = 0.0
        self.windDirectionLabel.alpha = 0.0
        self.windDirectionValue.alpha = 0.0
        self.forecastLink.alpha = 0.0
        self.forecastLink.transform = CGAffineTransformMakeScale(5, 5)
        self.backButton.alpha = 0.0
        self.backButton.transform = CGAffineTransformMakeScale(0,0)
        self.backButton.transform = CGAffineTransformMakeRotation(-3.1415926536)
    }

    // MARK: - SEGUES

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender?.identifier == "BackToMainView" {
            
        }
    }


}
