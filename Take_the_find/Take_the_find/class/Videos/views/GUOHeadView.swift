//
//  GUOHeadView.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/21.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class GUOHeadView: UIView {
    var title: String!
    @IBOutlet weak var titleL: UILabel!
    static func headView(headtitle:String) -> GUOHeadView{
        let headV = NSBundle.mainBundle().loadNibNamed("GUOHeadView", owner: self, options: nil).last as! GUOHeadView
        headV.layer.cornerRadius = videoConr
        headV.layer.masksToBounds = true
        headV.titleL.text = headtitle
        return headV
    }

}
