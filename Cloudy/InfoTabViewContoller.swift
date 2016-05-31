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
    @IBOutlet weak var forecastLink: UIButton!

    var audioPlayer = AVAudioPlayer()

    @IBAction func openForecastLink(sender: UIButton) {
        if let url = NSURL(string: urlString) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    override func viewDidLoad() {
        alert()
    }

    // SOUNDS

    func alert() {
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Squeaky Creaky", ofType: "wav")!)
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

    // MARK: - SEGUES

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender?.identifier == "BackToMainView" {
            
        }
    }


}
