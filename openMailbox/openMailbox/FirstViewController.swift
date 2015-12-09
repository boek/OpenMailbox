//
//  FirstViewController.swift
//  openMailbox
//
//  Created by f0go on 12/9/15.
//  Copyright © 2015 f0go. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var instagramPhoto: UIImageView!
    
    override func viewDidLoad() {
        getInstagramImage()
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
}

