//
//  LWHelpContentDetailView.swift
//  LoterSwift
//
//  Created by liwei on 2018/10/16.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit

class LWHelpContentDetailView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rmbLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeBtn: UIButton!
    
    
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentHeightConstrant: NSLayoutConstraint!
    
    
    @IBOutlet weak var issueImageView: UIImageView!
    
    @IBOutlet weak var headeImageView: UIImageView!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var reportLabel: UIButton!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var contactBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var changeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        titleLabel.textColor = LWBlackColor1
        rmbLabel.textColor = LWOrangeColor
        priceLabel.textColor = LWOrangeColor
        timeBtn.setTitleColor(LWBlackColor2, for: .normal)
        
        contentTitleLabel.textColor = LWBlackColor1
        contentLabel.textColor = LWBlackColor1
        nickLabel.textColor = LWBlackColor2
        areaLabel.textColor = LWBlackColor2
        reportLabel.setTitleColor(LWBlackColor2, for: .normal)
        levelLabel.textColor = LWBlackColor2
        phoneLabel.textColor = LWBlackColor2
        
        contactBtn.backgroundColor = LWBlueColor
        deleteBtn.backgroundColor = LWBlackColor2
        changeBtn.backgroundColor = LWOrangeColor
        
        contactBtn.isHidden = true
        deleteBtn.isHidden = true
        changeBtn.isHidden = true
    }
    
    /// 内容视图模型
    //MARK:  内容视图模型
    var contentModel : LWHelpIssueContentDetailModel! {
        didSet{
            
    
            /// 1：取送 2：悬赏 3：出售
            var msgType = ""
            if contentModel.MsgType == "1" {
                msgType = "取送"
            }
            else if contentModel.MsgType == "2" {
                msgType = "悬赏"
            }
            else if contentModel.MsgType == "3" {
                msgType = "出售"
            }
            titleLabel.text = "主题: " + msgType
            
            //价格
            var price = contentModel.Money
            if price.count > 2 {
                let prefix = String(price.prefix(price.count - 2))
                let suffix = String(price.suffix(2))
                price = prefix + "." + suffix
            }
            if contentModel.IfYJ {
                price = "议价"
            }
            priceLabel.text = price
            
            // 时间按钮
            var time = " 有效时间:" + contentModel.EffectTime + "小时"
            if contentModel.UpdateDT.count >= 17  {
                var sepTime = NSString.init(string: contentModel.UpdateDT)
                sepTime = sepTime.replacingOccurrences(of: "T", with: " ") as NSString
                sepTime = sepTime.substring(with: NSRange.init(location: 5, length: 11)) as NSString
                time = " " + (sepTime as String) + time
            }
            timeBtn.setTitle(time, for: .normal)
            
            
            let textStr = contentModel.MsgContent
            let attributedString = NSMutableAttributedString.init(string: textStr)
            let paragraphStyle = NSMutableParagraphStyle.init()
            paragraphStyle.lineSpacing = 15.0
            paragraphStyle.alignment = .left
            attributedString.addAttribute(NSAttributedString.Key.font, value: contentLabel.font, range: NSRange.init(location: 0, length: textStr.count))
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: textStr.count))
            contentLabel.attributedText = attributedString
            
            
            var imageUrl = ""
            if contentModel.PicList != nil, (contentModel.PicList?.count)! > 0 {
                let pic = contentModel.PicList?.first
                imageUrl = (pic?.PicURL)!
            }
            UIImage.imageUrlAndPlaceImage(imageView: issueImageView, stringUrl: imageUrl, placeholdImage: UIImage.init(named: "tab_me")!)
            UIImage.imageUrlAndPlaceImage(imageView: headeImageView, stringUrl: contentModel.HeadImg, placeholdImage: UIImage.init(named: "tab_me")!)
            nickLabel.text = contentModel.ShowNick ? contentModel.NickName : "不公开"
            areaLabel.text = contentModel.AreaName
            
            reportLabel.setTitle(" 举报" + contentModel.ComplainCount, for: .normal)
            
            phoneLabel.text = contentModel.ShowPhone ? contentModel.Phone : "不公开"
            
        }
    }
    
}
