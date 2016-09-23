//
//  NextViewController.swift
//  targetApp
//
//  Created by qianfeng on 16/9/19.
//  Copyright © 2016年 郭磊. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {
    var model:PictureModel?
    var indexPath:NSIndexPath?
    var scroolV:UIScrollView!
    var labelView:UIView!
    var image:UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        let image1 = UIImage.init(named: "2")
        image = image1
//         let imageStr = SDWebImageManager.sharedManager().cacheKeyForURL(NSURL.init(string: model!.imageUrl))
//         image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(imageStr)
        self.view.backgroundColor = backColor
        if indexPath != nil{
            setnomailPicture()
            setTheLabel()
        }else{
            setbigPicture()
        }
    }
    func setnomailPicture(){
        let cellH:CGFloat!
        if model?.imageHeight != nil && model?.imageWidth != nil{
        cellH = CGFloat(model!.imageHeight) / CGFloat(model!.imageWidth) * UIScreen.mainScreen().bounds.width - space * 2
        }else{
            cellH = 200
        }
       
        scroolV = UIScrollView(frame: self.view.bounds)
        
        self.view.addSubview(scroolV)
        let imageV = UIImageView.init(frame: CGRectMake(space, 0, SCREEN_W - 2 * space, cellH))
        imageV.center = self.view.center
        imageV.sd_setImageWithURL(NSURL.init(string: model!.imageUrl))
        scroolV.contentSize = CGSizeMake(0, cellH)
       labelView = UIView(frame: CGRectMake(10, imageV.frame.origin.y + imageV.frame.height + space , SCREEN_W - 2*space, labelH))
        labelView.backgroundColor = UIColor.redColor()
        self.view.addSubview(labelView)
        scroolV.addSubview(imageV)
        imageV.tag = 10
        scroolV.delegate = self
        scroolV.minimumZoomScale = 0.5
        scroolV.maximumZoomScale = 2
        scroolV.addGestureRecognizer({
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(self.tapPicture(_:)))
            return tapgesture
            }())
    }
    func  setTheLabel(){
        let attr = ["保存到本地","设置为壁纸"]
        let btnw = labelView.frame.width / CGFloat(attr.count)
        for i in 0...attr.count - 1{
            let btn = UIButton()
            btn.setTitle(attr[i], forState: .Normal)
            btn.frame = CGRectMake(CGFloat(i)*btnw, 0, btnw, labelH)
            btn.setBackgroundImage(UIImage.init(named: "cell-button-line"), forState: .Normal)
            btn.setBackgroundImage(UIImage.init(named: "cell-button-line"), forState: .Highlighted)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            btn.tag = 100 + i
            btn.addTarget(self, action: #selector(self.btnClick(_:)), forControlEvents: .TouchUpInside)
            labelView.addSubview(btn)
        }
        
    }
    func btnClick(btn:UIButton){
      //利用SDWebimage取出图片
         SDWebImageManager.sharedManager().downloadImageWithURL(NSURL.init(string: (model?.imageUrl)!), options: SDWebImageOptions.init(rawValue: 0), progress: nil) { (image, error, cacheType, BOOL, imageURL) in
            if error == nil{
                //let image = SDImageCache.sharedImageCache().storeImage(<#T##image: UIImage!##UIImage!#>, forKey: <#T##String!#>)
            }
        }
    }
    //保存图片
    func savaImage(){
    }
    func alert(title:String){
        let alert = UIAlertController(title: "提示", message: title, preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "OK", style: .Default) { (_) in
            
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .Cancel) { (_) in
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
     func image(image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject)
    {
        var title: String!
        if didFinishSavingWithError != nil
        {
            title = "图片保存失败-"
            print(didFinishSavingWithError)
        } else {
            title = "图片保存成功"
        }
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "OK", style: .Default) { (_) in
            
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .Cancel) { (_) in
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func setbigPicture(){
        let cellH = CGFloat(model!.imageHeight) / CGFloat(model!.imageWidth) * UIScreen.mainScreen().bounds.width - 2*space
        scroolV = UIScrollView(frame: self.view.bounds)
        self.view.addSubview(scroolV)
        let imageV = UIImageView.init(frame: CGRectMake(space, 0, SCREEN_W - 2*space, cellH))
        imageV.tag = 10
        scroolV.delegate = self
        scroolV.minimumZoomScale = 0.5
        scroolV.maximumZoomScale = 2
        imageV.sd_setImageWithURL(NSURL.init(string: model!.imageUrl))
        scroolV.contentSize = CGSizeMake(0, cellH)
        scroolV.addSubview(imageV)
        scroolV.addGestureRecognizer({
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(self.tapPicture(_:)))
            return tapgesture
            }())
    }
    func tapPicture(tap:UITapGestureRecognizer){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension NextViewController:UIScrollViewDelegate{
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        //设置scrollView中哪一个子视图允许缩放
        //一般情况下利用sv进行缩放时，只放一个子视图
        return scrollView.viewWithTag(10)
    }
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat){
        let centerX = scrollView.center.x
        let centerY = scrollView.center.y
       let centerx = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : centerX
        let centery = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : centerY
      let imageV = scrollView.viewWithTag(10) as! UIImageView
        imageV.center = CGPointMake(centerx, centery)
    }
}
