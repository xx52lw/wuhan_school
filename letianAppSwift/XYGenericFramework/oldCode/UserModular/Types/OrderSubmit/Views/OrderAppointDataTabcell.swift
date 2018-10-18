//
//  OrderAppointDataTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/4/2.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderAppointDataTabcell: UITableViewCell {
    
    
    
    static var cellHeight = cmSizeFloat(50)
    
    let toside = cmSizeFloat(10)
    
    var appointDateLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            self.backgroundColor = seperateLineColor
            
            appointDateLabel  = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH - toside*2, height:OrderAdressDormTabCell.cellHeight))
            appointDateLabel.font = cmSystemFontWithSize(14)
            appointDateLabel.textColor = MAIN_BLACK
            appointDateLabel.textAlignment = .left
            self.addSubview(appointDateLabel)
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
