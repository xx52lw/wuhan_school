//
//  MerchantDeliveringOrderListTabCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/11.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantDeliveringOrderListTabCell: UITableViewCell {
    static var cellHeight = cmSizeFloat(50+8*2+12*2) +  cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))*3  + cmSizeFloat(7)
    
    let deliveryNumHeight = cmSizeFloat(50)
    let toside = cmSizeFloat(20)
    let textSpace = cmSizeFloat(8)
    let textToDeliveryNumHeight = cmSizeFloat(12)
    let seperateViewHieght = cmSizeFloat(7)
    
    
    var deliveryNumLabel:UILabel!
    var deliveryStatusLabel:UILabel!
    var orderCreateTimeLabel:UILabel!
    var leftTimeLabel:UILabel!
    var orderNumLabel:UILabel!
    var deliveryManLabel:UILabel!

    var bottomeSeperateView:UIView!
    var deliveryNoBottomLine:UIView!
    

    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {

            
            
            deliveryNumLabel = UILabel(frame: .zero)
            deliveryNumLabel.font = cmBoldSystemFontWithSize(18)
            deliveryNumLabel.textColor = MAIN_BLUE
            deliveryNumLabel.textAlignment = .left
            self.addSubview(deliveryNumLabel)
            
            deliveryStatusLabel  = UILabel(frame: .zero)
            deliveryStatusLabel.font = cmSystemFontWithSize(15)
            deliveryStatusLabel.textColor = MAIN_BLUE
            deliveryStatusLabel.textAlignment = .right
            self.addSubview(deliveryStatusLabel)
            

            
            deliveryNoBottomLine = XYCommonViews.creatCommonSeperateLine(pointY: deliveryNumLabel.bottom - cmSizeFloat(1))
            self.addSubview(deliveryNoBottomLine)
            
            
            orderCreateTimeLabel  = UILabel(frame: .zero)
            orderCreateTimeLabel.font = cmSystemFontWithSize(13)
            orderCreateTimeLabel.textColor = MAIN_BLACK
            orderCreateTimeLabel.textAlignment = .left
            self.addSubview(orderCreateTimeLabel)
            
            leftTimeLabel = UILabel(frame: .zero)
            leftTimeLabel.font = cmSystemFontWithSize(13)
            leftTimeLabel.textColor = MAIN_BLUE
            leftTimeLabel.textAlignment = .right
            self.addSubview(leftTimeLabel)
            
            
            orderNumLabel = UILabel(frame: .zero)
            orderNumLabel.font = cmSystemFontWithSize(13)
            orderNumLabel.textColor = MAIN_BLACK
            orderNumLabel.textAlignment = .left
            self.addSubview(orderNumLabel)
            
            deliveryManLabel  = UILabel(frame: .zero)
            deliveryManLabel.font = cmSystemFontWithSize(13)
            deliveryManLabel.textColor = MAIN_BLACK
            deliveryManLabel.textAlignment = .left
            self.addSubview(deliveryManLabel)
            
            bottomeSeperateView = XYCommonViews.creatCustomSeperateLine(pointY: MerchantDeliveringOrderListTabCell.cellHeight - seperateViewHieght, lineWidth: SCREEN_WIDTH, lineHeight: seperateViewHieght)
            self.addSubview(bottomeSeperateView)
            
        }
        
    }
    
    
    //MARK: - model 设置
    func setModel(model:MerchantDeliveringOrderCellModel) {
        
        let deliveryStatusWidth = model.Status.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
        deliveryStatusLabel.frame = CGRect(x: SCREEN_WIDTH - toside - deliveryStatusWidth, y: 0, width: deliveryStatusWidth, height: deliveryNumHeight)
        deliveryStatusLabel.text = model.Status
        
        
        let deliveryNoStr = "#" + model.DeliveryNo
        deliveryNumLabel.frame = CGRect(x: toside, y: 0, width: SCREEN_WIDTH - toside*3 - deliveryStatusWidth, height: deliveryNumHeight)
        deliveryNumLabel.text = deliveryNoStr
        
        var showTimeType = ""
        if model.TimeShowType == 1 {
            showTimeType = "距预约 "
        }else if model.TimeShowType == 2 {
            showTimeType = "剩余"
        }
        let leftTimeStr = showTimeType + String(model.LeftSeconds/60) + "分钟"
        let leftTimeWidth = leftTimeStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        leftTimeLabel.frame = CGRect(x: SCREEN_WIDTH - toside - leftTimeWidth, y: deliveryNumLabel.bottom + textToDeliveryNumHeight, width: leftTimeWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        leftTimeLabel.text = leftTimeStr
        

        
        deliveryNoBottomLine.frame.origin.y = deliveryNumLabel.bottom - cmSizeFloat(1)
        
        orderCreateTimeLabel.frame = CGRect(x: toside, y: deliveryNumLabel.bottom + textToDeliveryNumHeight, width: SCREEN_WIDTH - toside*3 - leftTimeWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        orderCreateTimeLabel.text = "下单时间: " +   timeStrFormate(timeStr: model.OrderCreateDT)
        
        orderNumLabel.frame = CGRect(x: toside, y: orderCreateTimeLabel.bottom + textSpace, width: SCREEN_WIDTH - toside, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        orderNumLabel.text = "订单单号: " + model.UserOrderID
        
        deliveryManLabel.frame = CGRect(x: toside, y: orderNumLabel.bottom + textSpace, width: SCREEN_WIDTH - toside, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        deliveryManLabel.text = "配送人员: " + model.DStaffName
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

