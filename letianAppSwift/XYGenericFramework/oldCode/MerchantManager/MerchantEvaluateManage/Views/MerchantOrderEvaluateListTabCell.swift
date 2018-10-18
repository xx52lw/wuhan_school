//
//  MerchantOrderEvaluateListTabCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantOrderEvaluateListTabCell: UITableViewCell {
    static var cellHeight = cmSizeFloat(50+8+12*2) +  cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))*2  + cmSizeFloat(7)
    
    let deliveryNumHeight = cmSizeFloat(50)
    let toside = cmSizeFloat(20)
    let textSpace = cmSizeFloat(8)
    let textToEvaluateNumHeight = cmSizeFloat(12)
    let seperateViewHieght = cmSizeFloat(7)
    
    var evaluateIDLabel:UILabel!
    var evaluateStatusLabel:UILabel!
    var evaluateTimeLabel:UILabel!
    var orderNumLabel:UILabel!
    
    
    var bottomeSeperateView:UIView!
    var evaluateNoBottomLine:UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            evaluateIDLabel = UILabel(frame: .zero)
            evaluateIDLabel.font = cmBoldSystemFontWithSize(18)
            evaluateIDLabel.textColor = MAIN_BLUE
            evaluateIDLabel.textAlignment = .left
            self.addSubview(evaluateIDLabel)
            
            
            evaluateStatusLabel = UILabel(frame: .zero)
            evaluateStatusLabel.font = cmSystemFontWithSize(15)
            evaluateStatusLabel.textColor = MAIN_RED
            evaluateStatusLabel.textAlignment = .right
            self.addSubview(evaluateStatusLabel)
            
            evaluateNoBottomLine = XYCommonViews.creatCommonSeperateLine(pointY: evaluateIDLabel.bottom - cmSizeFloat(1))
            self.addSubview(evaluateNoBottomLine)
            
            evaluateTimeLabel = UILabel(frame: .zero)
            evaluateTimeLabel.font = cmSystemFontWithSize(13)
            evaluateTimeLabel.textColor = MAIN_BLACK
            evaluateTimeLabel.textAlignment = .left
            self.addSubview(evaluateTimeLabel)
            
            
            orderNumLabel = UILabel(frame: .zero)
            orderNumLabel.font = cmSystemFontWithSize(13)
            orderNumLabel.textColor = MAIN_BLACK
            orderNumLabel.textAlignment = .left
            self.addSubview(orderNumLabel)
            
            
            bottomeSeperateView = XYCommonViews.creatCustomSeperateLine(pointY: MerchantOrderEvaluateListTabCell.cellHeight - seperateViewHieght, lineWidth: SCREEN_WIDTH, lineHeight: seperateViewHieght)
            self.addSubview(bottomeSeperateView)
            
        }
        
    }
    
    
    //MARK: - model 设置
    func setModel(model:MerchantOrderEvaluateCellModel) {
        
        
       var evaluateStatusStr = ""
        if model.IfShow == false {
            evaluateStatusStr = "已屏蔽"
            evaluateStatusLabel.textColor = MAIN_RED
        }else{
            if model.HasReplay == true{
                evaluateStatusStr = "已回复"
                evaluateStatusLabel.textColor = MAIN_BLACK
            }else{
                evaluateStatusStr = "未回复"
                evaluateStatusLabel.textColor = MAIN_RED
            }
        }
        
        
        let evaluateStatusStrWidth = evaluateStatusStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
        evaluateStatusLabel.frame = CGRect(x: SCREEN_WIDTH - toside - evaluateStatusStrWidth, y: 0, width: evaluateStatusStrWidth, height: deliveryNumHeight)
        evaluateStatusLabel.text = evaluateStatusStr
        
        let evaluateNoStr = "ID: " + String(model.UserInfID)
        evaluateIDLabel.frame = CGRect(x: toside, y: 0, width: SCREEN_WIDTH - toside*3 - evaluateStatusStrWidth, height: deliveryNumHeight)
        evaluateIDLabel.text = evaluateNoStr
        
        evaluateNoBottomLine.frame.origin.y = evaluateIDLabel.bottom - cmSizeFloat(1)
        
        evaluateTimeLabel.frame = CGRect(x: toside, y: evaluateIDLabel.bottom + textToEvaluateNumHeight, width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        evaluateTimeLabel.text = "评论时间: " + timeStrFormate(timeStr: model.CommentDT)

        
        orderNumLabel.frame = CGRect(x: toside, y: evaluateTimeLabel.bottom + textSpace, width: SCREEN_WIDTH - toside, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
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
