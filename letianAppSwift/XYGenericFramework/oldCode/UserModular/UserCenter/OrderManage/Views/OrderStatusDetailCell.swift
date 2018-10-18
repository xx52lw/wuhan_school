//
//  OrderStatusDetailCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderStatusDetailCell: UITableViewCell {
    
    
    let subviewToTop = cmSizeFloat(15)
    let toSide = cmSizeFloat(20)
    let textToSubviewSide  = cmSizeFloat(10)
    let textSpace = cmSizeFloat(7)
    let textToSubviewTop  = cmSizeFloat(15)
    
    var subView:UIView!
    var titleLabel:UILabel!
    var statusDetailLabel:UILabel!
    var timeLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            subView = UIView(frame: CGRect(x: toSide, y: subviewToTop, width: SCREEN_WIDTH - toSide*2, height: 0))
            subView.clipsToBounds = true
            subView.layer.cornerRadius = cmSizeFloat(5)
            subView.layer.borderWidth = CGFloat(1)
            subView.layer.borderColor = MAIN_GRAY.cgColor
            self.addSubview(subView)
            
            
            timeLabel  = UILabel(frame: .zero)
            timeLabel.font = cmSystemFontWithSize(13)
            timeLabel.textColor = MAIN_GRAY
            timeLabel.textAlignment = .right
            subView.addSubview(timeLabel)
            
            
            titleLabel = UILabel(frame: .zero)
            titleLabel.font = cmSystemFontWithSize(15)
            titleLabel.textColor = MAIN_BLACK
            titleLabel.textAlignment = .left
            subView.addSubview(titleLabel)
            
            statusDetailLabel =  UILabel(frame: .zero)
            statusDetailLabel.font = cmSystemFontWithSize(13)
            statusDetailLabel.textColor = MAIN_BLACK
            statusDetailLabel.textAlignment = .left
            statusDetailLabel.numberOfLines = 0
            subView.addSubview(statusDetailLabel)

        }
        
    }
    
    
    
    //MARK: - 设置Model
    func setModel(model:StatusListModel){
        
        let timeStrWidth = model.HappenDT.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        timeLabel.frame = CGRect(x: subView.frame.size.width - textToSubviewSide - timeStrWidth , y: textToSubviewTop, width: timeStrWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)))
        timeLabel.text = model.HappenDT
        
        titleLabel.frame = CGRect(x: textToSubviewSide, y: textToSubviewTop, width: subView.frame.size.width - textToSubviewSide*3 - timeStrWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)))
        titleLabel.text = model.StatusDes
        
        let statusStrHeight = model.StatusDetail.stringHeight(subView.frame.size.width - textToSubviewSide*2, font: cmSystemFontWithSize(13))
        statusDetailLabel.frame = CGRect(x: textToSubviewSide, y: titleLabel.bottom + textSpace, width: subView.frame.size.width - textToSubviewSide*2, height: statusStrHeight)
        statusDetailLabel.text = model.StatusDetail
        
        
        subView.frame.size.height = textToSubviewTop*2 + statusStrHeight + cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)) + textSpace
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
