//
//  XYNoDetailTipsAlertView.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class XYNoDetailTipsAlertView: UIView {
    

    
    private var control:UIControl!
    var sheetView:UIView!
    var titleLabel:UILabel!
    var cancelBtn:UIButton!
    var certainBtn:UIButton!
    var cancelclosure:XYpopViewActType?
    var certainclosure:XYpopViewActType!
    
    let titleToTop = cmSizeFloat(15)
    let textToSheetViewSide = cmSizeFloat(15)
    let sheetViewWidth = SCREEN_WIDTH - cmSizeFloat(25*2)
    let toside = cmSizeFloat(25)
    let btnHeight = cmSizeFloat(35)
    
    //点击背景是否收回View
    var clickControlHideView:Bool = true
    
    init(frame: CGRect,titleStr:String,cancelStr:String?,certainStr:String,cancelBtnClosure:XYpopViewActType?, certainClosure:@escaping XYpopViewActType) {
        super.init(frame: frame)
        
        let btnToSheetSide = sheetViewWidth/5
        
        cancelclosure = cancelBtnClosure
        certainclosure = certainClosure
        
        let sheetViewHeight = titleToTop*2 + cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(17)) + btnHeight + titleToTop
        
        self.frame = CGRect(x: toside, y: SCREEN_HEIGHT/2 - sheetViewHeight/2 , width: sheetViewWidth, height: sheetViewHeight)
        
        control = UIControl.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        control.backgroundColor = cmColorWithString(colorName: "000000", alpha: 0.3)
        control.addTarget(self, action: #selector(controlClick), for: .touchUpInside)
        
        sheetView = UIView(frame: CGRect(x: 0, y: 0 , width: sheetViewWidth, height: sheetViewHeight))
        sheetView.backgroundColor = cmColorWithString(colorName: "fafafa")
        sheetView.clipsToBounds = true
        sheetView.layer.cornerRadius = cmSizeFloat(5)
        self.addSubview(sheetView)
        
        
        titleLabel = UILabel(frame: CGRect(x: textToSheetViewSide, y: titleToTop, width: sheetViewWidth - textToSheetViewSide*2, height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(17))))
        titleLabel.textColor = MAIN_BLACK
        titleLabel.font = cmBoldSystemFontWithSize(17)
        titleLabel.textAlignment = .center
        titleLabel.text = titleStr
        sheetView.addSubview(titleLabel)
        
        

        
        if cancelclosure == nil {
            certainBtn = UIButton(frame: CGRect(x: btnToSheetSide, y: titleLabel.bottom + titleToTop, width: sheetViewWidth*3/5, height: btnHeight))
            certainBtn.setTitle(certainStr, for: .normal)
            certainBtn.setTitleColor(MAIN_WHITE, for: .normal)
            certainBtn.titleLabel?.font = cmSystemFontWithSize(15)
            certainBtn.addTarget(self, action: #selector(certainBtnAct), for: .touchUpInside)
            certainBtn.backgroundColor = MAIN_BLUE
            certainBtn.clipsToBounds = true
            certainBtn.layer.cornerRadius = cmSizeFloat(5)
            sheetView.addSubview(certainBtn)
        }else{
            cancelBtn = UIButton(frame: CGRect(x: 0, y: titleLabel.bottom + titleToTop, width: sheetViewWidth/2, height: btnHeight))
            cancelBtn.setTitle(cancelStr, for: .normal)
            cancelBtn.setTitleColor(MAIN_BLUE, for: .normal)
            cancelBtn.titleLabel?.font = cmSystemFontWithSize(15)
            cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
            sheetView.addSubview(cancelBtn)
            
            
            certainBtn = UIButton(frame: CGRect(x: sheetViewWidth/2, y: titleLabel.bottom + titleToTop, width: sheetViewWidth/2, height: btnHeight))
            certainBtn.setTitle(certainStr, for: .normal)
            certainBtn.setTitleColor(MAIN_BLUE, for: .normal)
            certainBtn.titleLabel?.font = cmSystemFontWithSize(15)
            certainBtn.addTarget(self, action: #selector(certainBtnAct), for: .touchUpInside)
            sheetView.addSubview(certainBtn)
        }
        
    }
    
    
    @objc func certainBtnAct(){
        certainclosure()
        self.hideInView()
        
    }
    
    @objc func cancelBtnAct(){
        cancelclosure!()
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
