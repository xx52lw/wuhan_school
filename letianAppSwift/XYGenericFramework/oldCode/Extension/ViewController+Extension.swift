//
//
//XYGenericFramework
//
//  Created by xiaoyi on 2017/6/11.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

extension UIViewController {
    //设置导航栏
    func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        let bgImage = UIImage.image(by: .navigationBG)
        navigationController?.navigationBar.setBackgroundImage(bgImage, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barStyle = .default
        
        let font: UIFont = .naviagation
        let titleColor: UIColor = .white
        let attti = [NSAttributedStringKey.font: font,
                     NSAttributedStringKey.foregroundColor: titleColor]
        navigationController?.navigationBar.titleTextAttributes = attti
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //设置导航栏为透明
    func setupNavigationBarTranslucent() {
        let clearImage = UIImage.image(by: .clear)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.setBackgroundImage(clearImage, for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //设置导航栏返回按钮
    func setupBackNavigationButton() {
        if (navigationController != nil && navigationController?.viewControllers.first != self) || navigationController?.presentingViewController != nil {
            let backImage = UIImage(named: "fanhui")?.withRenderingMode(.alwaysOriginal)
            let leftItem = UIBarButtonItem(image: backImage,
                                           style: .done,
                                           target: self,
                                           action: #selector(clickedNavLeftItem))
            navigationItem.leftBarButtonItem = leftItem
        }
    }
    
    //根据字符串设置导航栏返回按钮
    func setupBackNavigationButton(title: String) {
        let button = UIButton()
        button.isExclusiveTouch = true
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = cmSystemFontWithSize(15)
        button.addTarget(self, action: #selector(clickedNavLeftItem), for: .touchUpInside)
        button.sizeToFit()
        
        let backItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = backItem
    }
    
    func setupBackNavigationButton(imageName: String) {
        let backImage = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        let leftItem = UIBarButtonItem(image: backImage,
                                       style: .done,
                                       target: self,
                                       action: #selector(clickedNavLeftItem))
        navigationItem.leftBarButtonItem = leftItem
    }
    
    //根据字符串得到barButtonItem
    func barBttonItem(title: String, target: Any, action: Selector, for controlEvents: UIControlEvents) -> UIBarButtonItem {
        let button = UIButton()
        button.titleLabel?.font = cmSystemFontWithSize(15)
        button.setTitleColor(cmColorWithString(colorName: "ffffff"), for: .normal)
        button.setTitleColor(cmColorWithString(colorName: "ffffff").withAlphaComponent(0.5), for: .highlighted)
        button.setTitleColor(cmColorWithString(colorName: "6d6d6d"), for: .disabled)
        button.setTitle(title, for: .normal)
        button.setTitle(title, for: .highlighted)
        button.setTitle(title, for: .disabled)
        button.addTarget(target, action: action, for: controlEvents)
        button.sizeToFit()
        
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
    
    //根据字符串得到barButtonItem
    func barBttonItem(imageName: String, target: Any, action: Selector) -> UIBarButtonItem {
        let barItemImage = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: barItemImage,
                                       style: .done,
                                       target: self,
                                       action: action)
        return barButtonItem
    }
    
    //隐藏导航栏底部线
    func hideShadowInNavigationBar() {
        let whiteImage = UIImage.image(by: .navigationBG)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.setBackgroundImage(whiteImage, for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc   func clickedNavLeftItem() {
        self.navigationController?.popViewController(animated: true)
    }
}



