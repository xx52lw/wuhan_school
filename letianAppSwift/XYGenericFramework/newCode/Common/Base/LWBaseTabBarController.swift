//
//  LWBaseTabBarController.swift
//  Loter-swift
//
//  Created by 张星星 on 2018/3/30.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// =================================================================================================================================
// MARK: - 基础TabBar
class LWBaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setTabBar()
        setTabBarController()
    }
}
// =================================================================================================================================
// MARK: - 基础TabBar
extension LWBaseTabBarController {
    // MARK: - 设置tabbar
    /// 设置tabbar
    func setTabBar() {
        var tabbarColor = LWAppConfigurationModel.sharedInstance().tabbarColor;
        if tabbarColor.count <= 0 {
            tabbarColor = "#ffffff"
        }
        var textColor = LWAppConfigurationModel.sharedInstance().tabbarTextColor;
        if textColor.count <= 0 {
            textColor = "#000000"
        }
        var selectedTextColor = LWAppConfigurationModel.sharedInstance().tabbarSelectedTextColor;
        if selectedTextColor.count <= 0 {
            selectedTextColor = "#000000"
        }
        var textFont = LWAppConfigurationModel.sharedInstance().tabbarTextFont
        if textFont.count <= 0 {
            textFont = "11"
        }
        // tabbar背景颜色
        self.tabBar.barTintColor = UIColor.colorFromHex(hex: tabbarColor)
        // 设置item中文字的样式
        let normalAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.colorFromHex(hex: textColor),
                                  NSAttributedString.Key.font : UIFont.systemFont(ofSize: CGFloat(Double(textFont)!)),
                                ]
        self.tabBarItem.setTitleTextAttributes(normalAttributes, for: UIControl.State.normal)
        let selectedAttributes = [
                                NSAttributedString.Key.foregroundColor : UIColor.colorFromHex(hex: selectedTextColor),
                                NSAttributedString.Key.font : UIFont.systemFont(ofSize: CGFloat(Double(textFont)!)),
                                ]
        self.tabBarItem.setTitleTextAttributes(selectedAttributes, for: UIControl.State.selected)
        // 设置顶部线条颜色
        let tabbarTopLineColor = LWAppConfigurationModel.sharedInstance().tabbarTopLineColor
        if tabbarTopLineColor.count > 0 {
            self.tabBar.shadowImage = UIImage.imageDrawWithColor(color: UIColor.colorFromHex(hex: tabbarTopLineColor), size: CGSize.init(width: self.view.width, height: 1.0))
            self.tabBar.backgroundImage = UIImage()
        }
        // 渲染图片
        self.tabBar.tintColor = UIColor.colorFromHex(hex: selectedTextColor)
        let selectedImage = self.tabBarItem.selectedImage
//        selectedImage?.renderingMode = UIImageRenderingMode.alwaysOriginal
        self.tabBarItem.selectedImage = selectedImage;
        self.tabBar.isTranslucent = false
    }
    
    // MARK: - 设置设置子控件
    /// 设置设置子控件
    func setTabBarController() {
        // 默认显示全部
        let showType = "1"
        let showTabbarArray = doAllowShowModelWithType(type: showType)
        var tabbarNavArray = [UIViewController]()
        let itemCount = showTabbarArray.count
        if itemCount <= 0 {
            return
        }
        let w = self.view.width / CGFloat(itemCount)
        let h = 49.0
        let y = 0.0
        var x = 0.0
        let tag = 1000
        for subView  in self.tabBar.subviews {
            if subView.tag == tag {
                subView.removeFromSuperview()
            }
        }
        for index in 0..<itemCount {
            x = Double(w) * Double(index)
            let model  = showTabbarArray.object(at: index) as? LWTabItemsConfigurationModel
            let image = UIImage.init(named: (model?.imageName)!)
            let classVC = createVC(vc: (model?.classString)!)
            let nav = LWBaseNavigationController.init(rootViewController: classVC)
            tabbarNavArray.append(nav)
            if (model?.titleString.count)! <= 0 { // 无文字
                let imageView : UIImageView = UIImageView.init(frame: CGRect.init(x: x, y: y, width: Double(w), height: h))
                imageView.tag = tag
                imageView.backgroundColor = UIColor.clear
                imageView.image = image
                imageView.contentMode = UIView.ContentMode.scaleAspectFit
                self.tabBar.addSubview(imageView)
            }
            else {
                classVC.title = model?.titleString
                let imageName = model?.imageName ?? ""
                classVC.tabBarItem.image = UIImage.init(named: imageName)?.withRenderingMode(.alwaysOriginal)
                classVC.tabBarItem.selectedImage = UIImage.init(named: imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
            }
        }
        viewControllers = tabbarNavArray
    }
    
    // MARK: - 处理允许显示的模型
    func doAllowShowModelWithType(type : String) -> NSArray {
        guard let path = Bundle.main.path(forResource: "tabItemsConfiguration", ofType: ".plist") else {
            return NSArray()
        }
        let array = NSArray.init(contentsOfFile: path)
        let tempArray = NSMutableArray()
        let count = array!.count
        
        for index in 0..<count {
            let dict = array?.object(at: index) as! Dictionary<String, Any>
            let model = LWNetWorkingTool<LWTabItemsConfigurationModel>.getModel(dict: dict)
            if type.count <= 0 {
                tempArray.add(model)
            }
            else {
                let  typeArray = model.showType.components(separatedBy: "|")
                if typeArray.contains(type) {
                    tempArray.add(model)
                }
            }
        }
        return tempArray
    }
    //MARK: 根据类名创建控制器
    func createVC(vc : String) -> UIViewController {

        guard let vcClass = NSClassFromString(Bundle.main.nameSpace + "." + vc) as? LWBaseViewController.Type

            else {
                return UIViewController()
        }
        let classVC = vcClass.init()
        return classVC

    }
}
// =================================================================================================================================
