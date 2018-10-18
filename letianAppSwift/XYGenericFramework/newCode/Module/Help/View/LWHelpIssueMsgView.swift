//
//  LWHelpIssueMsgView.swift
//  LoterSwift
//
//  Created by 张星星 on 2018/10/14.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit

class LWHelpIssueMsgView: UIView,UITextViewDelegate,LWPhotoAssetViewControllerDelegate {

    let selectImage = UIImage.init(named: "help_select")
    let unselectImage = UIImage.init(named: "help_unselect")
    let addImg = UIImage.init(named: "help_addImg")
    
   let issueModel = LWHelpIssueContentModel()
    
    var VC : UIViewController?
    
  
    
    /// 悬赏按钮
    @IBOutlet weak var rewardBtn: UIButton!
    /// 送取按钮
    @IBOutlet weak var fetchBtn: UIButton!
    /// 出售按钮
    @IBOutlet weak var sellBtn: UIButton!
    
    
    /// 悬赏按钮点击
    @IBAction func rewardBtnClick(_ sender: Any) {
       issueModel.MsgType = "2"
       rewardBtn.isSelected = true
       fetchBtn.isSelected = false
       sellBtn.isSelected = false
    }
    /// 送取按钮点击
    @IBAction func fetchBtnClick(_ sender: Any) {
        issueModel.MsgType = "1"
        rewardBtn.isSelected = false
        fetchBtn.isSelected = true
        sellBtn.isSelected = false
    }
    /// 出售按钮点击
    @IBAction func sellBtnClick(_ sender: Any) {
        issueModel.MsgType = "3"
        rewardBtn.isSelected = false
        fetchBtn.isSelected = false
        sellBtn.isSelected = true
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    /// 售价图片
    @IBOutlet weak var priceImage: UIImageView!
    /// 售价输入框
    @IBOutlet weak var priceTextField: UITextField!
    
    /// 议价按钮
    @IBOutlet weak var yjBtn: UIButton!
    /// 议价按钮点击
    @IBAction func yjBtnClick(_ sender: Any) {
        yjBtn.isSelected = true
        priceTextField.text = ""
        priceImage.image = unselectImage
    }
    
    
    
    @IBOutlet weak var contenPlaceLable: UILabel!
    ///内容输入框
    @IBOutlet weak var contentTextView: UITextView!
    
    
    @IBOutlet weak var oneDay: UIButton!
    @IBOutlet weak var threeDay: UIButton!
    @IBOutlet weak var foreDay: UIButton!
    @IBOutlet weak var oneHour: UIButton!
    @IBOutlet weak var threeHour: UIButton!
    @IBOutlet weak var foreHour: UIButton!
    
    @IBAction func timeBtnClick(_ sender: Any) {
        
        oneDay.isSelected = (oneDay.tag == (sender as! UIButton).tag)
        threeDay.isSelected = (threeDay.tag == (sender as! UIButton).tag)
        foreDay.isSelected = (foreDay.tag == (sender as! UIButton).tag)
        oneHour.isSelected = (oneHour.tag == (sender as! UIButton).tag)
        threeHour.isSelected = (threeHour.tag == (sender as! UIButton).tag)
        foreHour.isSelected = (foreHour.tag == (sender as! UIButton).tag)
        
    }
    
    
    
    @IBOutlet weak var unshowPhone: UIButton!
    @IBOutlet weak var showPhone: UIButton!
    @IBAction func unshowPhoneClick(_ sender: Any) {
        unshowPhone.isSelected = true
        showPhone.isSelected = false
    }
    @IBAction func showPhoneClick(_ sender: Any) {
        unshowPhone.isSelected = false
        showPhone.isSelected = true
    }
    @IBOutlet weak var unshowNick: UIButton!
    @IBOutlet weak var showNick: UIButton!
    @IBAction func unshowNickClick(_ sender: Any) {
        unshowNick.isSelected = true
        showNick.isSelected = false
    }
    @IBAction func showNickClick(_ sender: Any) {
        unshowNick.isSelected = false
        showNick.isSelected = true
    }
    
    var uploadImage: UIImage?
    @IBAction func uploadImageBtnClick(_ sender: Any) {
        let  lwPhotoVC = LWPhotoAssetViewController()
        lwPhotoVC.maxSelectCount = 1
        lwPhotoVC.delegate = self
        lwPhotoVC.showView(withVC: VC)
    }
    func photoAssetViewController(_ vc: LWPhotoAssetViewController!, complete selectedArray: [LWPHAsset]!) {
        for item in selectedArray {
            uploadImage = item.originalImage
        }
        if uploadImage != nil {
            deleteBtn.isHidden = false
            uploadImageBtn.setBackgroundImage(uploadImage, for: .normal)
        }
    }
    @IBOutlet weak var uploadImageBtn: UIButton!
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBAction func deleteBtnClick(_ sender: Any) {
        
        uploadImage = nil
        uploadImageBtn.setBackgroundImage(addImg, for: .normal)
        deleteBtn.isHidden = true
    }
    
    
    @IBOutlet weak var issueBtn: UIButton!
    
    @IBAction func issueBtnClick(_ sender: Any) {
        checkContent()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        fetchBtn.setTitleColor(LWBlackColor2, for: .normal)
        rewardBtn.setTitleColor(LWBlackColor2, for: .normal)
        sellBtn.setTitleColor(LWBlackColor2, for: .normal)
        yjBtn.setTitleColor(LWBlackColor1, for: .normal)
        oneDay.setTitleColor(LWBlackColor1, for: .normal)
        threeDay.setTitleColor(LWBlackColor1, for: .normal)
        foreDay.setTitleColor(LWBlackColor1, for: .normal)
        oneHour.setTitleColor(LWBlackColor1, for: .normal)
        threeHour.setTitleColor(LWBlackColor1, for: .normal)
        foreHour.setTitleColor(LWBlackColor1, for: .normal)
        unshowPhone.setTitleColor(LWBlackColor1, for: .normal)
        showPhone.setTitleColor(LWBlackColor1, for: .normal)
        unshowNick.setTitleColor(LWBlackColor1, for: .normal)
        showNick.setTitleColor(LWBlackColor1, for: .normal)
        issueBtn.setTitleColor(LWBlackColor1, for: .normal)
        issueBtn.backgroundColor = LWBlueColor
        
        priceTextField.addTarget(self, action: #selector(priceTextFieldChange), for: UIControl.Event.editingChanged)
        contentTextView.delegate = self
        contentTextView.text = ""
        contenPlaceLable.textColor = LWBlackColor3
        rewardBtn.isSelected = true
        priceImage.image = unselectImage
        yjBtn.isSelected = true
        oneDay.isSelected = true
        unshowPhone.isSelected = true
        unshowNick.isSelected = true
        uploadImageBtn.setBackgroundImage(addImg, for: .normal)
        deleteBtn.setTitleColor(LWBlackColor3, for: .normal)
        deleteBtn.isHidden = true
    }
    /// 输入框内容改变
    @objc func priceTextFieldChange() {
        if (priceTextField.text?.count)! > 0 {
            priceImage.image = selectImage
            yjBtn.isSelected = false
        }
        else {
            priceImage.image = unselectImage
            yjBtn.isSelected = true
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text?.count)! > 0 {
            contenPlaceLable.isHidden = true
        }
        else {
            contenPlaceLable.isHidden = false
        }
    }
    
    /// 检查内容
    func checkContent() {
        LWProgressHUD.show(infoStr: "正在发布")
        
        issueModel.Money = ""
        if let moneyString = priceTextField.text {
            if moneyString.count > 0 {
                if moneyString.count > 3 {
                    LWProgressHUD.showInfo(infoStr: "请输入正确金额在1~999之内")
                    return
                }
                else {
                    issueModel.Money = moneyString + "00"
                }
            }
        }
        
        if yjBtn.isSelected == false ,priceTextField.text != nil ,(priceTextField.text?.count)! <= 0 {
            LWProgressHUD.showInfo(infoStr: "请输选择金额或者议价")
            return
        }
        
        issueModel.MsgTitle =  titleTextField.text!
        
        if let contentString = contentTextView.text {
            if contentString.count >= 6, contentString.count <= 300 {
                issueModel.MsgContent = contentString
            }
            else {
                LWProgressHUD.showInfo(infoStr: "请输入内容描述6~300个字符内")
                return
            }
        }
        else {
            LWProgressHUD.showInfo(infoStr: "请输入内容描述")
            return
        }
        
       
        
        self.issueModel.Pics = ""
        if uploadImage != nil {
            guard let imageData = OCCommonTools.imageOrange(uploadImage, defaultScale: 0.5, maxM: 0.3) else {
                issueContent()
                return
            }
            LWNetWorkingTool<LWBaseModel>.uploadImagesRequest(url: LWHelpIssueContentModelUploadImageUrl, imageDatas: [imageData], imageNames: ["Filedata"], uploadProgresBlock: { (p) in
                
            }, successBlock: { (data) in
                self.issueModel.Pics = data!.dataString! as! String
                self.issueContent()
            }) { (error) in
                LWProgressHUD.dismiss()
                LWProgressHUD.showError(infoStr: error.domain)
            }
        }
        else {
            issueContent()
        }
        
        
    }
    func issueContent() {
//        {"ShowPhone":false,"MsgType":"","MsgTitle":"","ShowNick":false,"IfYJ":true,"EffectTime":"","MsgContent":"The tyt","Pics":"18101514115017313.png","Money":""}
        
        if rewardBtn.isSelected == true {
            issueModel.MsgType = "2"
        }
        else if fetchBtn.isSelected == true {
            issueModel.MsgType = "1"
        }
        else if sellBtn.isSelected == true {
            issueModel.MsgType = "3"
        }
        else {
            issueModel.MsgType = ""
        }
        issueModel.IfYJ = yjBtn.isSelected == true ? "true" : "false"
        
        
        if oneDay.isSelected == true {
            issueModel.EffectTime = "24"
        }
        else if threeDay.isSelected == true {
            issueModel.EffectTime = "72"
        }
        else if foreDay.isSelected == true {
            issueModel.EffectTime = "96"
        }
        else if oneHour.isSelected == true {
            issueModel.EffectTime = "1"
        }
        else if threeHour.isSelected == true {
            issueModel.EffectTime = "3"
        }
        else if foreHour.isSelected == true {
            issueModel.EffectTime = "4"
        }
        else {
            issueModel.EffectTime = ""
        }
        issueModel.ShowPhone = showPhone.isSelected == true ? "true" : "false"
        issueModel.ShowNick = showNick.isSelected == true ? "true" : "false"
        let params = LWNetWorkingTool<LWHelpIssueContentModel>.getDictinoary(model: issueModel)
        LWNetWorkingTool<LWHelpIssueContentModel>.postDataFromeServiceRequest(url: LWHelpIssueContentModelUrl, params: params, successBlock: { (jsonModel) in
            LWProgressHUD.dismiss()
            LWProgressHUD.showSuccess(infoStr: "发布成功")
        }) { (error) in
            LWProgressHUD.dismiss()
            LWProgressHUD.showError(infoStr: error.domain)
        }
    }
}

