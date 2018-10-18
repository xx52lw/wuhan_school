//
//  StaffDeliveriedOrderTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/26.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class StaffDeliveriedOrderTabcell: UITableViewCell {
    static var cellHeight = cmSizeFloat(50+8+7+12*2) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))
    let deliveryNumHeight = cmSizeFloat(50)
    let toside = cmSizeFloat(20)
    let textSpace = cmSizeFloat(8)
    let seperateViewHieght = cmSizeFloat(7)
    let orderTimeTotop = cmSizeFloat(12)
    
    
    var deliveryNumLabel:UILabel!
    var useTimeLabel:UILabel!
    var orderCreateTimeLabel:UILabel!
    var deliveryTypeLabel:UILabel!
    var topSeperateView:UIView!
    var deliveryNoBottomLine:UIView!
    var recieverInfoLabel:UILabel!
    var recieverTitleLabel:UILabel!
    
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
            
            
            useTimeLabel = UILabel(frame: .zero)
            useTimeLabel.font = cmSystemFontWithSize(13)
            useTimeLabel.textColor = MAIN_BLACK
            useTimeLabel.textAlignment = .right
            self.addSubview(useTimeLabel)
            
            deliveryNoBottomLine = XYCommonViews.creatCommonSeperateLine(pointY: deliveryNumLabel.bottom - cmSizeFloat(1))
            self.addSubview(deliveryNoBottomLine)
            
            
            orderCreateTimeLabel  = UILabel(frame: .zero)
            orderCreateTimeLabel.font = cmSystemFontWithSize(13)
            orderCreateTimeLabel.textColor = MAIN_BLACK
            orderCreateTimeLabel.textAlignment = .left
            self.addSubview(orderCreateTimeLabel)
            
            deliveryTypeLabel  = UILabel(frame: .zero)
            deliveryTypeLabel.font = cmSystemFontWithSize(15)
            deliveryTypeLabel.textColor = MAIN_RED
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
            

        }
        
    }
    
    
    //MARK: - model 设置
    func setModel(model:StaffOrderListCellModel) {
        
        
        let deliveryTypeWidth = model.ArriveStatus.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
        deliveryTypeLabel.frame = CGRect(x: SCREEN_WIDTH - toside - deliveryTypeWidth, y: topSeperateView.bottom, width: deliveryTypeWidth, height: deliveryNumHeight)
        deliveryTypeLabel.text = model.ArriveStatus
        

        
        let deliveryNoStr = "#" + model.DeliveryNo
        deliveryNumLabel.frame = CGRect(x: toside, y: topSeperateView.bottom, width: SCREEN_WIDTH - toside*3 - deliveryTypeWidth, height: deliveryNumHeight)
        deliveryNumLabel.text = deliveryNoStr

        
        let leftTimeStr = String(model.UseTime) + "分钟"
        let leftTimeWidth = leftTimeStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        useTimeLabel.frame = CGRect(x: SCREEN_WIDTH - toside - leftTimeWidth, y:  deliveryNumLabel.bottom + orderTimeTotop, width: leftTimeWidth, height:cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)) )
        useTimeLabel.text = leftTimeStr
        
        deliveryNoBottomLine.frame.origin.y = deliveryNumLabel.bottom - cmSizeFloat(1)
        
        orderCreateTimeLabel.frame = CGRect(x: toside, y: deliveryNumLabel.bottom + orderTimeTotop, width: SCREEN_WIDTH - toside*3 - deliveryTypeWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        orderCreateTimeLabel.text = "送达时间: " +   timeStrFormate(timeStr: model.OrderCreateDT)
        
        let recieverTitleMaxStrWidth = "送达时间: ".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        recieverTitleLabel.frame = CGRect(x: toside, y: orderCreateTimeLabel.bottom + textSpace, width: recieverTitleMaxStrWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        recieverTitleLabel.text = "收货人: "
        
        let recieverInfoStr = model.ReceiverName + "  " + model.RecieverPhone + "  " + model.Address
        let recieverInfoStrHeight = recieverInfoStr.stringHeight(SCREEN_WIDTH - recieverTitleMaxStrWidth - toside*2, font: cmSystemFontWithSize(13))
        recieverInfoLabel.frame = CGRect(x: recieverTitleLabel.right, y: orderCreateTimeLabel.bottom + textSpace, width: SCREEN_WIDTH - recieverTitleMaxStrWidth - toside*2, height: recieverInfoStrHeight)
        recieverInfoLabel.text = recieverInfoStr
        

        
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

