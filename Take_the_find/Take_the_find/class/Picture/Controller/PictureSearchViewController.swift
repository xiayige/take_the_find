//
//  PictureSearchViewController.swift
//  targetApp
//
//  Created by qianfeng on 16/9/19.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class PictureSearchViewController: UIViewController {
    var type:String!
    var dataArr = [PictureModel]()
    var page = 1
    var hotSeatchArray:[String]?
    var layout:UICollectionViewFlowLayout!
     var collectionV:UICollectionView!
     lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "搜索对应类别下的图片"
        return searchBar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backColor
        self.automaticallyAdjustsScrollViewInsets = false
        setupNav()
        setTheCollView()
    }
    func setTheCollView(){
        let layout = UICollectionViewFlowLayout()
        self.collectionV = UICollectionView(frame: CGRectMake(0, 0, 375, 667), collectionViewLayout: layout)
        self.collectionV.backgroundColor = backColor
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionV.contentInset = UIEdgeInsetsMake(NAV_H , 0, TAB_H, 0)
        self.collectionV.delegate = self
        self.collectionV.dataSource = self
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.view.addSubview(collectionV)
        layout.itemSize = CGSizeMake(SCREEN_W / 2 - 2, 200)
        self.collectionV.registerNib(UINib.init(nibName: "PictureCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PictureCollectionCell")
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    // 设置导航栏
    func setupNav() {
        self.navigationItem.titleView = self.searchBar
        searchBar.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(navigationBackClick))
    }
    /// 返回按钮、取消按钮点击
    func navigationBackClick() {
        navigationController?.popViewControllerAnimated(true)
    }
}
extension PictureSearchViewController: UISearchBarDelegate{
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        /// 设置collectionView
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    /// 搜索按钮点击
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "checkUserType_backward_9x15_"), style: .Plain, target: self, action: #selector(navigationBackClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_sort_21x21_"), style: .Plain, target: self, action: #selector(sortButtonClick))
        /// 根据搜索条件进行搜索
        let keyword = searchBar.text
       //发送网络请求
        if keyword != ""{
            loadDetailData(keyword!)
        }else{
            
            SVProgressHUD.dismissWithDelay(1.0)
        }
        
    }
    func loadDetailData(keyword:String){
        self.collectionV.mj_header = MJRefreshStateHeader(refreshingBlock: {
            self.page = 1
            self.dataArr.removeAll()
            SVProgressHUD.showWithStatus("努力搜索中....")
            PictureModel.requestCategaryData(self.type, tag: keyword, page: self.page) { (array, error) in
                if error == nil{
                    self.dataArr = array!
                    self.collectionV.reloadData()
                    SVProgressHUD.dismiss()
                    self.page += 1
                    self.collectionV.mj_header.endRefreshing()
                    self.collectionV.mj_footer.endRefreshing()
                }else{
                    print(error)
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
                    self.dataArr = array as! [PictureModel]
                    self.collectionV.reloadData()
                    self.page += 1
                    self.collectionV.mj_header.endRefreshing()
                    self.collectionV.mj_footer.endRefreshing()
                    SVProgressHUD.dismiss()
                }else{
                    print(error)
                }
            }
        })
         self.collectionV.mj_header.beginRefreshing()
    }
        /// 搜索条件点击
    func sortButtonClick() {
      
    }
}
//MARK:collectionView 协议方法
extension PictureSearchViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PictureCollectionCellDelegate{
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
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
