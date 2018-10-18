//
//  AdressManageTabCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/17.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class AdressManageTabCell: UITableViewCell {

        static var cellHeight = cmSizeFloat(15*2+10) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)) +  cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))
    
    let seletcedImage = #imageLiteral(resourceName: "adressSelected")
    let unselectedImage = #imageLiteral(resourceName: "adressUnselected")
    let btnSize = cmSizeFloat(44)
    let textToTop = cmSizeFloat(15)
    let textSpace = cmSizeFloat(10)
    
    var selectAdressBtn:UIButton!
    var editeAdressBtn:UIButton!
    var userInfoLabel:UILabel!
    var userAdressLabel:UILabel!
    
    var indexRow:Int!
    var cellModel:AdressManageCellModel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            selectAdressBtn = UIButton(frame: CGRect(x: 0, y: AdressManageTabCell.cellHeight/2 - btnSize/2, width: btnSize, height: btnSize))
            selectAdressBtn.setImage(unselectedImage, for: .normal)
            selectAdressBtn.setImage(seletcedImage, for: .selected)
            selectAdressBtn.addTarget(self, action: #selector(selectAdressBtnAct), for: .touchUpInside)
            self.addSubview(selectAdressBtn)
            
            
            editeAdressBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH - btnSize, y: AdressManageTabCell.cellHeight/2 - btnSize/2, width: btnSize, height: btnSize))
            editeAdressBtn.setTitle("修改", for: .normal)
            editeAdressBtn.setTitleColor(MAIN_BLACK2, for: .normal)
            editeAdressBtn.titleLabel?.font = cmSystemFontWithSize(13)
            editeAdressBtn.addTarget(self, action: #selector(editeAdressBtnAct), for: .touchUpInside)
            self.addSubview(editeAdressBtn)
            
            
            userInfoLabel  = UILabel(frame: CGRect(x: selectAdressBtn.right, y: textToTop, width: SCREEN_WIDTH - btnSize*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(15))))
            userInfoLabel.font = cmSystemFontWithSize(15)
            userInfoLabel.textColor = MAIN_BLACK
            userInfoLabel.textAlignment = .left
            self.addSubview(userInfoLabel)
            
            
            userAdressLabel = UILabel(frame: .zero)
            userAdressLabel.font = cmSystemFontWithSize(13)
            userAdressLabel.textColor = MAIN_GRAY
            userAdressLabel.textAlignment = .left
            userAdressLabel.numberOfLines = 2
            self.addSubview(userAdressLabel)

            self.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: AdressManageTabCell.cellHeight - cmSizeFloat(1)))
        }
    }
    
    //MARK: - model 设置
    func setModel(model:AdressManageCellModel,index:Int) {
        cellModel = model
        self.indexRow = index
        let spaceText = " "
        selectAdressBtn.isSelected = model.isselected
        let userAdressInfoHeight = model.userAdress.stringHeight(SCREEN_WIDTH - btnSize*2, font: cmSystemFontWithSize(13))
        userAdressLabel.frame = CGRect(x: selectAdressBtn.right, y: userInfoLabel.bottom + textSpace, width: SCREEN_WIDTH - btnSize*2, height: userAdressInfoHeight)
        userAdressLabel.text = model.userAdress
        
        userInfoLabel.text = model.userName + spaceText + cmGetGenderStr(gender: model.userGender)  + spaceText + model.ueserTel
    }
    
    //MARK: - 选择按钮响应
    @objc func selectAdressBtnAct() {
        if let currentVC = GetCurrentViewController() as? DeliveryAdressManagerVC {
            for index in 0..<currentVC.adressManagerModel.adressCellModelArr.count {
                if index == self.indexRow {
                    currentVC.adressManagerModel.adressCellModelArr[index].isselected = true
                }else{
                   currentVC.adressManagerModel.adressCellModelArr[index].isselected = false
                }
            }
            currentVC.mainTabView.reloadData()
        }
    }
    
    //MARK: - 编辑按钮响应
    @objc func editeAdressBtnAct() {
        let editeAdressVC = AddNewAdressVC()
        editeAdressVC.submitModel = cellModel
        GetCurrentViewController()?.navigationController?.pushViewController(editeAdressVC, animated: true)
        
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
