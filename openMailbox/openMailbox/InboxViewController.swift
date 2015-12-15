//
//  FirstViewController.swift
//  openMailbox
//
//  Created by f0go on 12/9/15.
//  Copyright © 2015 f0go. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController {
    
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var instagramPhoto: UIImageView!
    @IBOutlet weak var navBarSectionsHolder: UIView!
    @IBOutlet weak var selectedSectionLabel: UILabel!
    
    var navBarSections: NavBarSections!
    
    let labelsArray = ["uno", "dos", "un label mucho mas largo", "algo mas", "que mierda pasa", "que no funciona", "bien"]
    
    override func viewDidLoad() {
        getInstagramImage()
        loadLabels()
    }
    
    func getInstagramImage(){
        Utils.makeJsonRequest("https://api.instagram.com/v1/users/1573625/media/recent/?client_id=\(APIConfig.instagramClientID)", callback: { (json, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            let imageURL = json["data"][0]["images"]["standard_resolution"]["url"].stringValue
            
            Utils.getImageFromUrl(imageURL, callback: { (image) -> Void in
                self.instagramPhoto.image = image
            })
        }, retryCount: 0)
    }
    
    func loadLabels() {
        loadSections(labelsArray, selectedTextColor: "ffffff", textColor: "D2D2D2")
    }
    
    func loadSections(elements: [String], selectedTextColor: String, textColor: String) {
        navBarSections = UIStoryboard(name: "NavBarSections", bundle: nil).instantiateViewControllerWithIdentifier("NavBarSections") as! NavBarSections
        navBarSections.view.frame = navBarSectionsHolder.frame
        navBarSections.elements = elements
        navBarSections.textColor = textColor
        navBarSections.textColorSelected = selectedTextColor
        navBarSections.callback = {(index, title) in
            self.selectedSectionLabel.text = title
        }
        header.addSubview(navBarSections.view)
    }
}

