//
//  Utils.swift
//  openMailbox
//
//  Created by f0go on 12/9/15.
//  Copyright © 2015 f0go. All rights reserved.
//

import Foundation
import UIKit

struct Globals {
    static var imageCache = [String : UIImage]()
}

class Utils {
 
    class func makeJsonRequest (url: NSURL, callback: (json: JSON!, error: NSError!) -> Void, retryCount:Int = 0) {
        print("📡 request: \(url)")
        let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("User-Agent", forHTTPHeaderField: "user-agent")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            if error != nil {
                if retryCount == 5 {
                    print("🔥🔥 Request: Error \(error!.localizedDescription) \(url)")
                    callback(json: nil, error: error)
                }else {
                    print("🔥🔥 Request: Error Count \(retryCount) \(url)")
                    self.makeJsonRequest(url, callback: callback, retryCount: retryCount + 1)
                }
            } else {
                
                let json = JSON(data: data!)
                
                print("👍 Request: \(url)")
                callback(json: json, error: nil)
            }
        })
    }
    
    class func makeJsonPost (json: JSON, url: NSURL, callback: (json: JSON!, error: NSError!) -> Void, retryCount:Int = 0) {
        print("📡 Post: \(url)")
        let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 60)
        
        let content: NSData?
        do {
            content = try json.rawData()
        } catch _ {
            content = nil
        };
        
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("User-Agent", forHTTPHeaderField: "user-agent")
        request.setValue("\(content?.length)", forHTTPHeaderField: "content-length")
        request.HTTPBody = content
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            if error != nil {
                if retryCount == 5 {
                    print("🔥🔥 Post: Error \(error!.localizedDescription) \(url)")
                    callback(json: nil, error: error)
                }else {
                    print("🔥🔥 Post: Error Count \(retryCount) \(url)")
                    self.makeJsonPost(json, url: url, callback: callback, retryCount: retryCount + 1)
                }
            } else {
                
                let json = JSON(data: data!)
                
                print("👍 Post: \(url)")
                callback(json: json, error: nil)
            }
        })
        
    }
    
    class func getImageFromUrl(url:String, callback: (image:UIImage!) -> Void) {
        var image = Globals.imageCache[url]
        
        if image == nil {
            let imgURL: NSURL = NSURL(string: url)!
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    image = UIImage(data: data!)
                    Globals.imageCache[url] = image
                    
                    callback(image: image)
                } else {
                    print("🔥🔥 Image Download Error: \(error!.localizedDescription)")
                    callback(image: nil)
                }
            })
            
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                callback(image: image)
            })
        }
    }
}