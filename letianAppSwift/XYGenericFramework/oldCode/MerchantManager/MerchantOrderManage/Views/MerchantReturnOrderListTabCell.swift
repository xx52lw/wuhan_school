//
//  MerchantReturnOrderListTabCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/11.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantReturnOrderListTabCell: UITableViewCell {
    static var cellHeight = cmSizeFloat(50+8*3+12*2) +  cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))*4  + cmSizeFloat(7)
    
    let deliveryNumHeight = cmSizeFloat(50)
    let toside = cmSizeFloat(20)
    let textSpace = cmSizeFloat(8)
    let textToDeliveryNumHeight = cmSizeFloat(12)
    let seperateViewHieght = cmSizeFloat(7)
    
    var deliveryNumLabel:UILabel!
    var returnTypeLabel:UILabel!
    var orderReturnTimeLabel:UILabel!
    var orderStatusLabel:UILabel!
    var orderNumLabel:UILabel!
    var leftActTimeLabel:UILabel!
    
    
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
            
            
            returnTypeLabel = UILabel(frame: .zero)
            returnTypeLabel.font = cmSystemFontWithSize(15)
            returnTypeLabel.textColor = MAIN_RED
            returnTypeLabel.textAlignment = .right
            self.addSubview(returnTypeLabel)
            
            deliveryNoBottomLine = XYCommonViews.creatCommonSeperateLine(pointY: deliveryNumLabel.bottom - cmSizeFloat(1))
            self.addSubview(deliveryNoBottomLine)
            
            orderReturnTimeLabel = UILabel(frame: .zero)
            orderReturnTimeLabel.font = cmSystemFontWithSize(13)
            orderReturnTimeLabel.textColor = MAIN_BLACK
            orderReturnTimeLabel.textAlignment = .left
            self.addSubview(orderReturnTimeLabel)
            
            orderStatusLabel  = UILabel(frame: .zero)
            orderStatusLabel.font = cmSystemFontWithSize(13)
            orderStatusLabel.textColor = MAIN_BLACK
            orderStatusLabel.textAlignment = .left
            self.addSubview(orderStatusLabel)

            
            orderNumLabel = UILabel(frame: .zero)
            orderNumLabel.font = cmSystemFontWithSize(13)
            orderNumLabel.textColor = MAIN_BLACK
            orderNumLabel.textAlignment = .left
            self.addSubview(orderNumLabel)
            
            
            leftActTimeLabel  = UILabel(frame: .zero)
            leftActTimeLabel.font = cmSystemFontWithSize(13)
            leftActTimeLabel.textColor = MAIN_BLACK
            leftActTimeLabel.textAlignment = .left
            self.addSubview(leftActTimeLabel)
            
            
            bottomeSeperateView = XYCommonViews.creatCustomSeperateLine(pointY: MerchantReturnOrderListTabCell.cellHeight - seperateViewHieght, lineWidth: SCREEN_WIDTH, lineHeight: seperateViewHieght)
            self.addSubview(bottomeSeperateView)
        }
        
    }
    
    
    //MARK: - model 设置
    func setModel(model:MerchantReturnOrderCellModel) {
        
        let returnTypeWidth = model.TDStatus.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
        returnTypeLabel.frame = CGRect(x: SCREEN_WIDTH - toside - returnTypeWidth, y: 0, width: returnTypeWidth, height: deliveryNumHeight)
        returnTypeLabel.text = model.TDStatus
        
        let deliveryNoStr = "#" + model.DeliveryNo
        deliveryNumLabel.frame = CGRect(x: toside, y: 0, width: SCREEN_WIDTH - toside*3 - returnTypeWidth, height: deliveryNumHeight)
        deliveryNumLabel.text = deliveryNoStr
        
        deliveryNoBottomLine.frame.origin.y = deliveryNumLabel.bottom - cmSizeFloat(1)
        
        orderReturnTimeLabel.frame = CGRect(x: toside, y: deliveryNumLabel.bottom + textToDeliveryNumHeight, width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        orderReturnTimeLabel.text = "退单时间: " + timeStrFormate(timeStr: model.TDDT)
        
        orderStatusLabel.frame = CGRect(x: toside, y: orderReturnTimeLabel.bottom + textSpace, width: SCREEN_WIDTH - toside, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        orderStatusLabel.text = "订单状态: " + model.OrderStatus
        
        
        
        orderNumLabel.frame = CGRect(x: toside, y: orderStatusLabel.bottom + textSpace, width: SCREEN_WIDTH - toside, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        orderNumLabel.text = "订单单号: " + model.UserOrderID
        
        leftActTimeLabel.frame = CGRect(x: toside, y: orderNumLabel.bottom + textSpace, width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        
        let leftActTimeStr = "剩余时间: " +   model.LeftTimeDes
        
        let attributeStrRange:NSRange = NSMakeRange(5, leftActTimeStr.count - 5)
        let attributeStr = NSMutableAttributedString(string: leftActTimeStr)
        attributeStr.addAttribute(NSAttributedStringKey.foregroundColor, value: MAIN_RED, range: attributeStrRange)
        leftActTimeLabel.attributedText = attributeStr
        
        
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
