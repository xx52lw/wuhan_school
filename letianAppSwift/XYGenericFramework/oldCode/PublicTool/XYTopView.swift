//
//  XYTopView.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/10/2.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class XYTopView: UIView,UITextFieldDelegate {
    
    let XY_BUTTON_TOUCH_SIZE = CGFloat(44)

    class func creatCustomTopView() -> XYTopView {
        let customBar = XYTopView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: STATUS_NAV_HEIGHT))
        //customBar.backgroundColor = MAIN_BLUE
        customBar.layer.addSublayer(UIColor.createGradientLayer(needSetView: customBar, fromColor: cmColorWithString(colorName: "03aaff"), toColor: cmColorWithString(colorName: "0386fe")))
        return customBar
    }
    

    
    //MARK: - 标题栏
    var titleLabel:UILabel!
    func navigationTitleItem() -> XYTopView {
        titleLabel = UILabel(frame: CGRect(x: XY_BUTTON_TOUCH_SIZE*CGFloat(1.5), y: STATUSBAR_HEIGHT, width: SCREEN_WIDTH-XY_BUTTON_TOUCH_SIZE*CGFloat(3), height: XY_BUTTON_TOUCH_SIZE))
        titleLabel.textColor = MAIN_WHITE
        titleLabel.textAlignment = .center
        titleLabel.font = cmSystemFontWithSize(16)
        //titleLabel.backgroundColor = cmColorWithString(colorName:"666666")
        addSubview(titleLabel)
        return self
    }
    
    //MARK: - 常规返回按钮
    var backImageBtn:UIButton!
    let backBtnImage = #imageLiteral(resourceName: "backBtn")
    func createLeftBackBtn(target:UIViewController, action:Selector?) -> XYTopView {
        backImageBtn = UIButton(frame: CGRect(x: 0, y: STATUSBAR_HEIGHT, width: XY_BUTTON_TOUCH_SIZE, height: XY_BUTTON_TOUCH_SIZE))
        backImageBtn.setImage(backBtnImage, for: .normal)
        if action != nil {
        backImageBtn.addTarget(target, action: action!, for: .touchUpInside)
        }else{
        backImageBtn.addTarget(self, action: #selector(backBtnAct(sender:)), for: .touchUpInside)
        }
        //backImageBtn.backgroundColor = cmColorWithString(colorName: "123456")
        self.addSubview(backImageBtn)
        
        return self
    }
    
    //返回按钮响应
    @objc func backBtnAct(sender:UIButton){
        
        sender.getViewControllerFromView()?.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    //MARK: - 最右右图片按钮
    var rightImageBtn:UIButton!
    func rightImageBtnItme(target:UIViewController, action:Selector?,btnImage:UIImage) -> XYTopView {
        rightImageBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH-XY_BUTTON_TOUCH_SIZE, y: STATUSBAR_HEIGHT, width: XY_BUTTON_TOUCH_SIZE, height: XY_BUTTON_TOUCH_SIZE))
        rightImageBtn.setImage(btnImage, for: .normal)
        if action != nil {
            rightImageBtn.addTarget(target, action: action!, for: .touchUpInside)
        }
        //rightImageBtn.backgroundColor = cmColorWithString(colorName: "123456")
        self.addSubview(rightImageBtn)
        return self
    }
    
    
    //MARK: - 右边第二个图片按钮
    var secondRightImageBtn:UIButton!
    func secondRightBtnItem(target:UIViewController, action:Selector?,btnImage:UIImage) -> XYTopView {
        secondRightImageBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH-XY_BUTTON_TOUCH_SIZE*2, y: STATUSBAR_HEIGHT, width: XY_BUTTON_TOUCH_SIZE, height: XY_BUTTON_TOUCH_SIZE))
        secondRightImageBtn.setImage(btnImage, for: .normal)
        if action != nil {
            secondRightImageBtn.addTarget(target, action: action!, for: .touchUpInside)
        }
        //rightImageBtn.backgroundColor = cmColorWithString(colorName: "123456")
        self.addSubview(secondRightImageBtn)
        return self
    }
    
    //MARK: - 右文字按钮
    var  rightStrBtn:UIButton!
    func rightStrBtnItem(target:Any,action:Selector,btnStr:String,fontSize:CGFloat) -> XYTopView{
        var buttonWidth = XY_BUTTON_TOUCH_SIZE
        let strWidth = btnStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(fontSize)), font: cmSystemFontWithSize(fontSize))
        if strWidth > CGFloat(44){
            buttonWidth = strWidth
        }
        rightStrBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH - XY_BUTTON_TOUCH_SIZE, y: STATUSBAR_HEIGHT, width: buttonWidth, height: XY_BUTTON_TOUCH_SIZE))
        rightStrBtn.setTitle(btnStr, for: .normal)
        rightStrBtn.setTitleColor(MAIN_WHITE, for: .normal)
        rightStrBtn.titleLabel?.font = cmSystemFontWithSize(fontSize)
        rightStrBtn.contentHorizontalAlignment = .left
        rightStrBtn.addTarget(target, action: action, for: .touchUpInside)
        //rightStrBtn.backgroundColor = cmColorWithString(colorName: "666666")
        self.addSubview(rightStrBtn)
        return self
    }
    
    //MARK: - 搜索栏
    var searchTextField:UITextField!
    var searchDeleteBtn:UIButton!
    func searchTextFieldItem(placeholderStr:String?) -> XYTopView{
        
        let serchTFieldToside = cmSizeFloat(15)
        let serchTFieldHeight = cmSizeFloat(24)
        let serchImage = #imageLiteral(resourceName: "textFieldSearch")
        let deletWordsImage = #imageLiteral(resourceName: "textfieldDelete")
        var placeholderText:NSAttributedString!
        
        searchTextField = UITextField(frame: CGRect(x: XY_BUTTON_TOUCH_SIZE + serchTFieldToside, y: STATUSBAR_HEIGHT + CGFloat((XY_BUTTON_TOUCH_SIZE-serchTFieldHeight)/2), width: SCREEN_WIDTH - XY_BUTTON_TOUCH_SIZE*2 - serchTFieldToside*2, height: serchTFieldHeight))
        if placeholderStr == nil {
            placeholderText = NSAttributedString(string: "请输入需要搜索的内容", attributes: [NSAttributedStringKey.foregroundColor:MAIN_GRAY])
        }else{
            placeholderText = NSAttributedString(string: placeholderStr!, attributes: [NSAttributedStringKey.foregroundColor:MAIN_GRAY])
        }
        searchTextField.attributedPlaceholder = placeholderText
        
        searchTextField.font = cmSystemFontWithSize(13)
        searchTextField.textColor = MAIN_BLACK
        searchTextField.backgroundColor = MAIN_WHITE
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: cmSizeFloat(7+9) + serchImage.size.width, height: serchTFieldHeight))
        let searchImageView = UIImageView(frame: CGRect(x: cmSizeFloat(9), y: CGFloat(serchTFieldHeight - serchImage.size.height)/2, width: serchImage.size.width, height: serchImage.size.height))
        searchImageView.image = serchImage
        leftView.addSubview(searchImageView)
        
        searchTextField.leftView = leftView
        searchTextField.leftViewMode = .always
        
        
        searchDeleteBtn = UIButton(frame: CGRect(x: searchTextField.width - cmSizeFloat(8), y: 0, width: deletWordsImage.size.width + cmSizeFloat(16), height: serchTFieldHeight))
        searchDeleteBtn.setImage(deletWordsImage, for: .normal)
        searchDeleteBtn.addTarget(self, action: #selector(deleteBtnAct), for: .touchUpInside)
        
        searchTextField.rightView = searchDeleteBtn
        searchTextField.rightViewMode = .never
        
        searchTextField.layer.cornerRadius = serchTFieldHeight/2
        
        searchTextField.delegate = self
        
        self.addSubview(searchTextField)
        return self
    }
    
    
    //删除输入框中文字
    @objc func deleteBtnAct(){
        searchTextField.rightViewMode = .never
        searchTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    //MARK: - 首页定位按钮
    var locationBtn:UIButton!
    var locationBtnTitleLab:UILabel!
    var locationImageView:UIImageView!
    func createLocationBtn(titleStr:String,action:Selector,target:Any) -> XYTopView{
        let locationPic = #imageLiteral(resourceName: "locationBtnImage")
        
        var matchTitleStr:String!
        if titleStr.count > 8 {
            matchTitleStr = titleStr[0..<8] + "..."
        }else{
            matchTitleStr = titleStr
        }
        
        let titleStrWidth = matchTitleStr.stringWidth(cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(18)), font: cmBoldSystemFontWithSize(18))
        locationBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH/2 - (locationPic.size.width + titleStrWidth + cmSizeFloat(10))/2, y: STATUSBAR_HEIGHT, width: locationPic.size.width + titleStrWidth + cmSizeFloat(10), height: XY_BUTTON_TOUCH_SIZE))
        locationBtn.addTarget(target, action: action, for: .touchUpInside)
        
        locationImageView = UIImageView(frame: CGRect(x: 0, y: XY_BUTTON_TOUCH_SIZE/2 - locationPic.size.height/2, width: locationPic.size.width, height: locationPic.size.height))
        locationImageView.image = locationPic
        locationBtn.addSubview(locationImageView)
        
        locationBtnTitleLab = UILabel(frame: CGRect(x: locationImageView.frame.maxX + cmSizeFloat(10), y: 0, width: titleStrWidth, height: XY_BUTTON_TOUCH_SIZE))
        locationBtnTitleLab.text = matchTitleStr
        locationBtnTitleLab.textColor = MAIN_WHITE
        locationBtnTitleLab.font = cmBoldSystemFontWithSize(18)
        locationBtn.addSubview(locationBtnTitleLab)
        self.addSubview(locationBtn)
        return self
    }
    
    
    
    
    //MARK: - 回收键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
