//
//  MerchantDeliveriedOrderListTabCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/11.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantDeliveriedOrderListTabCell: UITableViewCell {
    static var cellHeight = cmSizeFloat(50+8*2+12*2) +  cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))*3  + cmSizeFloat(7)
    
    let deliveryNumHeight = cmSizeFloat(50)
    let toside = cmSizeFloat(20)
    let textSpace = cmSizeFloat(8)
    let textToDeliveryNumHeight = cmSizeFloat(12)
    let seperateViewHieght = cmSizeFloat(7)
    
    
    var deliveryNumLabel:UILabel!
    var deliveryStatusLabel:UILabel!
    var orderCreateTimeLabel:UILabel!
    var useTimeLabel:UILabel!
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
            
            useTimeLabel = UILabel(frame: .zero)
            useTimeLabel.font = cmSystemFontWithSize(13)
            useTimeLabel.textColor = MAIN_BLUE
            useTimeLabel.textAlignment = .right
            self.addSubview(useTimeLabel)
            
            
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
            
            bottomeSeperateView = XYCommonViews.creatCustomSeperateLine(pointY: MerchantDeliveriedOrderListTabCell.cellHeight - seperateViewHieght, lineWidth: SCREEN_WIDTH, lineHeight: seperateViewHieght)
            self.addSubview(bottomeSeperateView)
        }
        
    }
    
    
    //MARK: - model 设置
    func setModel(model:MerchantDeliveriedOrderCellModel) {
        
        let deliveryStatusWidth = model.ArriveStatus.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
        deliveryStatusLabel.frame = CGRect(x: SCREEN_WIDTH - toside - deliveryStatusWidth, y: 0, width: deliveryStatusWidth, height: deliveryNumHeight)
        deliveryStatusLabel.text = model.ArriveStatus
        
        
        let deliveryNoStr = "#" + model.DeliveryNo
        deliveryNumLabel.frame = CGRect(x: toside, y: 0, width: SCREEN_WIDTH - toside*3 - deliveryStatusWidth, height: deliveryNumHeight)
        deliveryNumLabel.text = deliveryNoStr
        
        
        deliveryNoBottomLine.frame.origin.y = deliveryNumLabel.bottom - cmSizeFloat(1)
        
        orderCreateTimeLabel.frame = CGRect(x: toside, y: deliveryNumLabel.bottom + textToDeliveryNumHeight, width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        orderCreateTimeLabel.text = "下单时间: " +   timeStrFormate(timeStr: model.OrderCreateDT)
        
        orderNumLabel.frame = CGRect(x: toside, y: orderCreateTimeLabel.bottom + textSpace, width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        orderNumLabel.text = "订单单号: " + model.UserOrderID
        
        let useTimeStr = String(model.DeliveryUseTime) + "分钟"
        let useTimeWidth = useTimeStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        useTimeLabel.frame = CGRect(x: SCREEN_WIDTH - toside - useTimeWidth, y: orderNumLabel.bottom + textSpace, width: useTimeWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        useTimeLabel.text = useTimeStr
        
        deliveryManLabel.frame = CGRect(x: toside, y: orderNumLabel.bottom + textSpace, width: SCREEN_WIDTH - toside*3 - useTimeWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
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
