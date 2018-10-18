//
//  StaffSystemSettingTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/28.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class StaffSystemSettingTabcell: UITableViewCell {
    
    
    
    static var cellHeight = cmSizeFloat(50)
    
    let toside = cmSizeFloat(20)
    let showMoreImage = #imageLiteral(resourceName: "sellerDetailShowMore")
    
    var showMoreTextField:UITextField!
    var titleLabel:UILabel!
    var showMoreImageView:UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            self.backgroundColor = .white
            
            
            showMoreTextField = UITextField(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH    , height: StaffSystemSettingTabcell.cellHeight))
            showMoreTextField.font = cmSystemFontWithSize(14)
            showMoreTextField.textColor = MAIN_GRAY
            showMoreTextField.textAlignment = .right
            showMoreTextField.backgroundColor = .white
            showMoreTextField.isEnabled = false
            
            showMoreImageView = UIImageView(frame: CGRect(x: showMoreTextField.frame.size.width - toside*2 - showMoreImage.size.width, y: StaffSystemSettingTabcell.cellHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + toside*2, height: showMoreImage.size.height))
            showMoreImageView.image = showMoreImage
            showMoreImageView.contentMode = .scaleAspectFit
            showMoreTextField.rightView = showMoreImageView
            showMoreTextField.rightViewMode = .always
            
            titleLabel  = UILabel(frame: .zero)
            titleLabel.font = cmSystemFontWithSize(14)
            titleLabel.textColor = MAIN_BLACK
            titleLabel.textAlignment = .center
            showMoreTextField.leftView = titleLabel
            showMoreTextField.leftViewMode = .always
            
            
            self.addSubview(showMoreTextField)
            
            
            self.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: StaffSystemSettingTabcell.cellHeight-cmSizeFloat(1)))
        }
    }
    
    
    func setModel(titleStr:String) {
        
        titleLabel.text = titleStr
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: titleStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14)) + toside*2, height:StaffSystemSettingTabcell.cellHeight)
        
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
