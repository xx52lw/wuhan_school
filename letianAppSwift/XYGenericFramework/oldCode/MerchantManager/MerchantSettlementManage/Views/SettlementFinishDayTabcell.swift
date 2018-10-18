//
//  settlementFinishDayTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class SettlementFinishDayTabcell: UITableViewCell {
    
    static var cellHeight = cmSizeFloat(50)
    let toside = cmSizeFloat(20)
    
    var settlementStatusLabel:UILabel!
    var settlementDayLabel:UILabel!
    var settlementAmountLabel:UILabel!
    var seperateView:UIView!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {

            
            settlementStatusLabel  = UILabel(frame: .zero)
            settlementStatusLabel.font = cmSystemFontWithSize(14)
            settlementStatusLabel.textColor = MAIN_BLACK
            settlementStatusLabel.textAlignment = .left
            self.addSubview(settlementStatusLabel)
            
            settlementDayLabel  = UILabel(frame: .zero)
            settlementDayLabel.font = cmSystemFontWithSize(14)
            settlementDayLabel.textColor = MAIN_BLACK
            settlementDayLabel.textAlignment = .left
            self.addSubview(settlementDayLabel)
            
            settlementAmountLabel  = UILabel(frame: .zero)
            settlementAmountLabel.font = cmSystemFontWithSize(14)
            settlementAmountLabel.textColor = MAIN_BLACK
            settlementAmountLabel.textAlignment = .center
            self.addSubview(settlementAmountLabel)
            
            seperateView = XYCommonViews.creatCustomSeperateLine(pointY: SettlementFinishDayTabcell.cellHeight - cmSizeFloat(7), lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
            self.addSubview(seperateView)
        }
    }
    
    
    
    
    func setModel(model:SettlementFinishDayListCellModel) {
        
        var settlementStatusStr = ""
        if model.HasJS == true {
            settlementStatusStr = "已结算"
            settlementStatusLabel.textColor = MAIN_BLACK
        }else{
            settlementStatusStr = "未结算"
            settlementStatusLabel.textColor = MAIN_RED
        }
        
        let settlementStatusStrWidth = settlementStatusStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
        
        settlementStatusLabel.frame = CGRect(x: SCREEN_WIDTH - toside - settlementStatusStrWidth, y: 0, width: settlementStatusStrWidth, height: SettlementFinishDayTabcell.cellHeight)
        settlementStatusLabel.text = settlementStatusStr
        
        
        
        var dataStr = "20"
        for index in 0..<model.Day.count {
            dataStr += model.Day[index..<index+1]
            if  (index+1)%2 == 0 && index != model.Day.count - 1{
                dataStr += "/"
            }
        }
        
        let settlementDateStrWidth = dataStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
        settlementDayLabel.frame = CGRect(x: toside, y: 0, width: settlementDateStrWidth, height: SettlementFinishDayTabcell.cellHeight)

        
        settlementDayLabel.text = dataStr

        
        settlementAmountLabel.frame = CGRect(x: settlementDayLabel.right + toside, y: 0, width: SCREEN_WIDTH - toside*4 - settlementDateStrWidth - settlementStatusStrWidth, height: SettlementFinishDayTabcell.cellHeight)
        settlementAmountLabel.text = "¥" + moneyExchangeToString(moneyAmount: model.Money)
        
        
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
