//
//  StaffManageListTabCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/24.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class StaffManageListTabCell: UITableViewCell {
    static var cellHeight = cmSizeFloat(40+1)
    
    let showMoreImage = #imageLiteral(resourceName: "sellerDetailShowMore")
    let toside = cmSizeFloat(20)

    var staffInfoLabel:UILabel!
    var showMoreBtn:UIButton!
    var cellModel:StaffManageListCellModel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            self.backgroundColor = .white
            
            let showMoreBtnWidth = showMoreImage.size.width + toside*2
            
            self.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: 0))
            
            staffInfoLabel  = UILabel(frame: CGRect(x: toside, y: cmSizeFloat(1), width: SCREEN_WIDTH - toside - showMoreBtnWidth, height:StaffManageListTabCell.cellHeight))
            staffInfoLabel.font = cmSystemFontWithSize(14)
            staffInfoLabel.textColor = MAIN_BLACK
            staffInfoLabel.textAlignment = .left
            self.addSubview(staffInfoLabel)
            
            
            showMoreBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH - showMoreBtnWidth, y: 0, width: showMoreBtnWidth, height: StaffManageListTabCell.cellHeight))
            showMoreBtn.setImage(showMoreImage, for: .normal)
            showMoreBtn.addTarget(self, action: #selector(showMoreBtnAct), for: .touchUpInside)
            self.addSubview(showMoreBtn)
            
        }
    }
    
    //MARK: - 修改配送员信息
    @objc func showMoreBtnAct(){
        let modifyStaffVC = StaffModifyVC()
        modifyStaffVC.staffModel = cellModel
        GetCurrentViewController()?.navigationController?.pushViewController(modifyStaffVC, animated: true)
    }
    
    
    func setModel(model:StaffManageListCellModel) {
        
        cellModel = model
        
        staffInfoLabel.text = "配送人员: " + model.StaffName + "  " + model.Phone
        
        if model.CanUse == true {
            staffInfoLabel.textColor = MAIN_BLACK
        }else{
            staffInfoLabel.textColor = MAIN_GRAY
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
