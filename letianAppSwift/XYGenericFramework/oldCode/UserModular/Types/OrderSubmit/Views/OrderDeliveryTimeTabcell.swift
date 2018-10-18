//
//  OrderDeliveryTimeTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/4/2.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderDeliveryTimeTabcell: UITableViewCell {
    
    
    
    static var cellHeight = cmSizeFloat(50)
    
    let toside = cmSizeFloat(10)
    let selectBuildingImage = #imageLiteral(resourceName: "genderSelected")
    let unselectBuildingImage = #imageLiteral(resourceName: "genderUnselected")
    let selectedImageSize = cmSizeFloat(24)
    
    var deliveryTimeLabel:UILabel!
    var selectedImageView:UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            self.backgroundColor = .white
            
            deliveryTimeLabel  = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH/2 - toside*2 - selectedImageSize, height:OrderAdressDormTabCell.cellHeight))
            deliveryTimeLabel.font = cmSystemFontWithSize(14)
            deliveryTimeLabel.textColor = MAIN_BLACK
            deliveryTimeLabel.textAlignment = .left
            self.addSubview(deliveryTimeLabel)
            
            selectedImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH/2  - selectedImageSize - toside, y: OrderDormBuildingTabCell.cellHeight/2 - selectedImageSize/2, width: selectedImageSize, height: selectedImageSize))
            self.addSubview(selectedImageView)
            
            
        }
    }
    
    
    func setModel(model:DeliverChooseTypeModel) {
        
        deliveryTimeLabel.text = model.ExpressTime
        
        if model.isSelected == true {
            selectedImageView.image = selectBuildingImage
            
        }else{
            selectedImageView.image = unselectBuildingImage
            
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
