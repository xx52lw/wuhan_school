//
//  OrderAdressDormTabCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2018/1/20.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderAdressDormTabCell: UITableViewCell {

    
    
    static var cellHeight = cmSizeFloat(50)
    
    let toside = cmSizeFloat(10)
    
    var dormNameLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            self.backgroundColor = seperateLineColor
            
            dormNameLabel  = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH - toside*2, height:OrderAdressDormTabCell.cellHeight))
            dormNameLabel.font = cmSystemFontWithSize(14)
            dormNameLabel.textColor = MAIN_BLACK
            dormNameLabel.textAlignment = .left
            self.addSubview(dormNameLabel)
        }
    }
    
    
    func setModel(model:OrderRecieverAdressModel) {
        
        dormNameLabel.text = model.FAreaName
        
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
