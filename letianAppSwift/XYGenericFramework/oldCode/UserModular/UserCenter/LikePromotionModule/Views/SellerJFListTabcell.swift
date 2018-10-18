//
//  SellerJFListTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class SellerJFListTabcell: UITableViewCell {
    
    static var cellHeight = cmSizeFloat(15*2+7*2+7) + cmSingleLineHeight(fontSize:cmSystemFontWithSize(15)) + cmSingleLineHeight(fontSize:cmSystemFontWithSize(13))*2
    
    let toTop = cmSizeFloat(15)
    let toside = cmSizeFloat(20)
    let textSpace = cmSizeFloat(7)
    
    
    var merchantNameLabel:UILabel!
    var deliveryInfoLabel:UILabel!
    var sellerJFLabel:UILabel!
    var seperateView:UIView!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            merchantNameLabel = UILabel(frame: CGRect(x: toside, y: toTop, width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(15))))
            merchantNameLabel.font = cmSystemFontWithSize(15)
            merchantNameLabel.textColor = MAIN_BLACK
            merchantNameLabel.textAlignment = .left
            self.addSubview(merchantNameLabel)
            
            deliveryInfoLabel = UILabel(frame: CGRect(x: toside, y: merchantNameLabel.bottom + textSpace, width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
            deliveryInfoLabel.font = cmSystemFontWithSize(13)
            deliveryInfoLabel.textColor = MAIN_BLACK2
            deliveryInfoLabel.textAlignment = .left
            self.addSubview(deliveryInfoLabel)
            
            sellerJFLabel = UILabel(frame: CGRect(x: toside, y: deliveryInfoLabel.bottom + textSpace, width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
            sellerJFLabel.font = cmSystemFontWithSize(13)
            sellerJFLabel.textColor = MAIN_BLACK2
            sellerJFLabel.textAlignment = .left
            self.addSubview(sellerJFLabel)
            
            seperateView = XYCommonViews.creatCustomSeperateLine(pointY: sellerJFLabel.bottom + toTop, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
            self.addSubview(seperateView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 设置Model
    func setModel(model:SellerJFListCellModel){
        merchantNameLabel.text = model.MerchantName
        deliveryInfoLabel.text = "起送价：¥" + moneyExchangeToString(moneyAmount: model.DeliveryLimit)  + "     " + "配送费：¥" + moneyExchangeToString(moneyAmount: model.DeliveryFee)
        sellerJFLabel.text = "商家积分：" + String(model.JFAmount) + "    (" + String(model.JFExchangeAmount) +  "积分兑换1元)"
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
