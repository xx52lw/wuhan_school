//
//  OtherCancelReasonTabCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/31.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OtherReasonTabCell: UITableViewCell {
    
    
    static var cellHeight = cmSizeFloat(60)
    let toSide = cmSizeFloat(20)
    let seletcedImage = #imageLiteral(resourceName: "adressSelected")
    let unselectedImage = #imageLiteral(resourceName: "adressUnselected")
    let titleToTipsHeight = cmSizeFloat(7)
    
    let titleToTop = (cmSizeFloat(60-7) - cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)) - cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))/2
    
    var titleLabel:UILabel!
    var titleTipsLabel:UILabel!
    var selectedImageView:UIImageView!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            titleLabel = UILabel(frame: CGRect(x: toSide, y: titleToTop, width: SCREEN_WIDTH - toSide*2 - unselectedImage.size.width, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(15))))
            titleLabel.font = cmSystemFontWithSize(15)
            titleLabel.textColor = MAIN_BLACK2
            titleLabel.textAlignment = .left
            self.addSubview(titleLabel)
            
            
            titleTipsLabel = UILabel(frame: CGRect(x: toSide, y: titleLabel.bottom + titleToTipsHeight, width: SCREEN_WIDTH - toSide*2 - unselectedImage.size.width, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
            titleTipsLabel.font = cmSystemFontWithSize(13)
            titleTipsLabel.textColor = MAIN_GRAY
            titleTipsLabel.textAlignment = .left
            self.addSubview(titleTipsLabel)
            
            
            selectedImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH - unselectedImage.size.width - toSide, y: OtherReasonTabCell.cellHeight/2 - unselectedImage.size.height/2, width: unselectedImage.size.width, height: unselectedImage.size.height))
            self.addSubview(selectedImageView)
            
            
        }
        
    }
    

    
    
    //MARK: - 设置Model
    func setModel(model:OrderCancelOnlineModel){
        titleLabel.text = model.cancelReasonStr
        titleTipsLabel.text = model.cancelReasonTips
        if model.isSelected == true {
            selectedImageView.image = seletcedImage
        }else{
            selectedImageView.image = unselectedImage
        }
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
