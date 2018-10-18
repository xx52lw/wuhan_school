//
//  OrderRecieverCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/18.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderRecieverCell: UITableViewCell {

    
    static var cellHeight = cmSizeFloat(50)
    
    let seletcedImage = #imageLiteral(resourceName: "adressSelected")
    let unselectedImage = #imageLiteral(resourceName: "adressUnselected")
    let btnSize = cmSizeFloat(44)
    
    var selectAdressBtn:UIButton!
    var userInfoLabel:UILabel!
    
    var indexRow:Int!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            selectAdressBtn = UIButton(frame: CGRect(x: 0, y: OrderRecieverCell.cellHeight/2 - btnSize/2, width: btnSize, height: btnSize))
            selectAdressBtn.setImage(unselectedImage, for: .normal)
            selectAdressBtn.setImage(seletcedImage, for: .selected)
            selectAdressBtn.addTarget(self, action: #selector(selectAdressBtnAct), for: .touchUpInside)
            self.addSubview(selectAdressBtn)
            
            
            userInfoLabel  = UILabel(frame: CGRect(x: selectAdressBtn.right, y: 0, width: SCREEN_WIDTH - btnSize - cmSizeFloat(15), height:OrderRecieverCell.cellHeight))
            userInfoLabel.font = cmSystemFontWithSize(15)
            userInfoLabel.textColor = MAIN_BLACK
            userInfoLabel.textAlignment = .left
            self.addSubview(userInfoLabel)

            
            self.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: OrderRecieverCell.cellHeight - cmSizeFloat(1)))
        }
    }
    
    //MARK: - model 设置
    func setModel(model:OrderRecieverSetModel,index:Int) {
        self.indexRow = index
        let spaceText = " "
        selectAdressBtn.isSelected = model.isselected
        var sexStr = "女士"
        if model.Sex == 1 {
            sexStr = "先生"
        }
        
        
        userInfoLabel.text = model.UserName + spaceText + sexStr + spaceText + model.PhoneNumber
    }
    
    //MARK: - 选择按钮响应
    @objc func selectAdressBtnAct() {
        if let currentVC = GetCurrentViewController() as? OrderReciverSetVC {
            for index in 0..<currentVC.recieverArr.count {
                if index == self.indexRow {
                    currentVC.recieverArr[index].isselected = true
                    let navVCCount = currentVC.navigationController!.viewControllers.count
                    if  let lastVC = currentVC.navigationController?.viewControllers[navVCCount - 2] as? OrderSubmitViewController {
                        lastVC.submitPrametersModel.selectedRecieverModel = currentVC.recieverArr[index]
                        lastVC.refreshUI()
                    }
                    
                }else{
                    currentVC.recieverArr[index].isselected = false
                }
            }
            currentVC.mainTabView.reloadData()
            currentVC.navigationController?.popViewController(animated: true)
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
