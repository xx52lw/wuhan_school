//
//  MineHomepageCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/6.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class MineHomepageCell: UITableViewCell {

    static var cellHeight = cmSizeFloat(50)
    
    let toside = cmSizeFloat(20)
    
    var cellImageView:UIImageView!
    var cellTitleLabel:UILabel!
    var seperateLine:UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            cellImageView = UIImageView(frame: .zero)
            self.addSubview(cellImageView)
            
            cellTitleLabel = UILabel(frame: .zero)
            cellTitleLabel.font = cmBoldSystemFontWithSize(15)
            cellTitleLabel.textColor = MAIN_BLACK
            cellTitleLabel.textAlignment = .left
            self.addSubview(cellTitleLabel)
            
            seperateLine = XYCommonViews.creatCustomSeperateLine(pointY: 0, lineWidth: SCREEN_WIDTH - toside*2, lineHeight: cmSizeFloat(1))
            seperateLine.frame.origin.x = toside
            self.addSubview(seperateLine)
        }
    }
    
    
    func setModel(model:Dictionary<String,UIImage>) {
        
        cellImageView.frame = CGRect(x: toside, y: MineHomepageCell.cellHeight/2 - model.values.first!.size.height/2, width: model.values.first!.size.width, height: model.values.first!.size.height)
        cellImageView.image = model.values.first!
        cellTitleLabel.frame = CGRect(x: cellImageView.right + toside, y: 0, width: SCREEN_WIDTH - model.values.first!.size.width - toside*3, height: MineHomepageCell.cellHeight)
        cellTitleLabel.text = model.keys.first!
        
        seperateLine.frame.origin.y = cellTitleLabel.bottom - cmSizeFloat(1)
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
