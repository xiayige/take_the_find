//
//  GUOSerachDetailViewController.swift
//  Take_the_find
//
//  Created by qianfeng on 16/9/20.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class GUOSerachDetailViewController: UIViewController {
    var layout:UICollectionViewFlowLayout!
    var collectionV:UICollectionView!
    var type:String!
    var keyword:String?
    var page = 1
    var dataArr = [PictureModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backColor
        self.automaticallyAdjustsScrollViewInsets = false
        setupNav()
       setTheCollView()
        //在这里面进行网络请求
        addSearchText("\(self.type)--\(self.keyword!)")
        loadDetailData(self.keyword!)
    }
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = self.keyword!
        return searchBar
    }()
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
        SVProgressHUD.dismiss()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    ///把历史记录写入本地数据
    func addSearchText(text:String){
        let user = NSUserDefaults.standardUserDefaults()
        var array = user.arrayForKey("history")
        if array?.count == nil{
            //创建一个
            array = NSArray() as [AnyObject]
        }
        let arrayM = NSMutableArray.init(array: array!)
        for str in arrayM{
            let str1 = str as! String
            if str1 == text{
                return
            }
        
        }
        arrayM.insertObject(text, atIndex: 0)
        if arrayM.count > 15{
            arrayM.removeObjectAtIndex(0)
        }
        user.setObject(arrayM, forKey: "history")
        user.synchronize()
        
    }
    // 设置导航栏
    func setupNav(){
        self.navigationItem.titleView = self.searchBar
        searchBar.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(navigationBackClick))
    }
    /// 返回按钮、取消按钮点击
    func navigationBackClick() {
        navigationController?.popViewControllerAnimated(true)
    }
    func setTheCollView(){
        let layout = UICollectionViewFlowLayout()
        self.collectionV = UICollectionView(frame: CGRectMake(0, 0, SCREEN_W, SCREEN_H), collectionViewLayout: layout)
        self.collectionV.backgroundColor = backColor
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionV.contentInset = UIEdgeInsetsMake(NAV_H , 0, 0, 0)
        self.collectionV.delegate = self
        self.collectionV.dataSource = self
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.view.addSubview(collectionV)
        layout.itemSize = CGSizeMake(SCREEN_W / 2 - 2, 200)
        self.collectionV.registerNib(UINib.init(nibName: "PictureCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PictureCollectionCell")
    }
}
extension GUOSerachDetailViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PictureCollectionCellDelegate{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PictureCollectionCell", forIndexPath: indexPath) as! PictureCollectionCell
        cell.btndelegate = self
        if dataArr.count == 0{
            return cell
        }
        let model = dataArr[indexPath.row]
        cell.setThecell(model)
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
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
extension GUOSerachDetailViewController: UISearchBarDelegate{
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        /// 设置collectionView
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    /// 搜索按钮点击
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "checkUserType_backward_9x15_"), style: .Plain, target: self, action: #selector(navigationBackClick))
        /// 根据搜索条件进行搜索
        let keyword = searchBar.text
        //发送网络请求
        if keyword != ""{
            //加载数据
            loadDetailData(keyword!)
        }else{
            SVProgressHUD.showErrorWithStatus("请求不能为空")
        }
        
    }
    ///加载数据
    func loadDetailData(keyword:String){
        weak var weakSelf = self
        self.collectionV.mj_header = MJRefreshStateHeader(refreshingBlock: {
            self.page = 1
            self.dataArr.removeAll()
            SVProgressHUD.showWithStatus("努力搜索中....")
            PictureModel.requestCategaryData(self.type, tag: keyword, page: self.page) { (array, error) in
                if error == nil{
                    weakSelf!.dataArr = array!
                    weakSelf!.collectionV.reloadData()
                    SVProgressHUD.dismiss()
                    weakSelf!.page += 1
                    weakSelf!.collectionV.mj_header.endRefreshing()
                    weakSelf!.collectionV.mj_footer.endRefreshing()
                }else{
                    SVProgressHUD.showErrorWithStatus("网络错误")
                }
            }
        })
        self.collectionV.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            SVProgressHUD.showWithStatus("努力搜索中....")
            PictureModel.requestCategaryData(self.type, tag: keyword, page: self.page) { (array, error) in
                if error == nil{
                    let mutableArr = NSMutableArray.init(array: self.dataArr)
                    mutableArr.addObjectsFromArray(array!)
                    let array = NSArray.init(array: mutableArr)
                    weakSelf!.dataArr = array as! [PictureModel]
                    weakSelf!.collectionV.reloadData()
                    weakSelf!.page += 1
                    weakSelf!.collectionV.mj_header.endRefreshing()
                    weakSelf!.collectionV.mj_footer.endRefreshing()
                    SVProgressHUD.dismiss()
                }else{
                    SVProgressHUD.showErrorWithStatus("网络错误")
                }
            }
        })
        self.collectionV.mj_header.beginRefreshing()
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}
