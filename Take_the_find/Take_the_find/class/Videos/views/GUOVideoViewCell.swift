//
//  GUOVideoViewCell.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/21.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit
protocol GUOVideoViewCellDelegate:NSObjectProtocol {
    func cellClick(videoM:VideoModel?,userM:UserModel?,error:NSError?)
}
class GUOVideoViewCell: UITableViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    var dataArr:[VideoModel]!
    weak var CellDelegate:GUOVideoViewCellDelegate?
    var collV:UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setTheSubview()
    }
    func setTheSubview(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = videoSpace
        var rect = self.bounds
        rect.origin.x = videoSpace
        rect.size.width = rect.width - 2 * videoSpace
        collV = UICollectionView(frame: rect, collectionViewLayout: layout)
        collV.registerNib(UINib.init(nibName: "GUOVideoDetailCell", bundle: nil), forCellWithReuseIdentifier: "GUOVideoDetailCell")
        collV.dataSource = self
        collV.backgroundColor = UIColor.whiteColor()
        collV.bounces = false
        collV.pagingEnabled = true
        collV.showsHorizontalScrollIndicator = false
        collV.delegate = self
        self.addSubview(collV)
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GUOVideoDetailCell", forIndexPath: indexPath) as! GUOVideoDetailCell
        let model = dataArr[indexPath.row]
        cell.setcellWithModel(model)
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = dataArr[indexPath.row]
        VideoModel.requestgetVideoInfoData(model.id) { (usermodel, videomodel, error) in
            if error == nil{
                self.CellDelegate?.cellClick(videomodel, userM: usermodel, error: nil)
            }else{
                SVProgressHUD.showErrorWithStatus("请求出现错误")
                self.CellDelegate?.cellClick(nil, userM: nil, error: error)
            }
            
        }
        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(videoW , videoH )
    }
}
