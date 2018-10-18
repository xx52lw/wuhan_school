//
//  CancelOrderOnlineTabCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/30.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class ActCommonReasonTabCell: UITableViewCell {

    
    static var cellHeight = cmSizeFloat(50)
    let toSide = cmSizeFloat(20)
    let seletcedImage = #imageLiteral(resourceName: "adressSelected")
    let unselectedImage = #imageLiteral(resourceName: "adressUnselected")
    
    var titleLabel:UILabel!
    var selectedImageView:UIImageView!
    
    var indexRow:Int!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            titleLabel = UILabel(frame: CGRect(x: toSide, y: 0, width: SCREEN_WIDTH - toSide*2 - unselectedImage.size.width, height: ActCommonReasonTabCell.cellHeight))
            titleLabel.font = cmSystemFontWithSize(15)
            titleLabel.textColor = MAIN_BLACK2
            titleLabel.textAlignment = .left
            self.addSubview(titleLabel)
            
            selectedImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH - unselectedImage.size.width - toSide, y: ActCommonReasonTabCell.cellHeight/2 - unselectedImage.size.height/2, width: unselectedImage.size.width, height: unselectedImage.size.height))
            selectedImageView.image = unselectedImage
            self.addSubview(selectedImageView)
            
            self.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: ActCommonReasonTabCell.cellHeight - CGFloat(1)))

            
        }
        
    }
    


    
    //MARK: - 设置Model
    func setModel(model:OrderCancelOnlineModel){
        titleLabel.text = model.cancelReasonStr
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
