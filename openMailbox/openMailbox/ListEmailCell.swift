//
//  ListEmailCell.swift
//  openMailbox
//
//  Created by f0go on 12/15/15.
//  Copyright © 2015 f0go. All rights reserved.
//

import Foundation
import UIKit

class ListEmailCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cellScroll: UIScrollView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)

        if scrollView.contentOffset.x <= -50 && scrollView.contentOffset.x > -90 {
            leftImage.image = UIImage(named: "check")
            backView.backgroundColor = Utils.UIColorFromRGB("62d962")
        }else if scrollView.contentOffset.x <= -90 {
            leftImage.image = UIImage(named: "delete")
            backView.backgroundColor = Utils.UIColorFromRGB("ef540c")
        }else if scrollView.contentOffset.x > 50 && scrollView.contentOffset.x < 90 {
            rightImage.image = UIImage(named: "clock")
            backView.backgroundColor = Utils.UIColorFromRGB("ffd320")
        }else if scrollView.contentOffset.x > 90 {
            rightImage.image = UIImage(named: "list")
            backView.backgroundColor = Utils.UIColorFromRGB("d8a675")
        }else {
            leftImage.image = nil
            rightImage.image = nil
            backView.backgroundColor = Utils.UIColorFromRGB("D2D2D2")
        }
        
        
    }
}