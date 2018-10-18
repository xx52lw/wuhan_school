//
//  OrderJFExchangeTabCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/23.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderJFExchangeTabCell: UITableViewCell {
    
    
    
    static var cellHeight = cmSizeFloat(50)
    
    let toside = cmSizeFloat(20)
    let selectJFImage = #imageLiteral(resourceName: "genderSelected")
    let unselectJFImage = #imageLiteral(resourceName: "genderUnselected")
    let selectedImageSize = cmSizeFloat(24)
    
    var dormBuildingNameLabel:UILabel!
    var selectedImageView:UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            self.backgroundColor = .white
            
            dormBuildingNameLabel  = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH - toside*2 - selectedImageSize, height:OrderAdressDormTabCell.cellHeight))
            dormBuildingNameLabel.font = cmSystemFontWithSize(14)
            dormBuildingNameLabel.textColor = MAIN_BLACK
            dormBuildingNameLabel.textAlignment = .left
            self.addSubview(dormBuildingNameLabel)
            
            selectedImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH  - selectedImageSize - toside, y: OrderDormBuildingTabCell.cellHeight/2 - selectedImageSize/2, width: selectedImageSize, height: selectedImageSize))
            self.addSubview(selectedImageView)
            
            
        }
    }
    
    
    func setModel(model:OrderSelectJFModel) {
        
        dormBuildingNameLabel.text = String(model.jfAmount)
        
        if model.isSelected == true {
            selectedImageView.image = selectJFImage
        }else{
            selectedImageView.image = unselectJFImage
            
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
