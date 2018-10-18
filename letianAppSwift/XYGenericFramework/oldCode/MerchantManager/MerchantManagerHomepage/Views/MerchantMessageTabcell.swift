//
//  MerchantMessageTabcell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/28.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantMessageTabcell: UITableViewCell {
    
    
    let toTop = cmSizeFloat(15)
    let toside = cmSizeFloat(20)
    let textSpace = cmSizeFloat(7)
    let btnSizeWidth = cmSizeFloat(44)
    let btnSizeHeight = cmSizeFloat(40)
    
    
    
    var messagePublisherLabel:UILabel!
    var messageContentLabel:UILabel!
    var pulisherTimeLabel:UILabel!
    var deleteBtn:UIButton!
    var seperateView:UIView!
    var seperateLine:UIView!
    
    var cellModel:MerchantMessageListCellModel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            messagePublisherLabel = UILabel(frame: CGRect(x: toside, y: toTop, width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(15))))
            messagePublisherLabel.font = cmSystemFontWithSize(15)
            messagePublisherLabel.textColor = MAIN_BLACK
            messagePublisherLabel.textAlignment = .left
            self.addSubview(messagePublisherLabel)
            
            messageContentLabel = UILabel(frame: .zero)
            messageContentLabel.font = cmSystemFontWithSize(14)
            messageContentLabel.textColor = MAIN_BLACK2
            messageContentLabel.textAlignment = .left
            messageContentLabel.numberOfLines = 0
            self.addSubview(messageContentLabel)
            
            pulisherTimeLabel = UILabel(frame: .zero)
            pulisherTimeLabel.font = cmSystemFontWithSize(13)
            pulisherTimeLabel.textColor = MAIN_GRAY
            pulisherTimeLabel.textAlignment = .left
            self.addSubview(pulisherTimeLabel)
            
            
            seperateLine = XYCommonViews.creatCommonSeperateLine(pointY: pulisherTimeLabel.bottom + textSpace)
            self.addSubview(seperateLine)
            
            deleteBtn = UIButton(frame: .zero)
            deleteBtn.setTitle("删除", for: .normal)
            deleteBtn.setTitleColor(MAIN_BLUE, for: .normal)
            deleteBtn.titleLabel?.font = cmSystemFontWithSize(14)
            deleteBtn.addTarget(self, action: #selector(deleteBtnAct), for: .touchUpInside)
            self.addSubview(deleteBtn)
            
            seperateView = XYCommonViews.creatCustomSeperateLine(pointY: deleteBtn.bottom, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
            self.addSubview(seperateView)
        }
        
    }
    
    //MARK: - 删除消息
    @objc func  deleteBtnAct() {
        if let currentVC = GetCurrentViewController() as? MerchantMessageVC {
            
            currentVC.service.deleteMerchantMessageRequest(messageID: cellModel.BroadcastReceiveID, successAct: {
                
                cmShowHUDToWindow(message: "删除成功")
                currentVC.service.getMerchantMessageListRequest(target: currentVC)
            }, failureAct: {
                
            })
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 设置Model
    func setModel(model:MerchantMessageListCellModel){
        
        cellModel = model
        
        messagePublisherLabel.text = "来自：" + model.CreatorName
        messageContentLabel.text = model.ContentInf
        pulisherTimeLabel.text = model.CreateDT
        
        
        
        let contentInfoHeight = model.ContentInf.stringHeight(SCREEN_WIDTH - toside*2, font: cmSystemFontWithSize(14))
        messageContentLabel.frame = CGRect(x: toside, y: messagePublisherLabel.bottom + textSpace, width: SCREEN_WIDTH - toside*2, height: contentInfoHeight)
        
        
        pulisherTimeLabel.frame = CGRect(x: toside, y: messageContentLabel.bottom + toTop, width: SCREEN_WIDTH - toside*3 - btnSizeWidth, height: btnSizeHeight)
        
        
        
        seperateLine.frame.origin.y = messageContentLabel.bottom + toTop - cmSizeFloat(1)
        
        deleteBtn.frame = CGRect(x: SCREEN_WIDTH - toside - btnSizeWidth, y: messageContentLabel.bottom + toTop, width: btnSizeWidth, height: btnSizeHeight)
        
        seperateView.frame.origin.y = deleteBtn.bottom
        
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
