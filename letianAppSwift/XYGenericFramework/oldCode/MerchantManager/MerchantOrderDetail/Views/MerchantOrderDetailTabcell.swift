//
//  MerchantOrderDetailTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/23.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantOrderDetailTabcell: UITableViewCell {
    
    static var cellHeight = cmSizeFloat(10*2+7+1) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)) +  cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))
    
    let textToTopBottom = cmSizeFloat(10)
    let textSpaceHeight = cmSizeFloat(7)
    let toside = cmSizeFloat(20)
    
    var goodsNameLabel:UILabel!
    var goodsCountLabel:UILabel!
    var goodsPriceLabel:UILabel!
    var goodsOtherInfoLabel:UILabel!
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            goodsNameLabel =  UILabel(frame: .zero)
            goodsNameLabel.font = cmSystemFontWithSize(14)
            goodsNameLabel.textColor = MAIN_BLACK
            goodsNameLabel.textAlignment = .left
            self.addSubview(goodsNameLabel)
            
            goodsCountLabel =  UILabel(frame: .zero)
            goodsCountLabel.font = cmSystemFontWithSize(14)
            goodsCountLabel.textColor = MAIN_BLACK
            goodsCountLabel.textAlignment = .left
            self.addSubview(goodsCountLabel)
            
            goodsPriceLabel =  UILabel(frame: .zero)
            goodsPriceLabel.font = cmSystemFontWithSize(14)
            goodsPriceLabel.textColor = MAIN_BLACK
            goodsPriceLabel.textAlignment = .right
            self.addSubview(goodsPriceLabel)
            
            goodsOtherInfoLabel =  UILabel(frame: .zero)
            goodsOtherInfoLabel.font = cmSystemFontWithSize(12)
            goodsOtherInfoLabel.textColor = MAIN_GRAY
            goodsOtherInfoLabel.textAlignment = .left
            self.addSubview(goodsOtherInfoLabel)
            
            let seprateLine = XYCommonViews.creatCommonSeperateLine(pointY: OrderDetailGoodsCell.cellHeight)
            seprateLine.frame.origin.x = toside
            seprateLine.frame.size.width = SCREEN_WIDTH - toside*2
            self.addSubview(seprateLine)
        }
    }
    
    
    func setModel(model: MerchantOrderDetailCellModel) {
        if model.goodsOtherInfo.isEmpty {
            goodsPriceLabel.frame = CGRect(x: (SCREEN_WIDTH - toside) - (SCREEN_WIDTH - toside*2)/6, y: 0, width: (SCREEN_WIDTH - toside*2)/6, height: OrderDetailGoodsCell.cellHeight)
            goodsOtherInfoLabel.isHidden = true
            
        }else{
            goodsPriceLabel.frame = CGRect(x: (SCREEN_WIDTH - toside) - (SCREEN_WIDTH - toside*2)/6, y: textToTopBottom, width: (SCREEN_WIDTH - toside*2)/6, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)))
            goodsOtherInfoLabel.isHidden = false
            goodsOtherInfoLabel.frame = CGRect(x: toside, y: goodsPriceLabel.bottom + textSpaceHeight, width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)))
            goodsOtherInfoLabel.text = model.goodsOtherInfo
        }
        goodsPriceLabel.text = "¥" + moneyExchangeToString(moneyAmount: model.goodsPrice)
        
        
        goodsCountLabel.frame = CGRect(x: goodsPriceLabel.left - (SCREEN_WIDTH - toside*2)/8, y: goodsPriceLabel.top, width: (SCREEN_WIDTH - toside*2)/8, height: goodsPriceLabel.frame.size.height)
        goodsCountLabel.text = "x" + String(model.goodsCount)
        
        goodsNameLabel.frame = CGRect(x: toside, y: goodsPriceLabel.top, width: (SCREEN_WIDTH - toside*2)*5/6 - (SCREEN_WIDTH - toside*2)/8, height: goodsPriceLabel.frame.size.height)
        goodsNameLabel.text = model.goodsName
        
        
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
