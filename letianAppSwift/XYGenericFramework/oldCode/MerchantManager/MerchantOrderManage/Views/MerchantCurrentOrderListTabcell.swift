//
//  MerchantCurrentOrderListTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/11.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantCurrentOrderListTabcell: UITableViewCell {
    static var cellHeight = cmSizeFloat(50+70+7)
    let deliveryNumHeight = cmSizeFloat(50)
    let toside = cmSizeFloat(20)
    let textSpace = cmSizeFloat(8)
    let seperateViewHieght = cmSizeFloat(7)
    let orderTimeTotop = (cmSizeFloat(70-8) - cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))*2)/2
    
    var deliveryNumLabel:UILabel!
    var leftTimeLabel:UILabel!
    var orderCreateTimeLabel:UILabel!
    var orderNumLabel:UILabel!
    var deliveryTypeLabel:UILabel!
    var topSeperateView:UIView!
    var deliveryNoBottomLine:UIView!
    
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
            
            
            orderNumLabel = UILabel(frame: .zero)
            orderNumLabel.font = cmSystemFontWithSize(13)
            orderNumLabel.textColor = MAIN_BLACK
            orderNumLabel.textAlignment = .left
            self.addSubview(orderNumLabel)
            
        }
        
    }
    
    
    //MARK: - model 设置
    func setModel(model:MerchantCurrentOrderCellModel) {
        
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
        
        let deliveryTypeWidth = model.DeliveryType.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        deliveryTypeLabel.frame = CGRect(x: SCREEN_WIDTH - toside - deliveryTypeWidth, y: deliveryNumLabel.bottom + orderTimeTotop, width: deliveryTypeWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        deliveryTypeLabel.text = model.DeliveryType
        
        deliveryNoBottomLine.frame.origin.y = deliveryNumLabel.bottom - cmSizeFloat(1)
        
        orderCreateTimeLabel.frame = CGRect(x: toside, y: deliveryNumLabel.bottom + orderTimeTotop, width: SCREEN_WIDTH - toside*3 - deliveryTypeWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        orderCreateTimeLabel.text = "下单时间: " +   timeStrFormate(timeStr: model.OrderCreateDT)
        
        orderNumLabel.frame = CGRect(x: toside, y: orderCreateTimeLabel.bottom + textSpace, width: SCREEN_WIDTH - toside, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        orderNumLabel.text = "订单单号: " + model.UserOrderID
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
