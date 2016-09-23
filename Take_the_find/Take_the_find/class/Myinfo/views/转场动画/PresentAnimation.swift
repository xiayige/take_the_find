//
//  PresentAnimation.swift
//  微博试炼
//
//  Created by qianfeng on 16/9/11.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

import UIKit

class PresentAnimation: NSObject ,UIViewControllerAnimatedTransitioning{
     func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 0.5
    }
     func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        // 1.获取需要弹出视图
        // 通过ToViewKey取出的就是toVC对应的view
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else
        {
            return
        }
        // 2.将需要弹出的视图添加到containerView上
        transitionContext.containerView()?.addSubview(toView)
        // 3.执行动画
        toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        // 设置锚点
        toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            toView.transform = CGAffineTransformIdentity
        }) { (_) -> Void in
            // 注意: 自定转场动画, 在执行完动画之后一定要告诉系统动画执行完毕了
            transitionContext.completeTransition(true)
        }
        

        

    }

}
