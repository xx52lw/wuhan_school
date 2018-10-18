//
//  SettlementFinishOrderTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class SettlementFinishOrderTabcell: UITableViewCell {

    static var cellHeight = cmSizeFloat(12*2+8+7) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(14))*2
    
    
    let textToTop = cmSizeFloat(12)
    let textSpace = cmSizeFloat(8)
    let toside = cmSizeFloat(20)

    
    var settlementStatusLabel:UILabel!
    var settlementWeekLabel:UILabel!
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
            
            settlementWeekLabel  = UILabel(frame: .zero)
            settlementWeekLabel.font = cmSystemFontWithSize(14)
            settlementWeekLabel.textColor = MAIN_BLACK
            settlementWeekLabel.textAlignment = .left
            self.addSubview(settlementWeekLabel)
            
            settlementAmountLabel  = UILabel(frame: .zero)
            settlementAmountLabel.font = cmSystemFontWithSize(14)
            settlementAmountLabel.textColor = MAIN_BLACK
            settlementAmountLabel.textAlignment = .left
            self.addSubview(settlementAmountLabel)
            
            seperateView = XYCommonViews.creatCustomSeperateLine(pointY: SettlementFinishOrderTabcell.cellHeight - cmSizeFloat(7), lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
            self.addSubview(seperateView)
        }
    }
    
    
     func setModel(model:SettlementFinishOrderListCellModel) {
        
        var settlementStatusStr = ""
        if model.HasJS == true {
            settlementStatusStr = "已结算"
            settlementStatusLabel.textColor = MAIN_BLACK
        }else{
            settlementStatusStr = "未结算"
            settlementStatusLabel.textColor = MAIN_RED
        }
        
        let settlementStatusStrWidth = settlementStatusStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
        
        settlementStatusLabel.frame = CGRect(x: SCREEN_WIDTH - toside - settlementStatusStrWidth, y: textToTop, width: settlementStatusStrWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)))
        settlementStatusLabel.text = settlementStatusStr
        
        settlementWeekLabel.frame = CGRect(x: toside, y: textToTop, width: SCREEN_WIDTH - toside*3 - settlementStatusStrWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)))
        
        
        var startStr = "20"
        for index in 0..<model.Start.count {
            startStr += model.Start[index..<index+1]
            if  (index+1)%2 == 0 && index != model.Start.count - 1{
                startStr += "/"
            }
        }
        var endStr = "20"
        for index in 0..<model.End.count {
            endStr += model.End[index..<index+1]
            if  (index+1)%2 == 0 && index != model.End.count - 1{
                endStr += "/"
            }
        }
        
        settlementWeekLabel.text = startStr + " - " + endStr
        
        settlementAmountLabel.frame = CGRect(x: toside, y: settlementWeekLabel.bottom + textSpace, width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)))
        settlementAmountLabel.text = "商家收入: ¥" + moneyExchangeToString(moneyAmount: model.Money)
        
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
