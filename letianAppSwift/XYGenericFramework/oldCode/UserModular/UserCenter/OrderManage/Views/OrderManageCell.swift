//
//  OrderManageCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/6.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SDWebImage
class OrderManageCell: UITableViewCell {

    static var cellHeight = cmSizeFloat(15*2 + 28 + 10*3)+cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(14)) +  cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))*2  + cmSizeFloat(7)
    
    let avatarSize = cmSizeFloat(60)
    let toTop = cmSizeFloat(15)
    let toSide = cmSizeFloat(15)
    let actBtnWidth = cmSizeFloat(64)
    let actBtnHeight = cmSizeFloat(28)
    let wordSpaceHeight = cmSizeFloat(10)
    let wordToAvatarWidth = cmSizeFloat(10)
    let seperateLineHeight = cmSizeFloat(7)
    
    var avatarImageView:UIImageView!
    var sellerNameLabel:UILabel!
    var orderTimeLabel:UILabel!
    var totalGoodsCountLabel:UILabel!
    var totalMoneyLabel:UILabel!
    var orderStatusLabel:UILabel!
    var orderActionLeftBtn:UIButton!
    var orderActionRightBtn:UIButton!
    var popView:XYNoDetailTipsAlertView!
    
    var cellModel:OrderManageCellModel!
    var orderPayService:OrderPayService = OrderPayService()

    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            avatarImageView = UIImageView(frame: CGRect(x: toSide, y: toTop, width: avatarSize, height: avatarSize))
            avatarImageView.layer.cornerRadius = avatarSize/2
            self.addSubview(avatarImageView)
            
            sellerNameLabel = UILabel(frame: .zero)
            sellerNameLabel.font = cmBoldSystemFontWithSize(14)
            sellerNameLabel.textColor = MAIN_BLACK
            sellerNameLabel.textAlignment = .left
            self.addSubview(sellerNameLabel)
            
            orderTimeLabel = UILabel(frame: .zero)
            orderTimeLabel.font = cmSystemFontWithSize(12)
            orderTimeLabel.textColor = MAIN_GRAY
            orderTimeLabel.textAlignment = .left
            self.addSubview(orderTimeLabel)
            
            totalGoodsCountLabel = UILabel(frame: .zero)
            totalGoodsCountLabel.font = cmSystemFontWithSize(12)
            totalGoodsCountLabel.textColor = MAIN_GRAY
            totalGoodsCountLabel.textAlignment = .left
            self.addSubview(totalGoodsCountLabel)
            
            totalMoneyLabel = UILabel(frame: .zero)
            totalMoneyLabel.font = cmSystemFontWithSize(13)
            totalMoneyLabel.textColor = MAIN_BLACK
            totalMoneyLabel.textAlignment = .left
            self.addSubview(totalMoneyLabel)
            
            
            orderStatusLabel = UILabel(frame: .zero)
            orderStatusLabel.font = cmSystemFontWithSize(13)
            orderStatusLabel.textColor = MAIN_BLACK
            orderStatusLabel.textAlignment = .left
            self.addSubview(orderStatusLabel)
            
            
            orderActionRightBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH - toSide - actBtnWidth, y: OrderManageCell.cellHeight - toTop - actBtnHeight - seperateLineHeight, width: actBtnWidth, height: actBtnHeight))
            orderActionRightBtn.layer.cornerRadius = cmSizeFloat(3)
            orderActionRightBtn.layer.borderColor = MAIN_BLUE.cgColor
            orderActionRightBtn.layer.borderWidth = CGFloat(1)
            orderActionRightBtn.setTitleColor(MAIN_BLACK2, for: .normal)
            orderActionRightBtn.addTarget(self, action: #selector(orderActionRightBtnAct), for: .touchUpInside)
            orderActionRightBtn.titleLabel?.font = cmSystemFontWithSize(13)
            self.addSubview(orderActionRightBtn)
            
            orderActionLeftBtn = UIButton(frame: CGRect(x: orderActionRightBtn.left - cmSizeFloat(15) - actBtnWidth, y: orderActionRightBtn.top, width: actBtnWidth, height: actBtnHeight))
            orderActionLeftBtn.layer.cornerRadius = cmSizeFloat(3)
            orderActionLeftBtn.layer.borderColor = MAIN_BLUE.cgColor
            orderActionLeftBtn.layer.borderWidth = CGFloat(1)
            orderActionLeftBtn.setTitleColor(MAIN_BLACK2, for: .normal)
             orderActionLeftBtn.addTarget(self, action: #selector(orderActionLeftBtnAct), for: .touchUpInside)
            orderActionLeftBtn.titleLabel?.font = cmSystemFontWithSize(13)
            self.addSubview(orderActionLeftBtn)
            
            
            let seperateLine = XYCommonViews.creatCustomSeperateLine(pointY:OrderManageCell.cellHeight-seperateLineHeight,lineWidth:SCREEN_WIDTH,lineHeight:seperateLineHeight)
            self.addSubview(seperateLine)

        }
    }
    
    //MARK: - model 设置
    func setModel(model:OrderManageCellModel) {
        self.cellModel = model
        
        if let imageUrl = URL(string:model.sellerAvatarUrl){
            avatarImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeHolderImage"))
        }else{
            avatarImageView.image  = #imageLiteral(resourceName: "placeHolderImage")
        }
        
        let orderStatusLabelWidth = model.statusStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        orderStatusLabel.frame = CGRect(x:SCREEN_WIDTH - toSide - orderStatusLabelWidth , y: toTop, width: orderStatusLabelWidth, height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(14)))
        orderStatusLabel.text = model.statusStr
        
        sellerNameLabel.frame = CGRect(x:avatarImageView.right +  wordToAvatarWidth, y: toTop, width: SCREEN_WIDTH - avatarImageView.right -  wordToAvatarWidth - orderStatusLabelWidth - toSide*2 , height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(14)))
        sellerNameLabel.text = model.sellerName

        
        orderTimeLabel.frame = CGRect(x:avatarImageView.right +  wordToAvatarWidth, y: sellerNameLabel.bottom + wordSpaceHeight, width: SCREEN_WIDTH - avatarImageView.right -  wordToAvatarWidth - toSide , height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)))
        orderTimeLabel.text = model.orderTime
        
        let totalMoneyStr = "¥" +  moneyExchangeToString(moneyAmount: model.totalMoney)
        let totalMoneyWidth = totalMoneyStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        totalGoodsCountLabel.frame = CGRect(x:avatarImageView.right +  wordToAvatarWidth, y: orderTimeLabel.bottom + wordSpaceHeight, width: SCREEN_WIDTH - avatarImageView.right -  wordToAvatarWidth - totalMoneyWidth - toSide*2 , height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        totalGoodsCountLabel.text = model.totalGoods
        
        
        totalMoneyLabel.frame = CGRect(x:SCREEN_WIDTH - toSide - totalMoneyWidth, y: orderTimeLabel.bottom + wordSpaceHeight, width: totalMoneyWidth , height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))
        totalMoneyLabel.text = totalMoneyStr
        
        orderActionRightBtn.isHidden = false
        orderActionLeftBtn.isHidden = false
        
        
        
        if model.CanPay == true {
            orderActionLeftBtn.setTitle("查看订单", for: .normal)
            orderActionRightBtn.setTitle("去支付", for: .normal)
        }else if model.CanDelete == true {
            orderActionRightBtn.setTitle("删除订单", for: .normal)
            orderActionLeftBtn.setTitle("查看订单", for: .normal)
        }else if model.CanComment == true {
            orderActionRightBtn.setTitle("去评价", for: .normal)
            orderActionLeftBtn.isHidden = true
        }else{
            orderActionRightBtn.setTitle("查看订单", for: .normal)
            orderActionLeftBtn.isHidden = true
        }
        
        
        
    }
    
    //MARK: - 右边按钮响应
    @objc func orderActionRightBtnAct() {
        
        if let currentVC = GetCurrentViewController() as? OrderManageVC {
            
            if cellModel.CanPay == true {
                //currentVC.detailOrderService.waitPayOrderDetailDataRequest(userOrderID: cellModel.UserOrderID)
                
                
                orderPayService.orderPayInfoRequest(userOrderID: cellModel.UserOrderID, successAct: { (resultModel) in
                    DispatchQueue.main.async { 
                        let payOrderVC = OrderPayVC()
                        payOrderVC.orderPayModel = resultModel
                        GetCurrentViewController()?.navigationController?.pushViewController(payOrderVC, animated: true)
                    }
                }, failureAct: {
                    
                })
                
            }else if cellModel.CanDelete == true {
                
                popView = XYNoDetailTipsAlertView(frame: .zero, titleStr: "确定删除该订单吗？", cancelStr: "取消", certainStr: "确定", cancelBtnClosure: {
                
                }, certainClosure: { [weak self] in
                    //删除订单
                    currentVC.service.deleteOrderRequest(orderId: self!.cellModel.UserOrderID, successAct: {
                        cmShowHUDToWindow(message: "删除成功")
                        currentVC.mainTabView.mj_header.beginRefreshing()
                    }, failureAct: {
                        
                    })
                })
                popView.showInView(view: currentVC.view)

            }else if cellModel.CanComment == true {
                //去评价
                let orderEvaluateVC = OrderEvaluateVC()
                orderEvaluateVC.orderId = cellModel.UserOrderID
                currentVC.navigationController?.pushViewController(orderEvaluateVC, animated: true)
            }else{
                //查看订单
                currentVC.detailOrderService.otherOrderDetailDataRequest(userOrderID: cellModel.UserOrderID)
            }
            
        }

        
        

        
        
    }
    //MARK: - 左边按钮响应
    @objc func orderActionLeftBtnAct() {
        //查看订单
        if let currentVC = GetCurrentViewController() as? OrderManageVC {
            if  cellModel.CanPay == true {
                currentVC.detailOrderService.waitPayOrderDetailDataRequest(userOrderID: cellModel.UserOrderID)
            }else{
                currentVC.detailOrderService.otherOrderDetailDataRequest(userOrderID: cellModel.UserOrderID)
            }
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
