//
//  PictureCollectionCell.swift
//  targetApp
//
//  Created by qianfeng on 16/9/18.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit
protocol PictureCollectionCellDelegate:NSObjectProtocol {
    func btnClick(models:PictureModel)
}
class PictureCollectionCell: UICollectionViewCell {
    weak var btndelegate:PictureCollectionCellDelegate!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    var models:PictureModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnC.hidden = true
    }
    //点击展开图片
    @IBAction func btnClick(sender: AnyObject) {
        btndelegate.btnClick(models)
        
    }
    func setThecell(model:PictureModel){
        self.titleL.text = model.objTag
        if model.imageUrl == nil{
            return
        }
        if CGFloat(model.imageHeight) / CGFloat(model.imageWidth) > 1.6{
            self.imageV.sd_setImageWithURL(NSURL.init(string: model.imageUrl))
            self.imageV.contentMode = .ScaleAspectFit
            btnC.hidden = false
            self.models = model
        }else{
            btnC.hidden = true
            self.imageV.contentMode = .ScaleToFill
             self.imageV.sd_setImageWithURL(NSURL.init(string: model.imageUrl))
        }
       
    }
}
