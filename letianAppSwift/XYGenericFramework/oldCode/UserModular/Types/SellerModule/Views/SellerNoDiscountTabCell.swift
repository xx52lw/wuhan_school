//
//  SellerNoDiscountTabCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/17.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class SellerNoDiscountTabCell: UITableViewCell {

    static var noDiscountCellHeight = cmSizeFloat(30+24+26) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))*2 + cmSingleLineHeight(fontSize: cmSystemFontWithSize(16))
    
    let cellWidth = SCREEN_WIDTH - cmSizeFloat(75) - cmSizeFloat(10)
    
    let imageSize = cmSizeFloat(60)
    let toTopBottom = cmSizeFloat(15)
    let toSide = cmSizeFloat(10)
    let lineHeight = cmSizeFloat(8)
    let toImageWidth = cmSizeFloat(10)
    let addBtnSize = cmSizeFloat(26)
    let typesBtnWidth = cmSizeFloat(75)
    
    
    let addImage = #imageLiteral(resourceName: "shopcartPlus")
    let reduceImage = #imageLiteral(resourceName: "shopcartReduce")
    let grayAddImage = #imageLiteral(resourceName: "grayAdd")

    
    var cellImageView:UIImageView!
    var goodsNameLabel:UILabel!
    var goodSaleInfoLabel:UILabel!
    var goodsDetailLabel:UILabel!
    //货币符号label
    var currencySymbolLabel:UILabel!
    var discountPriceLabel:UILabel!
    var costPriceLabel:UILabel!
    var addBtn:UIButton!
    var selectedCountLabel:UILabel!
    var reduceBtn:UIButton!
    
    //当前cell的标签
    var currentIndex:Int!
    var cellModel:SellerHomePageGoodsCellModel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            let wordWidth =  cellWidth - imageSize - toImageWidth - toSide*2
            
            cellImageView = UIImageView(frame: CGRect(x: toSide, y: toTopBottom, width: imageSize, height: imageSize))
            self.addSubview(cellImageView)
            
            goodsNameLabel = UILabel(frame: CGRect(x: cellImageView.right + toImageWidth, y: toTopBottom, width:wordWidth , height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(16))))
            goodsNameLabel.font = cmSystemFontWithSize(16)
            goodsNameLabel.textColor = MAIN_BLACK
            goodsNameLabel.textAlignment = .left
            self.addSubview(goodsNameLabel)
            
            goodSaleInfoLabel = UILabel(frame: CGRect(x: cellImageView.right + toImageWidth, y: goodsNameLabel.bottom + lineHeight, width:wordWidth , height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
            goodSaleInfoLabel.font = cmSystemFontWithSize(12)
            goodSaleInfoLabel.textColor = MAIN_BLACK2
            goodSaleInfoLabel.textAlignment = .left
            self.addSubview(goodSaleInfoLabel)
            
            
            
            
            goodsDetailLabel = UILabel(frame: CGRect(x: cellImageView.right + toImageWidth, y: goodSaleInfoLabel.bottom + lineHeight, width:wordWidth , height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
            goodsDetailLabel.font = cmSystemFontWithSize(12)
            goodsDetailLabel.textColor = MAIN_GRAY
            goodsDetailLabel.textAlignment = .left
            self.addSubview(goodsDetailLabel)
            
            addBtn = UIButton(frame: .zero)
            addBtn.addTarget(self, action: #selector(addBtnAct), for: .touchUpInside)
            //addBtn.backgroundColor = cmColorWithString(colorName: "666666")
            self.addSubview(addBtn)
            
            
            selectedCountLabel = UILabel(frame: .zero)
            selectedCountLabel.font = cmSystemFontWithSize(14)
            selectedCountLabel.textColor = MAIN_BLACK
            selectedCountLabel.textAlignment = .center
            self.addSubview(selectedCountLabel)
            
            
            reduceBtn = UIButton(frame: .zero)
            reduceBtn.setImage(reduceImage, for: .normal)
            reduceBtn.addTarget(self, action: #selector(reduceBtnAct), for: .touchUpInside)
            self.addSubview(reduceBtn)
            
            currencySymbolLabel = UILabel(frame: .zero)
            currencySymbolLabel.font = cmSystemFontWithSize(12)
            currencySymbolLabel.textColor = MAIN_RED
            currencySymbolLabel.textAlignment = .left
            currencySymbolLabel.text = "¥"
            self.addSubview(currencySymbolLabel)
            
            
            discountPriceLabel = UILabel(frame: .zero)
            discountPriceLabel.font = cmBoldSystemFontWithSize(17)
            discountPriceLabel.textColor = MAIN_RED
            discountPriceLabel.textAlignment = .left
            self.addSubview(discountPriceLabel)
            
            costPriceLabel = UILabel(frame: .zero)
            costPriceLabel.font = cmSystemFontWithSize(12)
            costPriceLabel.textColor = MAIN_GRAY
            costPriceLabel.textAlignment = .left
            
            self.addSubview(costPriceLabel)
            
            let  seperateLine = XYCommonViews.creatCommonSeperateLine(pointY: SellerNoDiscountTabCell.noDiscountCellHeight - CGFloat(1))
            self.addSubview(seperateLine)
        }
    }
    
    func setModel(model:SellerHomePageGoodsCellModel,index:Int){
        
        self.currentIndex = index
        self.cellModel = model

        if let imageUrl = URL(string:model.imageUrl){
            cellImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeHolderImage"))
        }else{
            cellImageView.image = #imageLiteral(resourceName: "placeHolderImage")
        }
        
        goodsNameLabel.text = model.goodsName
        goodSaleInfoLabel.text = model.goodsInfoStr
        goodsDetailLabel.text = model.goodsDetailStr
        
        //增减号处理
        addBtn.frame = CGRect(x: cellWidth - addBtnSize - toSide, y: goodsDetailLabel.bottom + lineHeight, width:addBtnSize , height: addBtnSize)
        
        
        let selectedCountWidth = String(model.selectedCount).stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14)) + cmSizeFloat(5)
        selectedCountLabel.frame = CGRect(x: addBtn.left - selectedCountWidth, y: addBtn.top, width:selectedCountWidth , height: addBtnSize)
        selectedCountLabel.text = String(model.selectedCount)
        
        reduceBtn.frame = CGRect(x: selectedCountLabel.left - addBtnSize, y: addBtn.top, width:addBtnSize , height: addBtnSize)
        if model.selectedCount == 0 {
            reduceBtn.isHidden = true
            selectedCountLabel.isHidden = true
        }else{
            reduceBtn.isHidden = false
            selectedCountLabel.isHidden = false
        }
        
        
        //折扣价格与标价显示处理
        let currencySymbolLabelWidth = "¥".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)), font: cmSystemFontWithSize(12))
        currencySymbolLabel.frame = CGRect(x: cellImageView.right + toImageWidth, y: goodsDetailLabel.bottom + lineHeight, width:currencySymbolLabelWidth , height: addBtnSize)
        
        var discountPriceStr = moneyExchangeToString(moneyAmount:model.discountPriceStr)
        
        //如果没有折扣，则将原价显示在折扣价位置
        if model.discountDetailStr.isEmpty {
            discountPriceStr = moneyExchangeToString(moneyAmount: model.costPriceStr)
            costPriceLabel.isHidden = true
            
        }
        
        let discountPriceWidth = discountPriceStr.stringWidth(cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(17)), font: cmBoldSystemFontWithSize(17))
        discountPriceLabel.frame = CGRect(x: currencySymbolLabel.right, y: goodsDetailLabel.bottom + lineHeight, width:discountPriceWidth , height: addBtnSize)
        discountPriceLabel.text = discountPriceStr
        
        
        costPriceLabel.frame = CGRect(x: discountPriceLabel.right + cmSizeFloat(7), y: goodsDetailLabel.bottom + lineHeight, width:addBtn.left -  discountPriceLabel.right, height: addBtnSize)
        //添加中划线
        let attributes = [NSAttributedStringKey.font:cmSystemFontWithSize(12),NSAttributedStringKey.foregroundColor:MAIN_GRAY,NSAttributedStringKey.strikethroughStyle:NSNumber.init(value:1)]
        costPriceLabel.attributedText = NSAttributedString.init(string: "¥" + moneyExchangeToString(moneyAmount: model.costPriceStr) , attributes: attributes)
        
        //1:待上架，2：销售中，3：暂停销售
        addBtn.setTitle(nil, for: .normal)
        addBtn.setImage(nil, for: .normal)
        var goodsStatus = ""
        if model.goodsStatus == 1 || model.goodsStatus == 3 {
            if model.goodsStatus == 1 {
                goodsStatus = "待上架"
            }else{
                goodsStatus = "暂停销售"
            }
            let goodStatusWidth = goodsStatus.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
            addBtn.frame.origin.x = cellWidth - goodStatusWidth - toSide
            addBtn.frame.size.width = goodStatusWidth
            addBtn.setTitle(goodsStatus, for: .normal)
            addBtn.setTitleColor(MAIN_GRAY, for: .normal)
            addBtn.titleLabel?.font = cmSystemFontWithSize(14)
            addBtn.isEnabled = false
        }else{
            if SellerDetailPageVC.shopVCSellerHomeCommonModel.isOpenStatus == true {
                addBtn.setImage(addImage, for: .normal)
            }else{
                addBtn.setImage(grayAddImage, for: .normal)
            }
            addBtn.isEnabled = true
        }
    }
    
    
    
    //MARK: - 增加按钮响应
    @objc func addBtnAct(){
        
        if SellerDetailPageVC.shopVCSellerHomeCommonModel.isOpenStatus == false {
            cmShowHUDToWindow(message: "商家已暂停营业")
            return
        }
        
        if let sellerHomeVC = self.getViewControllerFromView() as? ShopcartVC {
            goodsCellAddReduceBtnAct(sellerHomeVC: sellerHomeVC, currentIndex: self.currentIndex, cellModel: self.cellModel, goodsNum: sellerHomeVC.sellerModel.goodsCellModelArr[self.currentIndex].selectedCount + 1)


        }
        
    }
    
    //MARK: - 减少按钮响应
    @objc func reduceBtnAct(){
        if let sellerHomeVC = self.getViewControllerFromView() as? ShopcartVC {
            if  sellerHomeVC.sellerModel.goodsCellModelArr[self.currentIndex].selectedCount > 0{
                goodsCellAddReduceBtnAct(sellerHomeVC: sellerHomeVC, currentIndex: self.currentIndex, cellModel: self.cellModel, goodsNum: sellerHomeVC.sellerModel.goodsCellModelArr[self.currentIndex].selectedCount - 1)
            }
        }
    }
    
    /*
    //MARK: - textField监听
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if Int(textField.text!) != nil{
            
            if Int(textField.text!)! < 1 {
                if let sellerHomeVC = self.getViewControllerFromView() as? ShopcartVC {
                    textField.text = String(sellerHomeVC.sellerModel.goodsCellModelArr[self.currentIndex].selectedCount)
                }
                cmShowMbProgressHUD(message:"购买数量不能小于1" )
                return
            }
            if let sellerHomeVC = self.getViewControllerFromView() as? ShopcartVC {
                
                if Int(textField.text!)! != sellerHomeVC.sellerModel.goodsCellModelArr[self.currentIndex].selectedCount {
                
                    goodsCellAddReduceBtnAct(sellerHomeVC: sellerHomeVC, currentIndex: currentIndex, cellModel: cellModel, goodsNum: Int(textField.text!)!)
                }
            }
            
        }else{
            if let sellerHomeVC = self.getViewControllerFromView() as? ShopcartVC {
                textField.text = String(sellerHomeVC.sellerModel.goodsCellModelArr[self.currentIndex].selectedCount)
            }
            cmShowMbProgressHUD(message: "购买数量有误")
        }
    }
  */

    
    
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


