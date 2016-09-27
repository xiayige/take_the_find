//
//  GUODNextViewController.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/26.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class GUODNextViewController: UIViewController {
    var strUrl:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageV.sd_setImageWithURL(NSURL.init(string: strUrl))
        self.view.addSubview(imageV)
    }
    lazy var imageV:UIImageView = {
        let imageV = UIImageView(frame: self.view.bounds)
        return imageV
    }()
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
}
