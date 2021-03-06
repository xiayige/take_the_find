//
//  GUODZDetailview.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/27.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit
protocol GUODZDetailviewDelegate:NSObjectProtocol {
    func sharebtnClick()
}
class GUODZDetailview: UIView {
    weak var sharedelegate:GUODZDetailviewDelegate?
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var iconimageV: UIImageView!
    @IBOutlet weak var bottomV: UIView!
    @IBOutlet weak var pictureHC: NSLayoutConstraint!
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var pictureImageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    ///点击分享
    @IBAction func shareClick(sender: AnyObject) {
        sharedelegate?.sharebtnClick()
    }
    //设置内容
    static func setThecell(model:DuanZModel,callBack:(headV:GUODZDetailview,height:CGFloat)->()){
        let headV = NSBundle.mainBundle().loadNibNamed("GUODZDetailview", owner: self, options: nil).last as! GUODZDetailview
        headV.iconimageV.layer.cornerRadius = 30
        
        headV.iconimageV.layer.masksToBounds = true
        headV.contentL.text = model.content
        if model.DuanUserM?.DuanUsericonStr != nil{
            headV.iconimageV.sd_setImageWithURL(NSURL.init(string: (model.DuanUserM?.DuanUsericonStr)!))
        }
        if model.DuanUserM?.login != nil{
           headV.nameL.text = model.DuanUserM!.login
        }
        if model.iconStr != nil{
            headV.pictureImageV.sd_setImageWithURL(NSURL.init(string: model.iconStr!))
            headV.pictureHC.constant = 280 * model.picHeight! / model.picWidth!
        }else{
             headV.pictureHC.constant = 0
        }
        headV.layoutIfNeeded()
        let height = CGRectGetMaxY(headV.bottomV.frame)
        callBack(headV: headV, height: height)
    }
}