//MARK: - 商家详情商品cell增加减少按钮响应
func goodsCellAddReduceBtnAct(sellerHomeVC:ShopcartVC,currentIndex:Int,cellModel:SellerHomePageGoodsCellModel,goodsNum:Int){
    
    sellerHomeVC.shopcartService.shopcartAddGoodsRequest(targetVC: sellerHomeVC, goodsSpuid: cellModel.goodsID, addNum: goodsNum, successAct: { (shopcartModelArr) in
        
        //如果当前选择的cell已经清空
        if goodsNum == 0 {
            sellerHomeVC.sellerModel.goodsCellModelArr[currentIndex].selectedCount = 0
        }else{
            //先将cell已购数量清0
            for shopcartTempModel in shopcartModelArr {
                for goodsCellIndex in 0..<sellerHomeVC.sellerModel.goodsCellModelArr.count {
                    if shopcartTempModel.goodsID == sellerHomeVC.sellerModel.goodsCellModelArr[goodsCellIndex].goodsID {
                        sellerHomeVC.sellerModel.goodsCellModelArr[goodsCellIndex].selectedCount = 0
                        break
                    }
                }
            }
            
            
            //然后累加购物车当中的所有当前商品数目之和即为所有的已购数目（含折扣与无折扣商品之和）,将购物车的数据同步到cell当中
            for shopcartTempModel in shopcartModelArr {
                for goodsCellIndex in 0..<sellerHomeVC.sellerModel.goodsCellModelArr.count {
                    if shopcartTempModel.goodsID == sellerHomeVC.sellerModel.goodsCellModelArr[goodsCellIndex].goodsID {
                        sellerHomeVC.sellerModel.goodsCellModelArr[goodsCellIndex].selectedCount += shopcartTempModel.selectedCount
                        break
                    }
                }
            }
        }

        
        sellerHomeVC.sellerModel.shopcartModelArr = shopcartModelArr
        //更新UI
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: currentIndex, section: 0)
            sellerHomeVC.goodsTableView.reloadRows(at: [indexPath], with: .none)
            sellerHomeVC.refreshBottomView()
        }
    }, fialureAct: {
        //更新UI
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: currentIndex, section: 0)
            sellerHomeVC.goodsTableView.reloadRows(at: [indexPath], with: .none)
            sellerHomeVC.refreshBottomView()
        }
    })

    
}










