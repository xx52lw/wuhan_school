//
//  StaffWaiteToDeliveryTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/26.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class StaffWaiteToDeliveryTabcell: UITableViewCell {
    static var cellHeight = cmSizeFloat(50+8+7+12*3) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)) + cmSizeFloat(25)
    let deliveryNumHeight = cmSizeFloat(50)
    let toside = cmSizeFloat(20)
    let textSpace = cmSizeFloat(8)
    let seperateViewHieght = cmSizeFloat(7)
    let orderTimeTotop = cmSizeFloat(12)
    let btnHeight = cmSizeFloat(25)
    
    let btnStr = "联系收货人"
    
    var deliveryNumLabel:UILabel!
    var leftTimeLabel:UILabel!
    var orderCreateTimeLabel:UILabel!
    var deliveryTypeLabel:UILabel!
    var topSeperateView:UIView!
    var deliveryNoBottomLine:UIView!
    var recieverInfoLabel:UILabel!
    var recieverTitleLabel:UILabel!
    var callRecieverBtn:UIButton!
    
    
    var cellModel:StaffOrderListCellModel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            topSeperateView = XYCommonViews.creatCustomSeperateLine(pointY: 0, lineWidth: SCREEN_WIDTH, lineHeight: seperateViewHieght)
            self.addSubview(topSeperateView)
            
            
            deliveryNumLabel = UILabel(frame: .zero)
            deliveryNumLabel.font = cmBoldSystemFontWithSize(18)
            deliveryNumLabel.textColor = MAIN_BLUE
            deliveryNumLabel.textAlignment = .left
            self.addSubview(deliveryNumLabel)
            
            
            leftTimeLabel = UILabel(frame: .zero)
            leftTimeLabel.font = cmSystemFontWithSize(15)
            leftTimeLabel.textColor = MAIN_RED
            leftTimeLabel.textAlignment = .right
            self.addSubview(leftTimeLabel)
            
            deliveryNoBottomLine = XYCommonViews.creatCommonSeperateLine(pointY: deliveryNumLabel.bottom - cmSizeFloat(1))
            self.addSubview(deliveryNoBottomLine)
            
            
            orderCreateTimeLabel  = UILabel(frame: .zero)
            orderCreateTimeLabel.font = cmSystemFontWithSize(13)
            orderCreateTimeLabel.textColor = MAIN_BLACK
            orderCreateTimeLabel.textAlignment = .left
            self.addSubview(orderCreateTimeLabel)
            
            deliveryTypeLabel  = UILabel(frame: .zero)
            deliveryTypeLabel.font = cmSystemFontWithSize(13)
            deliveryTypeLabel.textColor = MAIN_BLUE
            deliveryTypeLabel.textAlignment = .right
            self.addSubview(deliveryTypeLabel)
            
            recieverTitleLabel  = UILabel(frame: .zero)
            recieverTitleLabel.font = cmSystemFontWithSize(13)
            recieverTitleLabel.textColor = MAIN_BLACK
            recieverTitleLabel.textAlignment = .left
            self.addSubview(recieverTitleLabel)
            
            recieverInfoLabel = UILabel(frame: .zero)
            recieverInfoLabel.font = cmSystemFontWithSize(13)
            recieverInfoLabel.textColor = MAIN_BLACK
            recieverInfoLabel.textAlignment = .left
            recieverInfoLabel.numberOfLines = 0
            self.addSubview(recieverInfoLabel)
            
            callRecieverBtn = UIButton(frame: .zero)
            callRecieverBtn.setTitle(btnStr, for: .normal)
            callRecieverBtn.setTitleColor(MAIN_BLACK, for: .normal)
            callRecieverBtn.titleLabel?.font = cmSystemFontWithSize(13)
            callRecieverBtn.clipsToBounds = true
            callRecieverBtn.layer.cornerRadius = CGFloat(3)
            callRecieverBtn.layer.borderColor = MAIN_BLACK.cgColor
            callRecieverBtn.layer.borderWidth = CGFloat(1)
            callRecieverBtn.addTarget(self, action: #selector(callRecieverBtnAct), for: .touchUpInside)
            self.addSubview(callRecieverBtn)
        }
        
    }
    
    //MARK: - 致电收货人
    @objc func callRecieverBtnAct() {
        cmMakePhoneCall(phoneStr: cellModel.RecieverPhone)
    }
    
    
    //MARK: - model 设置
    func setModel(model:StaffOrderListCellModel) {
        
        cellModel = model
        var showTimeType = ""
        if model.TimeShowType == 1 {
            showTimeType = "距预约 "
        }else if model.TimeShowType == 2 {
            showTimeType = "距超时 "
        }
        let leftTimeStr = showTimeType + String(model.LeftSeconds/60) + "分钟"
        let leftTimeWidth = leftTimeStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
        leftTimeLabel.frame = CGRect(x: SCREEN_WIDTH - toside - leftTimeWidth, y: topSeperateView.bottom, width: leftTimeWidth, height: deliveryNumHeight)
        leftTimeLabel.text = leftTimeStr
        
        let deliveryNoStr = "#" + model.DeliveryNo
        deliveryNumLabel.frame = CGRect(x: toside, y: topSeperateView.bottom, width: SCREEN_WIDTH - toside*3 - leftTimeWidth, height: deliveryNumHeight)
        deliveryNumLabel.text = deliveryNoStr
        
        
        let deliveryTypeStr = model.DeliveryType!
        
        
        let deliveryTypeWidth = deliveryTypeStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        deliveryTypeLabel.frame = CGRect(x: SCREEN_WIDTH - toside - deliveryTypeWidth, y: deliveryNumLabel.bottom + orderTimeTotop, width: deliveryTypeWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        deliveryTypeLabel.text = deliveryTypeStr
        
        deliveryNoBottomLine.frame.origin.y = deliveryNumLabel.bottom - cmSizeFloat(1)
        
        orderCreateTimeLabel.frame = CGRect(x: toside, y: deliveryNumLabel.bottom + orderTimeTotop, width: SCREEN_WIDTH - toside*3 - deliveryTypeWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        orderCreateTimeLabel.text = "下单时间: " +   timeStrFormate(timeStr: model.OrderCreateDT)
        
        let recieverTitleMaxStrWidth = "下单时间: ".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        recieverTitleLabel.frame = CGRect(x: toside, y: orderCreateTimeLabel.bottom + textSpace, width: recieverTitleMaxStrWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        recieverTitleLabel.text = "收货人: "
        
        let recieverInfoStr = model.ReceiverName + "  " + model.RecieverPhone + "  " + model.Address
        let recieverInfoStrHeight = recieverInfoStr.stringHeight(SCREEN_WIDTH - recieverTitleMaxStrWidth - toside*2, font: cmSystemFontWithSize(13))
        recieverInfoLabel.frame = CGRect(x: recieverTitleLabel.right, y: orderCreateTimeLabel.bottom + textSpace, width: SCREEN_WIDTH - recieverTitleMaxStrWidth - toside*2, height: recieverInfoStrHeight)
        recieverInfoLabel.text = recieverInfoStr
        
        let btnWidth = btnStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13)) + cmSizeFloat(8)
        callRecieverBtn.frame = CGRect(x: SCREEN_WIDTH - toside - btnWidth, y: recieverInfoLabel.bottom + orderTimeTotop, width: btnWidth, height: btnHeight)
        
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
