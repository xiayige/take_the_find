//
//  PictureCollectionController.swift
//  targetApp
//
//  Created by qianfeng on 16/9/18.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit
class PictureCollectionController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var type:String!
    var dataArr = [PictureModel]()
    var block:(([String])->Void)?
    var cateArr = [String]()
    var page = 1
    var layout:UICollectionViewFlowLayout!
    //MARK:加载控制器
    static func loadTheVC() -> PictureCollectionController{
         let layout = UICollectionViewFlowLayout()
        let pictureVC = PictureCollectionController(collectionViewLayout: layout)
        pictureVC.layout = layout
        return pictureVC
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheCollectionView()
        loadData()
    
    }
    //MARK:设置collectionView
    func setTheCollectionView(){
        self.collectionView?.backgroundColor = backColor
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionView?.contentInset = UIEdgeInsetsMake(NAV_H + topBtn_H , 0, TAB_H, 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSizeMake(SCREEN_W / 2 - 2, 200)
        self.collectionView!.registerNib(UINib.init(nibName: "PictureCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PictureCollectionCell")
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
   
   //MARK:加载图片数据
    func loadData(){
        self.collectionView?.mj_header = MJRefreshStateHeader(refreshingBlock: {
            self.page = 1
            self.dataArr.removeAll()
            SVProgressHUD.showWithStatus("正在加载")
            PictureModel.requestData(self.type,page: self.page) { (array, error) in
                if error == nil{
                    self.dataArr = array!
                    //获取热门数据
                    self.makeThehostData(array!)
                    self.collectionView?.reloadData()
                    self.page += 1
                    self.collectionView?.mj_header.endRefreshing()
                     self.collectionView?.mj_footer.endRefreshing()
                    SVProgressHUD.dismiss()
                }else{
                    print(error)
                    SVProgressHUD.dismiss()
                }
            }
        })
        self.collectionView?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
           SVProgressHUD.showWithStatus("正在加载")
            PictureModel.requestData(self.type,page: self.page) { (array, error) in
                if error == nil{
                    let mutableArr = NSMutableArray.init(array: self.dataArr)
                    mutableArr.addObjectsFromArray(array!)
                    let array = NSArray.init(array: mutableArr)
                    self.dataArr = array as! [PictureModel]
                    self.collectionView?.reloadData()
                    self.page += 1
                    self.collectionView?.mj_header.endRefreshing()
                    self.collectionView?.mj_footer.endRefreshing()
                    SVProgressHUD.dismiss()
                }else{
                    print(error)
                    SVProgressHUD.dismiss()
                }
            }
        })
        self.collectionView?.mj_header.beginRefreshing()
    }
    func makeThehostData(models:[PictureModel]){
        cateArr = [String]()
        for model in models{
            let str = model.objTag
            if str == nil{
                continue
            }
            cateArr.append(str)
        }
        block!(cateArr)
    }
}
//MARK:collectionView 协议方法
extension PictureCollectionController:PictureCollectionCellDelegate{
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PictureCollectionCell", forIndexPath: indexPath) as! PictureCollectionCell
        cell.btndelegate = self
        if dataArr.count == 0{
            return cell
        }
        let model = dataArr[indexPath.row]
        cell.setThecell(model)
        return cell
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = dataArr[indexPath.item]
        if model.imageUrl == nil{
            return
        }
        if model.imageWidth == nil || model.imageHeight == nil{
            let next = NextViewController()
            next.model = model
            next.indexPath = indexPath
            self.presentViewController(next, animated: true, completion: nil)
        }else if CGFloat(model.imageHeight) / CGFloat(model.imageWidth) > 1.6{
            return
        }else{
            let next = NextViewController()
            next.model = model
            next.indexPath = indexPath
            self.presentViewController(next, animated: true, completion: nil)
        }

    }
    func btnClick(models:PictureModel){
        let next = NextViewController()
        next.model = models
        self.presentViewController(next, animated: true, completion: nil)
    }
}
