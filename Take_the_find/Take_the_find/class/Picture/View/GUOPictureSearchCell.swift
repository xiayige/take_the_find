//
//  GUOPictureSearchCell.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/20.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit
protocol GUOPictureSearchCelldelegate:NSObjectProtocol {
    func cellDidSelected(indexpath:NSIndexPath)
}
class GUOPictureSearchCell: UITableViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    var dataStr:[String]!
    weak var cellClickdelegate:GUOPictureSearchCelldelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setTheContent(dataArr:[String]){
        self.dataStr = dataArr
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionV = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionV.dataSource = self
        collectionV.backgroundColor = backColor
        collectionV.registerClass(GUOPictureHotSearchCell.self, forCellWithReuseIdentifier: "GUOPictureHotSearchCell")
        collectionV.delegate = self
        self.addSubview(collectionV)
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataStr.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GUOPictureHotSearchCell", forIndexPath: indexPath) as! GUOPictureHotSearchCell
        cell.label.setTitle(dataStr[indexPath.row], forState: .Normal)
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let str = dataStr[indexPath.row] as NSString
        let width = str.boundingRectWithSize(CGSizeMake(9999, 20), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15)], context: nil).width
       return CGSizeMake(width , 23)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        cellClickdelegate.cellDidSelected(indexPath)
    }
    
    
}
class GUOPictureHotSearchCell:UICollectionViewCell{
    let label = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTheSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setTheSubview(){
        label.frame = self.bounds
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.enabled = false
        label.backgroundColor = UIColor.purpleColor().colorWithAlphaComponent(0.7)
        label.titleLabel?.font = UIFont.systemFontOfSize(15)
        self.addSubview(label)
    }
    
}