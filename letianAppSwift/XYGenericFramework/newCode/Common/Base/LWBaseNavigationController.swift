//
//  LWBaseNavigationController.swift
//  Loter-swift
//
//  Created by 张星星 on 2018/3/30.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit

class LWBaseNavigationController: UINavigationController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        weak var wself = self
        if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.delegate = wself as UIGestureRecognizerDelegate?

        }
    }

   
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let bgBtnImage = UIImage.init(named: "nav_backImage_white")
            let btn = UIButton()
            // let title = "  \(self.title! as String)"
            btn.setImage(bgBtnImage, for: UIControl.State.normal)
            //btn.setTitle(self.title, for: UIControl.State.normal)
            //btn.setTitleColor(UIColor.orange, for: UIControl.State.normal)
            //btn.setTitleColor(UIColor.gray, for: UIControl.State.highlighted)
            btn.sizeToFit()
//            btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -20, bottom: 0, right: 0)
            btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            btn.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)  // 返回箭头向左偏移，代替系统返回箭头位置
            let leftItem = UIBarButtonItem.init(customView: btn)
            leftItem.tag = 666
            let spacer = UIBarButtonItem(barButtonSystemItem:  UIBarButtonItem.SystemItem.fixedSpace, target:nil, action:nil)
            spacer.width = -10; //修复位移
            viewController.navigationItem.leftBarButtonItems = [spacer,leftItem]
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer
        {
            return self.navigationController!.viewControllers.count > 1
        }
        return true
    }
    
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.isEnabled = false
        }
        return super.popToViewController(viewController, animated: animated)
    }

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
         if (responds(to: #selector(getter: interactivePopGestureRecognizer)) && animated == true) {
            interactivePopGestureRecognizer?.isEnabled = false
        }
       return super.popToRootViewController(animated: animated)
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            if navigationController.childViewControllers.count < 2 {
                interactivePopGestureRecognizer?.isEnabled = false
            }
            else {
                interactivePopGestureRecognizer?.isEnabled = true
            }
        }
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if self.childViewControllers.count <= 1 {
            return false;
        }
        else {
            // 可以把不需要侧滑的控制器过滤
            if (self.visibleViewController?.isKind(of: LWBaseViewController.self))! {
                let vc = self.visibleViewController as? LWBaseViewController
                if vc?.allPopGestureRecognizer == false {
                    return false;
                }
            }
            return true
        }
    }

}
