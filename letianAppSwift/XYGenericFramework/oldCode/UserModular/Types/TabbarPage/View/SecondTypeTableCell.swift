//
//  SecondTypeTableCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/12/7.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class SecondTypeTableCell: UITableViewCell {
    static var cellHeight = cmSizeFloat(40)

    let toside = cmSizeFloat(20)
    var titileLabel:UILabel!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            titileLabel = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH/2 - toside*2, height: FirstTypeTableCell.cellHeight))
            titileLabel.font = cmSystemFontWithSize(15)
            titileLabel.textColor = MAIN_BLACK
            titileLabel.textAlignment = .left
            self.addSubview(titileLabel)
        }
        
    }
    
    
    func setModel(model:FoodSecondTypeModel) {
        titileLabel.text = model.goodsSCatStr
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
