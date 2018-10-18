//
//  takeFoodTableViewCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/10/3.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SDWebImage

let takeFoodTableViewCellHeight = cmSizeFloat(15*2) + cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(14)) + cmSizeFloat(12) + cmSizeFloat(5*4 + 0.5) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(11)) * 3 + cmSizeFloat(4)

let promotionStrArr = ["积","新","免","折","券","减"]
let globalPromotionCorlorArr = [cmColorWithString(colorName: "8B0000"),cmColorWithString(colorName: "228B22"),cmColorWithString(colorName: "008B8B"),cmColorWithString(colorName: "FF0000"),cmColorWithString(colorName: "FF1493"),cmColorWithString(colorName: "FF8C00")]

class TakeFoodTableViewCell: UITableViewCell {


    
    let sellerImageSize = cmSizeFloat(60)
    let toTopOrbottom = cmSizeFloat(15)
    let toside = cmSizeFloat(20)
    let lineHeight = cmSizeFloat(5)
    let gradeViewHeight = cmSizeFloat(12)
    let unselectStar = #imageLiteral(resourceName: "takeFoodUnselectedStar")
    let selectedStar = #imageLiteral(resourceName: "takeFoodSelectedStar")
    let forSchoolStr = "校园专送"
    let forSchoolWidth = "校园专送".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(11)), font: cmSystemFontWithSize(11))
    let supportAppointmentStr = "预约"
    let supportAppointmentStrWidth = "预约".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(11)), font: cmSystemFontWithSize(11))
    let promotionLabelSize = "积".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(10)), font: cmSystemFontWithSize(10))
    
    var sellerImageView:UIImageView!
    var sellerNameLabel:UILabel!
    var gradeView:UIView!
    var gradeLabel:UILabel!
    var deliveryFeeLabel:UILabel!
    var startPriceLabel:UILabel!
    var sellerPromotionView:UIView!
    //配送时长
    var deliveryTimeLabel:UILabel!
    //配送距离
    var deliveryDistanceLabel:UILabel!
    //是否支持校园专送label
    var forSchoolLabel:UILabel!
    //是否支持预约
    var supportAppointmentLabel:UILabel!
    //评分星星数组
    var starsImageViewArr:[UIImageView] = Array()
    //商家活动label
    var activityTitleLabel:UILabel!
    //暂停营业标识
    var isPauseLabel:UILabel!
    
    var promotionBackgroundCorlorArr:[UIColor] = Array()
    var promotionLabelStrArr:[String] = Array()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            //self.backgroundColor = cmColorWithString(colorName: "123456")
          sellerImageView = UIImageView(frame: CGRect(x: toside, y: toTopOrbottom, width: sellerImageSize, height: sellerImageSize))
          self.addSubview(sellerImageView)
            
           isPauseLabel = UILabel(frame: CGRect(x: 0, y: sellerImageSize - cmSizeFloat(18), width: sellerImageSize, height: cmSizeFloat(18)))
            isPauseLabel.backgroundColor = cmColorWithString(colorName: "333333", alpha: 0.6)
            isPauseLabel.font = cmSystemFontWithSize(12)
            isPauseLabel.textColor = MAIN_WHITE
            isPauseLabel.textAlignment = .center
            isPauseLabel.text = "暂停营业"
            isPauseLabel.isHidden = true
            sellerImageView.addSubview(isPauseLabel)
            
            sellerNameLabel = UILabel(frame: CGRect(x:sellerImageView.frame.maxX + cmSizeFloat(10), y: toTopOrbottom, width: SCREEN_WIDTH - sellerImageView.frame.maxX - cmSizeFloat(10) - toside, height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(14))))
            sellerNameLabel.font = cmBoldSystemFontWithSize(14)
            sellerNameLabel.textColor = MAIN_BLACK
            sellerNameLabel.textAlignment = .left
            self.addSubview(sellerNameLabel)
            
            gradeView = UIView(frame: CGRect(x: sellerImageView.frame.maxX + cmSizeFloat(10), y: sellerNameLabel.frame.maxY + cmSizeFloat(4), width: SCREEN_WIDTH - sellerImageView.frame.maxX - cmSizeFloat(10) - toside, height: gradeViewHeight))
            
            for index in 0..<5{
                let imageView = UIImageView(frame: CGRect(x: selectedStar.size.width * CGFloat(index), y: gradeViewHeight/2 - selectedStar.size.height/2, width: selectedStar.size.width, height: selectedStar.size.height))
                imageView.image = selectedStar
                gradeView.addSubview(imageView)
                starsImageViewArr.append(imageView)
                if index == 4 {
                    gradeLabel = UILabel(frame: CGRect(x:imageView.frame.maxX + cmSizeFloat(4), y: 0, width: SCREEN_WIDTH - imageView.frame.maxX - cmSizeFloat(4) - toside, height: gradeViewHeight))
                    gradeLabel.font = cmSystemFontWithSize(11)
                    gradeLabel.textColor = MAIN_RED
                    gradeLabel.textAlignment = .left
                    gradeView.addSubview(gradeLabel)
                }
            }
            self.addSubview(gradeView)
            
            
            forSchoolLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH - toside - forSchoolWidth, y: gradeView.frame.maxY - gradeViewHeight/2 - cmSingleLineHeight(fontSize: cmSystemFontWithSize(11))/2 , width: forSchoolWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(11))))
            forSchoolLabel.backgroundColor = cmColorWithString(colorName: "1D88DA")
            forSchoolLabel.font = cmSystemFontWithSize(9)
            forSchoolLabel.textAlignment = .center
            forSchoolLabel.layer.cornerRadius = 2
            forSchoolLabel.clipsToBounds = true
            forSchoolLabel.text = forSchoolStr
            forSchoolLabel.textColor = cmColorWithString(colorName: "ffffff")
            self.addSubview(forSchoolLabel)
            
            

            supportAppointmentLabel = UILabel(frame: CGRect(x: forSchoolLabel.frame.origin.x - supportAppointmentStrWidth - cmSizeFloat(5), y: gradeView.frame.maxY - gradeViewHeight/2 - cmSingleLineHeight(fontSize: cmSystemFontWithSize(11))/2 , width: supportAppointmentStrWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(11))))
            supportAppointmentLabel.backgroundColor = cmColorWithString(colorName: "ffffff")
            supportAppointmentLabel.font = cmSystemFontWithSize(9)
            supportAppointmentLabel.textAlignment = .center
            supportAppointmentLabel.layer.cornerRadius = 2
            supportAppointmentLabel.layer.borderColor = cmColorWithString(colorName: "1D88DA").cgColor
            supportAppointmentLabel.layer.borderWidth = CGFloat(0.5)
            supportAppointmentLabel.clipsToBounds = true
            supportAppointmentLabel.text = supportAppointmentStr
            supportAppointmentLabel.textColor = cmColorWithString(colorName: "1D88DA")
            self.addSubview(supportAppointmentLabel)
            
            
            
            
            deliveryFeeLabel = UILabel(frame: CGRect(x:sellerImageView.right + cmSizeFloat(10), y: gradeView.frame.maxY + lineHeight, width: SCREEN_WIDTH - sellerImageView.frame.maxX - cmSizeFloat(10) - toside, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(11))))
            deliveryFeeLabel.font = cmSystemFontWithSize(11)
            deliveryFeeLabel.textColor = MAIN_GRAY
            deliveryFeeLabel.textAlignment = .left
            self.addSubview(deliveryFeeLabel)
            
            
            deliveryTimeLabel = UILabel(frame:.zero)
            deliveryTimeLabel.font = cmSystemFontWithSize(11)
            deliveryTimeLabel.textColor = MAIN_BLUE
            deliveryTimeLabel.textAlignment = .left
            self.addSubview(deliveryTimeLabel)
            
            deliveryDistanceLabel = UILabel(frame:.zero)
            deliveryDistanceLabel.font = cmSystemFontWithSize(11)
            deliveryDistanceLabel.textColor = MAIN_GRAY
            deliveryDistanceLabel.textAlignment = .left
            self.addSubview(deliveryDistanceLabel)
            
            
            startPriceLabel = UILabel(frame: CGRect(x:sellerImageView.right + cmSizeFloat(10), y: deliveryFeeLabel.frame.maxY + lineHeight, width: SCREEN_WIDTH - sellerImageView.frame.maxX - cmSizeFloat(10) - toside, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(11))))
            startPriceLabel.font = cmSystemFontWithSize(11)
            startPriceLabel.textColor = MAIN_GRAY
            startPriceLabel.textAlignment = .left
            self.addSubview(startPriceLabel)
            
            
            
            
          sellerPromotionView = UIView(frame: CGRect(x: sellerImageView.frame.maxX + cmSizeFloat(10), y: startPriceLabel.frame.maxY + lineHeight, width: SCREEN_WIDTH - sellerImageView.frame.maxX - cmSizeFloat(10) - toside, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(14))))

            
            self.addSubview(sellerPromotionView)

            let  seperateLine = XYCommonViews.creatCustomSeperateLine(pointY: sellerPromotionView.frame.maxY + toTopOrbottom, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(0.5))
            self.addSubview(seperateLine)
            
            
        }
    }
    
    
    
    func setModel(model:TakeFoodCellModel){
        
        //优惠小图标数据处理
        promotionLabelStrArr.removeAll()
        promotionBackgroundCorlorArr.removeAll()
        if model.JFExchange == true {
            promotionLabelStrArr.append(promotionStrArr[0])
            promotionBackgroundCorlorArr.append(globalPromotionCorlorArr[0])
        }
        if model.newUserReduce == true {
            promotionLabelStrArr.append(promotionStrArr[1])
            promotionBackgroundCorlorArr.append(globalPromotionCorlorArr[1])
        }
        if model.EnoughFreeDelivery == true {
            promotionLabelStrArr.append(promotionStrArr[2])
            promotionBackgroundCorlorArr.append(globalPromotionCorlorArr[2])
        }
        if model.enoughReduce == true {
            promotionLabelStrArr.append(promotionStrArr[5])
            promotionBackgroundCorlorArr.append(globalPromotionCorlorArr[5])
        }
        
        
        
        if let imageUrl = URL(string:model.sellerImageUrl){
        sellerImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeHolderImage"))
        }else{
            sellerImageView.image = #imageLiteral(resourceName: "placeHolderImage")
        }
        
        //暂停营业提示
        if model.IsPause == true || model.IsOpenTime == false {
            isPauseLabel.isHidden = false
        }else{
            isPauseLabel.isHidden = true
        }
        
        
        sellerNameLabel.text = model.sellerTitle
        gradeLabel.text = String(model.sellerGrade)
        
        //配送距离及时间设置
        deliveryTimeLabel.frame = .zero
        deliveryDistanceLabel.frame = .zero
        if !model.deliveryTime.isEmpty{
            let deliveryTimeStrWidth = model.deliveryTime.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(11)), font:  cmSystemFontWithSize(11))
            deliveryTimeLabel.frame = CGRect(x: SCREEN_WIDTH  - toside - deliveryTimeStrWidth, y: gradeView.frame.maxY + lineHeight, width: deliveryTimeStrWidth, height:cmSingleLineHeight(fontSize: cmSystemFontWithSize(11)))
            deliveryTimeLabel.text = model.deliveryTime
            if !model.deliveryDistance.isEmpty{
                let distanceStrWidth = model.deliveryDistance.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(11)), font:  cmSystemFontWithSize(11))
                deliveryDistanceLabel.frame = CGRect(x: deliveryTimeLabel.frame.origin.x - cmSizeFloat(5) - distanceStrWidth,y: gradeView.frame.maxY + lineHeight, width: distanceStrWidth, height:cmSingleLineHeight(fontSize: cmSystemFontWithSize(11)))
                deliveryDistanceLabel.text = model.deliveryDistance
            }
        }else{
            if  !model.deliveryDistance.isEmpty{
                deliveryDistanceLabel.frame = CGRect(x: SCREEN_WIDTH  - toside - model.deliveryDistance.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(11)), font: cmSystemFontWithSize(11)),y: gradeView.frame.maxY + lineHeight, width: model.deliveryDistance.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(11)), font:  cmSystemFontWithSize(11)), height:cmSingleLineHeight(fontSize: cmSystemFontWithSize(11)))
                deliveryDistanceLabel.text = model.deliveryDistance
            }
        }
        
        
        //星星设置
        for  index in  0..<5 {
            starsImageViewArr[index].image = selectedStar
        }

        if Int(model.sellerGrade) < 5 {
        for index in  Int(model.sellerGrade)..<5 {
            starsImageViewArr[index].image = unselectStar
        }
        }
        //专送及预约标签设置
        supportAppointmentLabel.frame.origin.x = forSchoolLabel.frame.origin.x - supportAppointmentStrWidth - cmSizeFloat(5)
        if model.isForSchool == true && model.isSupportAppointment == false {
            supportAppointmentLabel.isHidden = true
            forSchoolLabel.isHidden = false
        }else if model.isForSchool == false && model.isSupportAppointment == true {
            supportAppointmentLabel.isHidden = false
            supportAppointmentLabel.frame.origin.x = SCREEN_WIDTH  - toside - supportAppointmentStrWidth
            forSchoolLabel.isHidden = true
        }else if model.isForSchool == false && model.isSupportAppointment == false {
            supportAppointmentLabel.isHidden = true
            forSchoolLabel.isHidden = true
        }else{
            supportAppointmentLabel.isHidden = false
            forSchoolLabel.isHidden = false
        }
        
        //优惠小图标设置
        
        //清空所有的子view
        for subview in sellerPromotionView.subviews {
            subview.removeFromSuperview()
        }
        
        let titleStr  = "商家活动: "
        activityTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: titleStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(11)), font: cmSystemFontWithSize(11)), height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(11))))
        activityTitleLabel.font = cmSystemFontWithSize(11)
        activityTitleLabel.textColor = MAIN_GRAY
        activityTitleLabel.textAlignment = .left
        sellerPromotionView.addSubview(activityTitleLabel)
        
        if promotionLabelStrArr.count == 0 {
            let tempStr = titleStr + "商家暂无活动"
            activityTitleLabel.text = tempStr
            activityTitleLabel.frame.size.width = tempStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(11)), font: cmSystemFontWithSize(11))
        }else{
            activityTitleLabel.text = titleStr
            activityTitleLabel.frame.size.width = titleStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(11)), font: cmSystemFontWithSize(11))
        }
        
        
        for promotionIndex in 0..<promotionLabelStrArr.count {
            
          let   promotionInfoLabel = UILabel(frame: CGRect(x: activityTitleLabel.frame.maxX + (promotionLabelSize  + cmSizeFloat(5))*CGFloat(promotionIndex), y: cmSingleLineHeight(fontSize: cmSystemFontWithSize(14))/2 - cmSingleLineHeight(fontSize: cmSystemFontWithSize(10))/2, width: promotionLabelSize, height: promotionLabelSize))
            promotionInfoLabel.text = promotionLabelStrArr[promotionIndex]
            promotionInfoLabel.textColor = MAIN_WHITE
            promotionInfoLabel.font = cmSystemFontWithSize(9)
            promotionInfoLabel.textAlignment = .center
            promotionInfoLabel.layer.cornerRadius = 2
            promotionInfoLabel.clipsToBounds = true
            promotionInfoLabel.backgroundColor = promotionBackgroundCorlorArr[promotionIndex]
            sellerPromotionView.addSubview(promotionInfoLabel)
            
        }

        //cmDebugPrint(sellerPromotionView.subviews.count)
        

        deliveryFeeLabel.text = model.deliveryFee
        startPriceLabel.text = model.startPrice
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
