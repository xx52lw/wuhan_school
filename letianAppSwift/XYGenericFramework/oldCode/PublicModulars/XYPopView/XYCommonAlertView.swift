//
//  ChoosePicCollectionHeaderView.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/3/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit


class XYCommonAlertView: UIView {
    
    typealias AlertBtnActionType = (Int) -> Void
    
    var control:UIControl!
    var sheetView:UIView!
    var selectedBtnAct:AlertBtnActionType!
    
    var MORE_CONTENT_VIEW_HEIGHT = CGFloat(0)
    let btnHeight = cmSizeFloat(45)
    
    init(frame: CGRect,btnStrArr:[String],alertBtnAction:@escaping AlertBtnActionType) {
        super.init(frame: frame)
        self.selectedBtnAct = alertBtnAction
        MORE_CONTENT_VIEW_HEIGHT = btnHeight*CGFloat(btnStrArr.count)
        
        control = UIControl.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        control.backgroundColor = cmColorWithString(colorName: "000000", alpha: 0.3)
        control.addTarget(self, action: #selector(controlClick), for: .touchUpInside)
        
        sheetView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: MORE_CONTENT_VIEW_HEIGHT))
        sheetView.backgroundColor = cmColorWithString(colorName: "fafafa")
        self.addSubview(sheetView)
        
        
        for btnIndex in 0..<btnStrArr.count{
            
            let selectedBtn = UIButton(frame: CGRect(x: 0, y: btnHeight*CGFloat(btnIndex), width: SCREEN_WIDTH, height: btnHeight))
            selectedBtn.setTitleColor(MAIN_BLACK, for: .normal)
            selectedBtn.setTitle(btnStrArr[btnIndex], for: .normal)
            selectedBtn.titleLabel?.font = cmSystemFontWithSize(14)
            selectedBtn.addTarget(self, action: #selector(selectedBtnAct(sender:)), for: .touchUpInside)
            selectedBtn.tag = 200 + btnIndex
            sheetView.addSubview(selectedBtn)
            sheetView.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: selectedBtn.bottom - cmSizeFloat(1)))
            
        }
        

        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func selectedBtnAct(sender:UIButton){
            selectedBtnAct(sender.tag - 200)
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
        self.frame = CGRect(x:0,y:view.frame.size.height - MORE_CONTENT_VIEW_HEIGHT, width:SCREEN_WIDTH, height:MORE_CONTENT_VIEW_HEIGHT);
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
        self.hideInView()
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
