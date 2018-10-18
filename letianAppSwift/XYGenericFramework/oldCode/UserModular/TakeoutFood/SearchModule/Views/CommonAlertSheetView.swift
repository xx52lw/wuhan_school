//
//  CommonAlertSheetView.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/10.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class CommonAlertSheetView: UIView {

    
    var control:UIControl!
    var sheetView:UIView!

    let MORE_CONTENT_VIEW_HEIGHT = cmSizeFloat(177)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        control = UIControl.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        control.backgroundColor = cmColorWithString(colorName: "000000", alpha: 0.3)
        control.addTarget(self, action: #selector(controlClick), for: .touchUpInside)
        
        sheetView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: MORE_CONTENT_VIEW_HEIGHT))
        sheetView.backgroundColor = cmColorWithString(colorName: "fafafa")
        self.addSubview(sheetView)
        
        let selectFirstBtn = UIButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: MORE_CONTENT_VIEW_HEIGHT/3))
        selectFirstBtn.setTitleColor(MAIN_BLACK, for: .normal)
        selectFirstBtn.setTitle("在商家中搜索", for: .normal)
        selectFirstBtn.titleLabel?.font = cmSystemFontWithSize(14)
        selectFirstBtn.addTarget(self, action: #selector(selectFirstBtnAct), for: .touchUpInside)
        sheetView.addSubview(selectFirstBtn)
        sheetView.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: selectFirstBtn.bottom - cmSizeFloat(1)))
        
        let selectSecondBtn = UIButton(frame: CGRect(x: 0, y: selectFirstBtn.bottom, width: SCREEN_WIDTH, height: MORE_CONTENT_VIEW_HEIGHT/3))
        selectSecondBtn.setTitleColor(MAIN_BLACK, for: .normal)
        selectSecondBtn.setTitle("在商品中搜索", for: .normal)
        selectSecondBtn.titleLabel?.font = cmSystemFontWithSize(14)
        selectSecondBtn.addTarget(self, action: #selector(selectSecondBtnAct), for: .touchUpInside)
        sheetView.addSubview(selectSecondBtn)
        sheetView.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: selectSecondBtn.bottom - cmSizeFloat(1)))
        
        let selectThirdBtn = UIButton(frame: CGRect(x: 0, y: selectSecondBtn.bottom, width: SCREEN_WIDTH, height: MORE_CONTENT_VIEW_HEIGHT/3))
        selectThirdBtn.setTitleColor(MAIN_RED, for: .normal)
        selectThirdBtn.setTitle("取消", for: .normal)
        selectThirdBtn.titleLabel?.font = cmSystemFontWithSize(14)
        selectThirdBtn.addTarget(self, action: #selector(selectThirdBtnAct), for: .touchUpInside)
        sheetView.addSubview(selectThirdBtn)
        sheetView.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: selectThirdBtn.bottom - cmSizeFloat(1)))
        
    }
    
    
    @objc func selectFirstBtnAct(){
        if self.getViewControllerFromView() is SearchViewController{
            (self.getViewControllerFromView() as! SearchViewController).searchCommonAction(searchType:0)
        }
    }
    
    @objc func selectSecondBtnAct(){
        if self.getViewControllerFromView() is SearchViewController{
            (self.getViewControllerFromView() as! SearchViewController).searchCommonAction(searchType:1)
        }
    }
    
    @objc func selectThirdBtnAct(){
        self.hideInView()
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
