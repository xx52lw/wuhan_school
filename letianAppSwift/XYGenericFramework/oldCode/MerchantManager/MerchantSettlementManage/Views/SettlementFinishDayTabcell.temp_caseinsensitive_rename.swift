//
//  settlementFinishDayTabcell.swift
//  XYGenericFramework
//
//  Created by mouruiXY on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class SettlementFinishDayTabcell: UITableViewCell {
    
    static var cellHeight = cmSizeFloat(50)
    let toside = cmSizeFloat(20)
    
    var functionImageView:UIImageView!
    var titleLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            functionImageView = UIImageView(frame: .zero)
            self.addSubview(functionImageView)
            
            titleLabel  = UILabel(frame: .zero)
            titleLabel.font = cmSystemFontWithSize(14)
            titleLabel.textColor = MAIN_BLACK
            titleLabel.textAlignment = .left
            self.addSubview(titleLabel)
            
            
            self.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: SettlementHomeTabcell.cellHeight - cmSizeFloat(1)))
        }
    }
    
    
    
    
    func setModel(model:SettlementFinishDayListCellModel) {
        
 
        
        
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
