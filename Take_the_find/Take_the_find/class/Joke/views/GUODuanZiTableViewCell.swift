//
//  GUODuanZiTableViewCell.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/26.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit
protocol GUODuanZiTableViewCellDelegate:NSObjectProtocol {
    func moreBtnClick(models:String)
}
class GUODuanZiTableViewCell: UITableViewCell {
     weak var btndelegate:GUODuanZiTableViewCellDelegate?
    @IBOutlet weak var moreAddBtn: UIButton!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var picImageH: NSLayoutConstraint!
    @IBOutlet weak var topViewH: NSLayoutConstraint!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    var duanZM:DuanZModel!
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var contentL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.iconImage.layer.cornerRadius = 40
        self.moreAddBtn.hidden = true
        self.iconImage.layer.masksToBounds = true
    }
    func setThecellWithModel(model:DuanZModel){
        contentL.text = model.content
        duanZM = model
        if model.DuanUserM != nil{
            if let str = model.DuanUserM!.DuanUsericonStr {
                iconImage.sd_setImageWithURL(NSURL.init(string: str))
            }
            nameL.text = model.DuanUserM!.login
            
            timeL.text = dateStrWith(model.DuanUserM!.created_at.doubleValue)

        }
            topViewH.constant = 100 + model.contentH
            if model.image != nil{
            let imageH = (model.picHeight! / model.picWidth!) * SCREEN_W
            if imageH > 400{
                self.moreAddBtn.hidden = false
                pictureImage.contentMode = .Top
                pictureImage.clipsToBounds = true
               picImageH.constant = 200
            }else{
                self.moreAddBtn.hidden = true
                pictureImage.contentMode = .ScaleToFill
                picImageH.constant = imageH
            }
            pictureImage.sd_setImageWithURL(NSURL.init(string: model.iconStr!))
        }else{
            picImageH.constant = 0.001
        }
        model.cellH = topViewH.constant + picImageH.constant
    }
    func dateStrWith(date:Double)->String{
        let interval = date
        let date = NSDate.init(timeIntervalSince1970: interval)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = formatter.stringFromDate(date)
        return dateStr
    }
    @IBAction func moressBtnClick(sender: AnyObject) {
        ///点击更多展开i
        if let str = duanZM.iconStr{
            btndelegate?.moreBtnClick(str)
        }
        
    }
}
