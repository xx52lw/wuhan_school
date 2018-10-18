//
//  
//XYGenericFramework
//
//  Created by xiaoyi on 2017/9/9.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import MBProgressHUD


extension UIView {
    var left: CGFloat {
        set {
            self.frame.origin.x = newValue;
        }
        get {
            return self.frame.origin.x;
        }
    }
    
    var right: CGFloat {
        set {
            let delta = newValue - (self.frame.origin.x + self.frame.width)
            self.frame.origin.x += delta
        }
        get {
            return self.frame.maxX
        }
    }
    
    var top: CGFloat {
        set {
            self.frame.origin.y = newValue
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var bottom: CGFloat {
        set {
            self.frame.origin.y = newValue - self.frame.height
        }
        get {
            return self.frame.maxY
        }
    }
    
    var centerX: CGFloat {
        set {
            self.center.x = newValue;
        }
        get {
            return self.center.x
        }
    }
    
    var centerY: CGFloat {
        set {
            self.center.y = newValue
        }
        get {
            return self.center.y
        }
    }
    
    var width: CGFloat {
        set {
            self.frame.size.width = newValue
        }
        get {
            return self.frame.width
        }
    }
    
    var height: CGFloat {
        set {
            self.frame.size.height = newValue
        }
        get {
            return self.frame.height
        }
    }
    
    var size: CGSize {
        set {
            self.frame.size = newValue
        }
        get {
            return self.frame.size
        }
    }
    
    var origin: CGPoint {
        set {
            self.frame.origin = newValue
        }
        get {
            return self.frame.origin
        }
    }
}

extension UIView {
    //MARK: - 获得当前VIEW的viewcontroller
    func getViewControllerFromView()->UIViewController?{
        var next:UIView? = self
        repeat{
            if  next?.next is UIViewController{
                return (next?.next as! UIViewController)
            }
            next = next?.superview
        }while next != nil
        return nil
    }
    
    
    //MARK: - 获得当前VIEW的UITableView
    func getTableViewFromView()->UITableView?{
        var next:UIView? = self
        repeat{
            if  next?.next is UITableView{
                return (next?.next as! UITableView)
            }
            next = next?.superview
        }while next != nil
        return nil
    }
    
    //MARK: - 自定义toast,显示时长为2S
    public func cmShowMbProgressHUD(message:String)
    {
        let hud:MBProgressHUD=MBProgressHUD.showAdded(to: self, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.detailsLabel.textColor = UIColor.black
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 12)
        hud.detailsLabel.text=message as String
        hud.label.backgroundColor = cmColorWithString(colorName: "000831", alpha: 0.6)
        hud.margin=15
        hud.layer.cornerRadius = 10.0
        hud.removeFromSuperViewOnHide=true
        hud.hide(animated: true, afterDelay: 2)
    }
}

