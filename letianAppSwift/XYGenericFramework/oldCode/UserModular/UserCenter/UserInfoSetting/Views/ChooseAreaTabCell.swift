//
//  ChooseAreaTabCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/29.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class ChooseAreaTabCell: UITableViewCell {

    
    static var cellHeight = cmSizeFloat(40)
    let toSide = cmSizeFloat(20)
    
    var titleLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            titleLabel = UILabel(frame: CGRect(x: toSide, y: 0, width: SCREEN_WIDTH - toSide*2, height: ChooseCityTabCell.cellHeight))
            titleLabel.font = cmSystemFontWithSize(15)
            titleLabel.textColor = MAIN_BLACK
            titleLabel.textAlignment = .left
            self.addSubview(titleLabel)
        }
        
    }
    
    
    
    //MARK: - 设置Model
    func setModel(model:ChooseAreaCellModel){
        titleLabel.text = model.areaName
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
