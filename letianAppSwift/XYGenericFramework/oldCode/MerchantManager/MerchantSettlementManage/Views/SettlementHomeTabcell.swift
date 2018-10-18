//
//  SettlementHomeTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class SettlementHomeTabcell: UITableViewCell {

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
    
    
    
    
    func setModel(model:SettlementHomeCellModel) {
        
        functionImageView.frame = CGRect(x: toside, y: SettlementHomeTabcell.cellHeight/2 - model.functionImage.size.height/2, width: model.functionImage.size.width, height: model.functionImage.size.height)
        functionImageView.image = model.functionImage
        
        
        titleLabel.frame = CGRect(x: functionImageView.right + toside, y: 0, width: SCREEN_WIDTH - functionImageView.right*2, height: SettlementHomeTabcell.cellHeight)
        titleLabel.text = model.functionStr
        
        
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
