//
//  ChooseDeliveryStatusTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/26.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class ChooseDeliveryStatusTabcell: UITableViewCell {
    
    
    
    static var cellHeight = cmSizeFloat(40)
    
    let toside = cmSizeFloat(20)

    
    var deliveryStatusLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            self.backgroundColor = .white
            
            deliveryStatusLabel  = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH - toside*2, height:ChooseDeliveryStatusTabcell.cellHeight))
            deliveryStatusLabel.font = cmSystemFontWithSize(14)
            deliveryStatusLabel.textColor = MAIN_BLACK
            deliveryStatusLabel.textAlignment = .left
            self.addSubview(deliveryStatusLabel)
            

            
            //self.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: ChooseDeliveryStatusTabcell.cellHeight-cmSizeFloat(1)))
        }
    }
    
    
    func setModel(statusStr:String) {
        
        deliveryStatusLabel.text = statusStr
        
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
