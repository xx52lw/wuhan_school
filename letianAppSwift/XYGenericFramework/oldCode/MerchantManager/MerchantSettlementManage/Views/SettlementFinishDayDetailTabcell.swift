//
//  SettlementFinishDayDetailTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class SettlementFinishDayDetailTabcell: UITableViewCell {
    
    static var cellHeight = cmSizeFloat(12*2+8+7) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(14))*2
    
    
    let textToTop = cmSizeFloat(12)
    let textSpace = cmSizeFloat(8)
    let toside = cmSizeFloat(20)
    
    
    var orderNumLabel:UILabel!
    var amountLabel:UILabel!
    var seperateView:UIView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            orderNumLabel  = UILabel(frame: CGRect(x: toside, y: textToTop, width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(14))))
            orderNumLabel.font = cmSystemFontWithSize(14)
            orderNumLabel.textColor = MAIN_BLACK
            orderNumLabel.textAlignment = .left
            self.addSubview(orderNumLabel)
            
            amountLabel  = UILabel(frame: CGRect(x: toside, y: orderNumLabel.bottom + textSpace, width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(14))))
            amountLabel.font = cmSystemFontWithSize(14)
            amountLabel.textColor = MAIN_BLACK
            amountLabel.textAlignment = .left
            self.addSubview(amountLabel)
            

            
            seperateView = XYCommonViews.creatCustomSeperateLine(pointY: SettlementFinishOrderTabcell.cellHeight - cmSizeFloat(7), lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
            self.addSubview(seperateView)
        }
    }
    
    
    func setModel(model:SettlementFinishDayDetailListCellModel) {

        orderNumLabel.text = "订单单号: " + model.UserOrderID
        amountLabel.text = "商家收入: ¥" + moneyExchangeToString(moneyAmount: model.PayAmount)
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
