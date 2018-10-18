//
//  MaskView.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/18.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class MaskView: UIView {

    //动画时长
    let animationsDuration = Double(0.2)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        weak var weakself = self
        
        let maskViewAlfa = CGFloat(0.3)
        self.isUserInteractionEnabled = true

        self.backgroundColor = cmColorWithString(colorName: "000000", alpha: 0)
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeMaskViewAct))
        self.addGestureRecognizer(tapgesture)
        
        UIView.animate(withDuration: animationsDuration, animations: {
            weakself?.backgroundColor = cmColorWithString(colorName: "000000", alpha: maskViewAlfa)
        }, completion: { (status) in
            //如果当前蒙版出现，那么禁止横向滑动
            if let tatgetVC = GetCurrentViewController() as? SellerDetailPageVC {
                tatgetVC.pageController.scrollView?.isScrollEnabled = false
            }
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    //MARK: - 点击蒙版，隐藏蒙版View
    @objc func removeMaskViewAct(){
         weak var weakself = self
            UIView.animate(withDuration: animationsDuration, animations: {
                weakself?.backgroundColor = cmColorWithString(colorName: "000000", alpha: 0)

            }, completion: { (status) in
                if let tatgetVC = GetCurrentViewController() as? SellerDetailPageVC {
                    if  let currentVC =   tatgetVC.pageController.currentViewController  as? ShopcartVC {
                    currentVC.shopcartView.removeFromSuperview()
                        currentVC.isShowShopcart = !currentVC.isShowShopcart
                    }
                }
                weakself?.removeFromSuperview()
                //如果当前蒙版消失，那么打开横向滑动
                if let tatgetVC = GetCurrentViewController() as? SellerDetailPageVC {
                    tatgetVC.pageController.scrollView?.isScrollEnabled = true
                }

            })

    }
    
    
}
