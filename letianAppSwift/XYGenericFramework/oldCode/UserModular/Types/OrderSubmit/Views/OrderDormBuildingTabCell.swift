//
//  OrderDormBuildingTabCell.swift
//  
//
//  Created by xiaoyi6409 on 2018/1/20.
//

import UIKit

class OrderDormBuildingTabCell: UITableViewCell {
    
    
    
    static var cellHeight = cmSizeFloat(50)
    
    let toside = cmSizeFloat(10)
    let selectBuildingImage = #imageLiteral(resourceName: "genderSelected")
    let unselectBuildingImage = #imageLiteral(resourceName: "genderUnselected")
    let selectedImageSize = cmSizeFloat(24)
    
    var dormBuildingNameLabel:UILabel!
    var selectedImageView:UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            self.backgroundColor = .white
            
            dormBuildingNameLabel  = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH/2 - toside*2 - selectedImageSize, height:OrderAdressDormTabCell.cellHeight))
            dormBuildingNameLabel.font = cmSystemFontWithSize(14)
            dormBuildingNameLabel.textColor = MAIN_BLACK
            dormBuildingNameLabel.textAlignment = .left
            self.addSubview(dormBuildingNameLabel)
            
            selectedImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH/2  - selectedImageSize - toside, y: OrderDormBuildingTabCell.cellHeight/2 - selectedImageSize/2, width: selectedImageSize, height: selectedImageSize))
            self.addSubview(selectedImageView)
            

        }
    }
    
    
    func setModel(model:OrderSchoolAdressModel) {
        
        dormBuildingNameLabel.text = model.SAreaName
        
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
