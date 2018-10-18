//
//  RankDiscountTableViewCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/9.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class RankDiscountTableViewCell: UITableViewCell {

    static var RankDiscountCellHeight = cmSizeFloat(30+40+26+21) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))*2 + cmSingleLineHeight(fontSize: cmSystemFontWithSize(16))
    
    let imageSize = cmSizeFloat(100)
    let rankLabelWidth = cmSizeFloat(24)
    let rankLabelHeight = cmSizeFloat(18)
    let toTopBottom = cmSizeFloat(15)
    let toSide = cmSizeFloat(15)
    let lineHeight = cmSizeFloat(10)
    let toImageWidth = cmSizeFloat(10)
    let discountDetailHeight = cmSizeFloat(21)
    let buyNowBtnHeight = cmSizeFloat(26)
    let buyNowStr = "来一份"
    let soldOutStr = "已售完"
    
    var cellImageView:UIImageView!
    var rankLabel:UILabel!
    var goodsNameLabel:UILabel!
    var goodSaleInfoLabel:UILabel!
    var sellerInfoLabel:UILabel!
    var discountDetailLabel:UILabel!
    //货币符号label
    var currencySymbolLabel:UILabel!
    var discountPriceLabel:UILabel!
    var costPriceLabel:UILabel!
    var buyNowBtn:UIButton!
    var cellModel:HotestRankCellModel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            let wordWidth = SCREEN_WIDTH - imageSize + toSide - toImageWidth - toSide
            
            cellImageView = UIImageView(frame: CGRect(x: toSide, y: toTopBottom, width: imageSize, height: imageSize))
            self.addSubview(cellImageView)
            
            
            rankLabel = UILabel(frame: CGRect(x: toSide, y: toTopBottom, width: rankLabelWidth, height: rankLabelHeight))
            rankLabel.font = cmSystemFontWithSize(12)
            rankLabel.textColor = MAIN_WHITE
            rankLabel.textAlignment = .center
            rankLabel.backgroundColor = MAIN_RED
            //进行弧度设置
            let maskPath = UIBezierPath(roundedRect: rankLabel.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.bottomRight.rawValue) | UInt8(UIRectCorner.topRight.rawValue))), cornerRadii: CGSize(width: cmSizeFloat(4), height: cmSizeFloat(4)))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = rankLabel.bounds
            maskLayer.path = maskPath.cgPath
            rankLabel.layer.mask = maskLayer
            self.addSubview(rankLabel)
            
            goodsNameLabel = UILabel(frame: CGRect(x: cellImageView.right + toImageWidth, y: toTopBottom, width:wordWidth , height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(16))))
            goodsNameLabel.font = cmSystemFontWithSize(16)
            goodsNameLabel.textColor = MAIN_BLACK
            goodsNameLabel.textAlignment = .left
            self.addSubview(goodsNameLabel)
            
            goodSaleInfoLabel = UILabel(frame: CGRect(x: cellImageView.right + toImageWidth, y: goodsNameLabel.bottom + lineHeight, width:wordWidth , height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
            goodSaleInfoLabel.font = cmSystemFontWithSize(12)
            goodSaleInfoLabel.textColor = MAIN_GRAY
            goodSaleInfoLabel.textAlignment = .left
            self.addSubview(goodSaleInfoLabel)
            
            sellerInfoLabel = UILabel(frame: CGRect(x: cellImageView.right + toImageWidth, y: goodSaleInfoLabel.bottom + lineHeight, width:wordWidth , height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
            sellerInfoLabel.font = cmSystemFontWithSize(12)
            sellerInfoLabel.textColor = MAIN_GRAY
            sellerInfoLabel.textAlignment = .left
            self.addSubview(sellerInfoLabel)
            
            
            discountDetailLabel = UILabel(frame: .zero)
            discountDetailLabel.font = cmSystemFontWithSize(10)
            discountDetailLabel.textColor = MAIN_RED
            discountDetailLabel.textAlignment = .center
            discountDetailLabel.layer.borderColor = MAIN_RED.cgColor
            discountDetailLabel.layer.borderWidth = 1
            discountDetailLabel.layer.cornerRadius = cmSizeFloat(1.5)
            discountDetailLabel.clipsToBounds = true
            self.addSubview(discountDetailLabel)
            
            buyNowBtn = UIButton(frame: .zero)
            buyNowBtn.setTitle(soldOutStr, for: .normal)
            buyNowBtn.setTitleColor(MAIN_GRAY, for: .normal)
            buyNowBtn.titleLabel?.font = cmSystemFontWithSize(14)
            buyNowBtn.addTarget(self, action: #selector(buyNowBtnAct), for: .touchUpInside)
            self.addSubview(buyNowBtn)
            
            
            currencySymbolLabel = UILabel(frame: .zero)
            currencySymbolLabel.font = cmSystemFontWithSize(12)
            currencySymbolLabel.textColor = MAIN_RED
            currencySymbolLabel.textAlignment = .left
            currencySymbolLabel.text = "¥"
            self.addSubview(currencySymbolLabel)
            
            
            discountPriceLabel = UILabel(frame: .zero)
            discountPriceLabel.font = cmBoldSystemFontWithSize(17)
            discountPriceLabel.textColor = MAIN_RED
            discountPriceLabel.textAlignment = .left
            self.addSubview(discountPriceLabel)
            
            costPriceLabel = UILabel(frame: .zero)
            costPriceLabel.font = cmSystemFontWithSize(12)
            costPriceLabel.textColor = MAIN_GRAY
            costPriceLabel.textAlignment = .left
            
            self.addSubview(costPriceLabel)
            
            let  seperateLine = XYCommonViews.creatCommonSeperateLine(pointY: RankDiscountTableViewCell.RankDiscountCellHeight - CGFloat(1))
            self.addSubview(seperateLine)
        }
    }
    
    func setModel(model:HotestRankCellModel){
        
        cellModel = model
        if let imageUrl = URL(string:model.imageUrl){
            cellImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeHolderImage"))
        }else{
            cellImageView.image = #imageLiteral(resourceName: "placeHolderImage")
        }
        
        goodsNameLabel.text = model.goodsName
        goodSaleInfoLabel.text = model.goodsInfoStr
        sellerInfoLabel.text = model.sellerName
        rankLabel.text = model.rankStr
        
        let discountDetailStrWidth = model.discountDetailStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(10)), font: cmSystemFontWithSize(10))
        discountDetailLabel.frame = CGRect(x: cellImageView.right + toImageWidth, y: sellerInfoLabel.bottom + lineHeight, width:discountDetailStrWidth+cmSizeFloat(6) , height: discountDetailHeight)
        discountDetailLabel.text = model.discountDetailStr
        
        let btnWidth = soldOutStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
        buyNowBtn.frame = CGRect(x: SCREEN_WIDTH - btnWidth - cmSizeFloat(15) - toSide, y: discountDetailLabel.bottom + lineHeight, width:btnWidth+cmSizeFloat(15) , height: buyNowBtnHeight)
        
        if model.isSoldOut == true {
            buyNowBtn.setTitle(soldOutStr, for: .normal)
            buyNowBtn.setTitleColor(MAIN_GRAY, for: .normal)
            buyNowBtn.titleLabel?.font = cmSystemFontWithSize(14)
            buyNowBtn.backgroundColor = .clear
            buyNowBtn.isEnabled = false
        }else{
            buyNowBtn.setTitle(buyNowStr, for: .normal)
            buyNowBtn.setTitleColor(cmColorWithString(colorName: "A52A2A"), for: .normal)
            buyNowBtn.titleLabel?.font = cmBoldSystemFontWithSize(14)
            buyNowBtn.layer.borderWidth = cmSizeFloat(2)
            buyNowBtn.layer.cornerRadius = cmSizeFloat(2)
            buyNowBtn.layer.borderColor = cmColorWithString(colorName: "A52A2A").cgColor
            buyNowBtn.clipsToBounds = true
            buyNowBtn.isEnabled = true
        }
        
        
        let currencySymbolLabelWidth = "¥".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)), font: cmSystemFontWithSize(12))
        currencySymbolLabel.frame = CGRect(x: cellImageView.right + toImageWidth, y: discountDetailLabel.bottom + lineHeight, width:currencySymbolLabelWidth , height: buyNowBtnHeight)
        
        let discountPriceStr = moneyExchangeToString(moneyAmount: model.discountPriceStr)
        let discountPriceWidth = discountPriceStr.stringWidth(cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(17)), font: cmBoldSystemFontWithSize(17))
        discountPriceLabel.frame = CGRect(x: currencySymbolLabel.right, y: discountDetailLabel.bottom + lineHeight, width:discountPriceWidth , height: buyNowBtnHeight)
        discountPriceLabel.text = discountPriceStr
        
        
        costPriceLabel.frame = CGRect(x: discountPriceLabel.right + cmSizeFloat(7), y: discountDetailLabel.bottom + lineHeight, width:buyNowBtn.left -  discountPriceLabel.right, height: buyNowBtnHeight)
        //添加中划线
        let attributes = [NSAttributedStringKey.font:cmSystemFontWithSize(12),NSAttributedStringKey.foregroundColor:MAIN_GRAY,NSAttributedStringKey.strikethroughStyle:NSNumber.init(value:1)]
        costPriceLabel.attributedText = NSAttributedString.init(string: "¥" + moneyExchangeToString(moneyAmount: model.costPriceStr), attributes: attributes)
        
        
    }
    
    
    
    //立即购买按钮响应
    @objc func buyNowBtnAct(){
        let sellerVC = SellerDetailPageVC()
        sellerVC.merchantID = cellModel.merchantID
        GetCurrentViewController()?.navigationController?.pushViewController(sellerVC, animated: true)
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
