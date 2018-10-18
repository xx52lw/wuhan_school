//
//  FirstTypeTableCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/12/7.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class FirstTypeTableCell: UITableViewCell {
    static var cellHeight = cmSizeFloat(40)
    
    let toside = cmSizeFloat(20)
    let showMoreImage = #imageLiteral(resourceName: "sellerDetailShowMore")
    
    
    var titileLabel:UILabel!
    var showMoreImageView:UIImageView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            titileLabel = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH/2 - showMoreImage.size.width - cmSizeFloat(10), height: FirstTypeTableCell.cellHeight))
            titileLabel.font = cmBoldSystemFontWithSize(15)
            titileLabel.textColor = MAIN_BLACK
            titileLabel.textAlignment = .left
            self.addSubview(titileLabel)
            
            showMoreImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH/2 - showMoreImage.size.width - cmSizeFloat(10), y: FirstTypeTableCell.cellHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width, height: showMoreImage.size.height))
            showMoreImageView.image = showMoreImage
            self.addSubview(showMoreImageView)
            
        }
        
    }
    
    
    func setModel(model:String) {
        titileLabel.text = model
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
