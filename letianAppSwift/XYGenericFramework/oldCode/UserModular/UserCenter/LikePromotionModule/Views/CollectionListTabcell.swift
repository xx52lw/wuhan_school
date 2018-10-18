//
//  CollectionListTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class CollectionListTabcell: UITableViewCell {

     static var cellHeight = cmSizeFloat(48+12*2+7)
    
    let toTop = cmSizeFloat(12)
    let toside = cmSizeFloat(20)
    let imageSize = cmSizeFloat(48)
    let textToImageWidth = cmSizeFloat(9)
    
    var sellerAvatarImageView:UIImageView!
    var sellerNameLabel:UILabel!
    var sellerInfoLabel:UILabel!
    var seperateView:UIView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            sellerAvatarImageView = UIImageView(frame: CGRect(x: toside, y: toTop, width: imageSize, height: imageSize))
            self.addSubview(sellerAvatarImageView)
            
            sellerNameLabel = UILabel(frame: CGRect(x: sellerAvatarImageView.right + textToImageWidth, y: toTop, width: SCREEN_WIDTH - (toside+sellerAvatarImageView.right + textToImageWidth), height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(15))))
            sellerNameLabel.font = cmBoldSystemFontWithSize(15)
            sellerNameLabel.textColor = MAIN_BLACK
            sellerNameLabel.textAlignment = .left
            self.addSubview(sellerNameLabel)
            
            sellerInfoLabel = UILabel(frame: CGRect(x: sellerNameLabel.left, y: sellerAvatarImageView.bottom - cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)) , width: SCREEN_WIDTH - (toside+sellerAvatarImageView.right + textToImageWidth), height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
            sellerInfoLabel.font = cmSystemFontWithSize(13)
            sellerInfoLabel.textColor = MAIN_BLACK2
            sellerInfoLabel.textAlignment = .left
            self.addSubview(sellerInfoLabel)
            
            seperateView = XYCommonViews.creatCustomSeperateLine(pointY: sellerAvatarImageView.bottom + toTop, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
            self.addSubview(seperateView)

            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 设置Model
    func setModel(model:CollectionListCellModel){
        
        if let imageUrl = URL(string:model.Logo){
            sellerAvatarImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeHolderImage"))
        }else{
            sellerAvatarImageView.image = #imageLiteral(resourceName: "placeHolderImage")
        }
        sellerNameLabel.text = model.MerchantName
        sellerInfoLabel.text = "起送价：¥" + moneyExchangeToString(moneyAmount: model.DeliveryLimit)  + "   " + "配送费：¥" + moneyExchangeToString(moneyAmount: model.DeliveryFee) 
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
