//
//  GUOVideoDetailCell.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/21.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class GUOVideoDetailCell: UICollectionViewCell {

    @IBOutlet weak var viewH: NSLayoutConstraint!
    @IBOutlet weak var danmuBtn: UIButton!
    @IBOutlet weak var seeBtn: UIButton!
    @IBOutlet weak var contentLH: NSLayoutConstraint!
    @IBOutlet weak var fnameL: UILabel!
    @IBOutlet weak var videoLengL: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    var model:VideoModel!
    var istrue = false
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    @IBAction func arrowBtnClick(sender: UIButton) {
        if istrue{
            UIView.animateWithDuration(videoLength, animations: {
                self.contentLH.constant = self.model.fnameH + 2
                self.viewH.constant = self.model.fnameH
                self.layoutIfNeeded()
            })
            sender.setBackgroundImage(UIImage.init(named: "arrow_carrot_dwnn_alt_72px_1143268_easyicon.net-1"), forState: .Normal)
        }else{
            UIView.animateWithDuration(videoLength, animations: {
                self.viewH.constant = 0
                self.contentLH.constant = 0
                self.layoutIfNeeded()
            })
            sender.setBackgroundImage(UIImage.init(named: "arrow_carrot_up_alt_72px_1143276_easyicon.net"), forState: .Normal)
        }
        model.cellH = self.model.fnameH  + 8
        fnameL.text = model.fname
        istrue = !istrue
    }
    func setcellWithModel(model:VideoModel){
        self.viewH.constant = 0
        self.contentLH.constant = 0
        imageV.layer.cornerRadius = videoConr
        imageV.layer.masksToBounds = true
        let str = "http://www.cat666.com/" + model.thumb
        imageV.sd_setImageWithURL(NSURL.init(string: str))
        let seeStr = "\(model.viewcounts)观看"
        seeBtn.setTitle(seeStr, forState: .Normal)
        let danmuStr = "\(model.videodanmu)条弹幕"
        danmuBtn.setTitle(danmuStr, forState: .Normal)
        videoLengL.text = model.videotime
        self.model = model
    }

}
