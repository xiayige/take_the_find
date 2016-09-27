//
//  GUOCommitCell.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/27.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class GUOCommitCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!

    @IBOutlet weak var floorL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var nameL: UILabel!
    override func awakeFromNib() {
        self.iconImage.layer.cornerRadius = 30
        self.iconImage.layer.masksToBounds = true
        super.awakeFromNib()
    }
    func setTheCell(model:GUOCommitModel,Index:Int){
        self.contentL.text = model.content
        if model.usericon != nil{
            self.iconImage.sd_setImageWithURL(NSURL.init(string: model.usericon!))
        }
        self.nameL.text = model.login
        self.floorL.text = "\(Index)楼"
    }
}
