//
//  DisMissAnimation.swift
//  微博试炼
//
//  Created by qianfeng on 16/9/11.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

import UIKit

class DisMissAnimation: NSObject,UIViewControllerAnimatedTransitioning {
     func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 0.5
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        // 1.拿到需要消失的视图
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else
        {
            return
        }
        // 2.执行动画让视图消失
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            // 突然消失的原因: CGFloat不准确, 导致无法执行动画, 遇到这样的问题只需要将CGFloat的值设置为一个很小的值即可
            fromView.transform = CGAffineTransformMakeScale(1.0, 0.00001)
            }, completion: { (_) -> Void in
                // 注意: 自定转场动画, 在执行完动画之后一定要告诉系统动画执行完毕了
                transitionContext.completeTransition(true)
        })

    }
}
