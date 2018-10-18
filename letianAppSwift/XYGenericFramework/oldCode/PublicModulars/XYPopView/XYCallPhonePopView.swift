//
//  XYCallPhonePopView.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/31.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class XYCallPhonePopView: UIView {

    private var control:UIControl!
    var sheetView:UIView!
    private var phoneStrArr:[String] = Array()

    
    let phoneNumViewHeight = cmSizeFloat(50)
    let sheetViewWidth = SCREEN_WIDTH - cmSizeFloat(25*2)
    let toside = cmSizeFloat(25)

    
    //点击背景是否收回View
    var clickControlHideView:Bool = true
    
    init(frame: CGRect,phoneNumArr:[String]) {
        super.init(frame: frame)
        phoneStrArr = phoneNumArr
       let sheetViewHeight = CGFloat(phoneNumArr.count) * phoneNumViewHeight
        
        self.frame = CGRect(x: toside, y: SCREEN_HEIGHT/2 - sheetViewHeight/2 , width: sheetViewWidth, height: sheetViewHeight)
        
        control = UIControl.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        control.backgroundColor = cmColorWithString(colorName: "000000", alpha: 0.3)
        control.addTarget(self, action: #selector(controlClick), for: .touchUpInside)
        
        sheetView = UIView(frame: CGRect(x: 0, y: 0 , width: sheetViewWidth, height: sheetViewHeight))
        sheetView.backgroundColor = cmColorWithString(colorName: "fafafa")
        sheetView.clipsToBounds = true
        sheetView.layer.cornerRadius = cmSizeFloat(5)
        self.addSubview(sheetView)
        
        for index in 0..<phoneNumArr.count {
            
            let phoneBtn  = UIButton(frame: CGRect(x: 0, y: phoneNumViewHeight*CGFloat(index), width: sheetViewWidth, height: phoneNumViewHeight))
            phoneBtn.setTitleColor(MAIN_BLACK, for: .normal)
            phoneBtn.setTitle(phoneNumArr[index], for: .normal)
            phoneBtn.titleLabel?.font = cmSystemFontWithSize(16)
            phoneBtn.tag = 200 + index
            phoneBtn.addTarget(self, action: #selector(phoneBtnAct(sender:)), for: .touchUpInside)
            sheetView.addSubview(phoneBtn)
        }

        
        

        
    }
    
    
    @objc func phoneBtnAct(sender:UIButton){
        self.hideInView()
        cmMakePhoneCall(phoneStr:phoneStrArr[sender.tag - 200] )
    }
    

    
    
    func showInView(view:UIView){
        self.isHidden = false
        if (control.superview==nil) {
            view.addSubview(control)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.control.alpha = 1
        })
        let animation = CATransition()
        
        animation.duration = 0.2
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        self.layer.add(animation, forKey: "animation1")
        //self.frame = CGRect(x:0,y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGHT);
        view.addSubview(self)
    }
    
    
    
    func hideInView() {
        if !self.isHidden {
            self.isHidden = true
            let animation = CATransition()
            
            animation.duration = 0.2
            animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            
            animation.type = kCATransitionPush
            animation.subtype = kCATransitionFromBottom
            self.layer.add(animation, forKey: "animation2")
            UIView.animate(withDuration: 0.2, animations: {
                self.control.alpha = 0
            }) { (Bool) in
                self.removeFromSuperview()
            }
        }
    }
    
    
    
    @objc func controlClick() {
        if clickControlHideView == true {
            self.hideInView()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    //    func showAlert(title:String?,message:String?,vc:UIViewController) {
    //        let alertController = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: .alert)
    //        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
    //        vc.present(alertController, animated: true, completion: nil)
    //    }
    
    
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
