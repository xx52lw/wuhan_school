//
//  GoodsPromotionTabCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/31.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class GoodsPromotionTabCell: UITableViewCell {

    static var cellHeight = cmSizeFloat(128+15*2+7)

    
    let toside = cmSizeFloat(10)
    let toTop = cmSizeFloat(15)
    let promotionWidth = cmSizeFloat(355)
    let promotionHeight = cmSizeFloat(128)
    
    let discountToLeft = cmSizeFloat(22)
    let discountToPromotionName = cmSizeFloat(18)
    let getDiscountBtnWidth = cmSizeFloat(58)
    let getDiscountBtnHeight = cmSizeFloat(26)
    let detailToNameHeight = cmSizeFloat(8)
    let dateToDetailHeight = cmSizeFloat(5)
    let goodsPromotionImage = #imageLiteral(resourceName: "goodsPromotion")

    
    
    var goodsPromotionImageView:UIImageView!
    var discountPriceLabel:UILabel!
    var promotionNameLabel:UILabel!
    var promotionDetailLabel:UILabel!
    var promotionDateLabel:UILabel!
    var getDiscountBtn:UIButton!
    var cellIndex:Int!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            let sperateLine = XYCommonViews.creatCustomSeperateLine(pointY: 0, lineWidth:SCREEN_WIDTH , lineHeight: cmSizeFloat(7))
            self.addSubview(sperateLine)
            
            goodsPromotionImageView = UIImageView(frame: CGRect(x: toside, y: sperateLine.bottom + toTop, width: promotionWidth, height: promotionHeight))
            goodsPromotionImageView.image = goodsPromotionImage
            goodsPromotionImageView.isUserInteractionEnabled = true
            self.addSubview(goodsPromotionImageView)
            
            
            discountPriceLabel =  UILabel(frame: CGRect(x: discountToLeft, y: promotionHeight/2 - cmSingleLineHeight(fontSize:cmSystemFontWithSize(23))/2, width: 0, height: cmSingleLineHeight(fontSize:cmSystemFontWithSize(23))))
            discountPriceLabel.font = cmSystemFontWithSize(23)
            discountPriceLabel.textColor = cmColorWithString(colorName: "cc0066")
            discountPriceLabel.textAlignment = .left
            goodsPromotionImageView.addSubview(discountPriceLabel)
            
            
            promotionNameLabel =  UILabel(frame: .zero)
            promotionNameLabel.font = cmBoldSystemFontWithSize(16)
            promotionNameLabel.textColor = MAIN_BLACK
            promotionNameLabel.textAlignment = .left
            goodsPromotionImageView.addSubview(promotionNameLabel)
            
            
            promotionDetailLabel =  UILabel(frame: .zero)
            promotionDetailLabel.font = cmSystemFontWithSize(13)
            promotionDetailLabel.textColor = MAIN_BLACK2
            promotionDetailLabel.textAlignment = .left
            goodsPromotionImageView.addSubview(promotionDetailLabel)
            
            
            promotionDateLabel = UILabel(frame: .zero)
            promotionDateLabel.font = cmSystemFontWithSize(13)
            promotionDateLabel.textColor = MAIN_BLACK2
            promotionDateLabel.textAlignment = .left
            goodsPromotionImageView.addSubview(promotionDateLabel)
            
            
            getDiscountBtn = UIButton(frame: CGRect(x: promotionWidth - discountToLeft - getDiscountBtnWidth, y: promotionHeight/2 - getDiscountBtnHeight/2, width: getDiscountBtnWidth, height: getDiscountBtnHeight))
            getDiscountBtn.backgroundColor = cmColorWithString(colorName: "cc0066")
            getDiscountBtn.setTitle("领取", for: .normal)
            getDiscountBtn.titleLabel?.font = cmSystemFontWithSize(14)
            getDiscountBtn.setTitleColor(.white, for: .normal)
            getDiscountBtn.layer.cornerRadius = getDiscountBtnHeight/2
            getDiscountBtn.addTarget(self, action: #selector(getDiscountBtnAct), for: .touchUpInside)
            getDiscountBtn.clipsToBounds = true
            goodsPromotionImageView.addSubview(getDiscountBtn)
            
        }
    }
    
    
    
    //MARK: - 设置Model
    func setModel(model:GoodsPromotionCellModel,index:Int){
        
        cellIndex = index
        
        let discountPriceStr = "¥" + model.discountPrice
        discountPriceLabel.frame.size.width = discountPriceStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(23)), font: cmSystemFontWithSize(23))
        discountPriceLabel.text = discountPriceStr
        
        
       let promotionTitleToTop = (promotionHeight - cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))*2 - detailToNameHeight - dateToDetailHeight - cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(16)))/2
        
        promotionNameLabel.frame = CGRect(x: discountPriceLabel.right + discountToPromotionName, y: promotionTitleToTop, width: model.promotionName.stringWidth(cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(16)), font: cmBoldSystemFontWithSize(16)), height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(16)))
        promotionNameLabel.text = model.promotionName
        
        promotionDetailLabel.frame = CGRect(x: discountPriceLabel.right + discountToPromotionName, y: promotionNameLabel.bottom + detailToNameHeight, width: promotionWidth - getDiscountBtnWidth - discountToLeft - discountPriceLabel.right - discountToPromotionName, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        promotionDetailLabel.text = model.promotionContent
        
        promotionDateLabel.frame = CGRect(x: discountPriceLabel.right + discountToPromotionName, y: promotionDetailLabel.bottom + dateToDetailHeight, width: model.promotionTime.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13)), height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        promotionDateLabel.text = model.promotionTime
        
        setGetDiscountUI(isGetDiscount: model.hasGetDiscount)
    }
    
    
    //MARK: - 获取优惠按钮响应
    @objc func getDiscountBtnAct() {
        if  let targetVC =   self.getViewControllerFromView() as? GoodsPromotionTableViewController {
            
             targetVC.service.getSellerPromotionRequest(target: targetVC, promotionID: targetVC.promotionModel.cellModelArr[(self.cellIndex)].promotionID, successAct: {
                DispatchQueue.main.async {
                    targetVC.promotionModel.cellModelArr[(self.cellIndex)].hasGetDiscount = true
                    if #available(iOS 11, *) {
                        targetVC.mainTableView.estimatedRowHeight = 0
                    }
                    let indexPath = IndexPath(row: self.cellIndex, section: 0)
                    targetVC.mainTableView.reloadRows(at: [indexPath], with: .none)
                }
            }, failureAct: {
                
            })

        }
    }
    
    //MARK: - 已领取的UI设置
    func setGetDiscountUI(isGetDiscount:Bool){
        if isGetDiscount == true{
            getDiscountBtn.backgroundColor = MAIN_GRAY
            getDiscountBtn.isEnabled = false
            getDiscountBtn.setTitle("已领取", for: .normal)
            discountPriceLabel.textColor = MAIN_GRAY
            promotionNameLabel.textColor = MAIN_GRAY
            promotionDetailLabel.textColor = MAIN_GRAY
            promotionDateLabel.textColor = MAIN_GRAY
        }else if isGetDiscount == false{
            getDiscountBtn.isEnabled = true
            getDiscountBtn.setTitle("领取", for: .normal)
            getDiscountBtn.backgroundColor = cmColorWithString(colorName: "cc0066")
            discountPriceLabel.textColor = cmColorWithString(colorName: "cc0066")
            promotionNameLabel.textColor = MAIN_BLACK
            promotionDetailLabel.textColor = MAIN_BLACK2
            promotionDateLabel.textColor = MAIN_BLACK2
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
