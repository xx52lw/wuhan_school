//
//  ShopcartNoOtherInfoTabCell.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/18.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class ShopcartNoOtherInfoTabCell: UITableViewCell {

    static var  ShopcartNoOtherInfoHeight = cmSizeFloat(70)
    
    let addImage = #imageLiteral(resourceName: "shopcartPlus")
    let reduceImage = #imageLiteral(resourceName: "shopcartReduce")
    let toside = cmSizeFloat(10)
    let toTopBottom = cmSizeFloat(10)
    let wordSpaceHeight = cmSizeFloat(10)
    let cellWidth = SCREEN_WIDTH  - cmSizeFloat(10)*2
    let addBtnSize = cmSizeFloat(44)
    let bottomViewHeight = TABBAR_HEIGHT
    let discountInfoHeight = cmSizeFloat(30)

    var goodsInfoLabel:UILabel!
    var addBtn:UIButton!
    var selectedCountLabel:UILabel!
    var reduceBtn:UIButton!
    var goodsPriceLabel:UILabel!
    var currentIndex:Int!
    var cellShopcartModel:ShopcartModel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            
            goodsInfoLabel = UILabel(frame: CGRect(x: 0, y: (ShopcartNoOtherInfoTabCell.ShopcartNoOtherInfoHeight - cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)))/2, width: cellWidth/2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(14))))
            goodsInfoLabel.font = cmSystemFontWithSize(14)
            goodsInfoLabel.textColor = MAIN_BLACK
            goodsInfoLabel.textAlignment = .left
            self.addSubview(goodsInfoLabel)
            
            
            addBtn = UIButton(frame: CGRect(x: cellWidth - addBtnSize, y: (ShopcartNoOtherInfoTabCell.ShopcartNoOtherInfoHeight - addBtnSize)/2, width: addBtnSize, height: addBtnSize))
            addBtn.setImage(addImage, for: .normal)
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
            
            goodsPriceLabel  = UILabel(frame: .zero)
            goodsPriceLabel.font = cmSystemFontWithSize(15)
            goodsPriceLabel.textColor = MAIN_ORANGE
            goodsPriceLabel.textAlignment = .right
            self.addSubview(goodsPriceLabel)
            
           let seperateLine = XYCommonViews.creatCommonSeperateLine(pointY: ShopcartNoOtherInfoTabCell.ShopcartNoOtherInfoHeight - cmSizeFloat(1))
            seperateLine.frame.size.width = cellWidth
            self.addSubview(seperateLine)
        }
    }
    
    
    
    func setModel(model:ShopcartModel,index:Int){
        self.currentIndex = index
        self.cellShopcartModel = model
        goodsInfoLabel.text = model.goodsNameStr
        
        let selectedCountWidth = String(model.selectedCount).stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14)) + cmSizeFloat(5)
        selectedCountLabel.frame = CGRect(x: addBtn.left - selectedCountWidth, y: addBtn.top, width:selectedCountWidth , height: addBtnSize)
        selectedCountLabel.text = String(model.selectedCount)
        
        reduceBtn.frame = CGRect(x: selectedCountLabel.left - addBtnSize, y: addBtn.top, width:addBtnSize , height: addBtnSize)
        
        let goodsPriceStr = "¥" + moneyExchangeToString(moneyAmount: model.goodsPriceStr)
        var goodsPriceLabelWidth = goodsPriceStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
        if goodsPriceLabelWidth > cellWidth/4 {
            goodsPriceLabelWidth = cellWidth/4
        }
        goodsPriceLabel.frame = CGRect(x: reduceBtn.left - toside - goodsPriceLabelWidth, y: addBtn.top, width: goodsPriceLabelWidth, height: addBtnSize)
        goodsPriceLabel.text = goodsPriceStr
    }
    
    
    //MARK: - 增加按钮响应
    @objc func addBtnAct(){
        cmDebugPrint(self.currentIndex)
        if let tatgetVC = GetCurrentViewController() as? SellerDetailPageVC {
            if  let sellerHomeVC =   tatgetVC.pageController.currentViewController  as? ShopcartVC {
            
                sellerHomeVC.shopcartService.updatesShopcartRequest(targetVC: tatgetVC, shopcartID: cellShopcartModel.shopCartId, updateNum: sellerHomeVC.sellerModel.shopcartModelArr[self.currentIndex].selectedCount + 1, successAct: { [weak self]  in
                    DispatchQueue.main.async {
                        sellerHomeVC.sellerModel.shopcartModelArr[self!.currentIndex].selectedCount += 1
                        
                        //将购物车新增的数据同步到首页model当中
                        for index in 0..<sellerHomeVC.sellerModel.typeAndGoodsModelDicArr.count {
                            for goodsCellIndex in 0..<sellerHomeVC.sellerModel.typeAndGoodsModelDicArr[index].values.first!.count {
                                    if sellerHomeVC.sellerModel.shopcartModelArr[self!.currentIndex].goodsID == sellerHomeVC.sellerModel.typeAndGoodsModelDicArr[index].values.first![goodsCellIndex].goodsID {
                                        sellerHomeVC.sellerModel.typeAndGoodsModelDicArr[index].values.first![goodsCellIndex].selectedCount += 1
                                        break
                                }
                            }
                        }
                        
                        SellerDetailPageVC.shopVCSellerHomeCommonModel = sellerHomeVC.sellerModel
                        
                        self?.updateGoodsTableView()
                        
                        let indexPath = IndexPath(row: self!.currentIndex, section: 0)
                        sellerHomeVC.shopcartView.shopcartTableView.reloadRows(at: [indexPath], with: .none)
                        sellerHomeVC.refreshBottomView()
                    }

                    
                }, fialureAct: {
                    
                })
                

        }
        }
    }
    
    //MARK: - 减少按钮响应
    @objc func reduceBtnAct(){
        if let tatgetVC = GetCurrentViewController() as? SellerDetailPageVC {
            if  let sellerHomeVC =   tatgetVC.pageController.currentViewController  as? ShopcartVC {
            if  sellerHomeVC.sellerModel.shopcartModelArr[self.currentIndex].selectedCount > 0{
                
                
                sellerHomeVC.shopcartService.updatesShopcartRequest(targetVC: tatgetVC, shopcartID: cellShopcartModel.shopCartId, updateNum: sellerHomeVC.sellerModel.shopcartModelArr[self.currentIndex].selectedCount - 1, successAct: { [weak self] in
                    
                    //将购物车新增的数据同步到首页model当中
                    for index in 0..<sellerHomeVC.sellerModel.typeAndGoodsModelDicArr.count {
                        for goodsCellIndex in 0..<sellerHomeVC.sellerModel.typeAndGoodsModelDicArr[index].values.first!.count {
                            if sellerHomeVC.sellerModel.shopcartModelArr[self!.currentIndex].goodsID == sellerHomeVC.sellerModel.typeAndGoodsModelDicArr[index].values.first![goodsCellIndex].goodsID {
                                sellerHomeVC.sellerModel.typeAndGoodsModelDicArr[index].values.first![goodsCellIndex].selectedCount -= 1
                                break
                            }
                        }
                    }
                    SellerDetailPageVC.shopVCSellerHomeCommonModel = sellerHomeVC.sellerModel
                    
                    DispatchQueue.main.async {
                        sellerHomeVC.sellerModel.shopcartModelArr[self!.currentIndex].selectedCount -= 1
                        
                        self?.updateGoodsTableView()
                        if sellerHomeVC.sellerModel.shopcartModelArr[self!.currentIndex].selectedCount > 0 {
                            let indexPath = IndexPath(row: self!.currentIndex, section: 0)
                            sellerHomeVC.shopcartView.shopcartTableView.reloadRows(at: [indexPath], with: .none)
                        }else{
                            sellerHomeVC.sellerModel.shopcartModelArr.remove(at: self!.currentIndex)
                            
                            //重新设置购物车的Frame与遮罩的frame
                            var shopcartCount = sellerHomeVC.sellerModel.shopcartModelArr.count
                            if shopcartCount > 4 {
                                shopcartCount = 4
                            }
                            let tableViewHeight = CGFloat(shopcartCount) * ShopCartTableViewCell.ShopCartCellHeight
                            
                            sellerHomeVC.shopcartMaskView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT  - (ShopcartView.headerViewHeihgt + tableViewHeight + self!.bottomViewHeight + self!.discountInfoHeight))
                            sellerHomeVC.shopcartView.frame = CGRect(x: 0, y: sellerHomeVC.shopcartMaskView.bottom, width: SCREEN_WIDTH, height: ShopcartView.headerViewHeihgt + tableViewHeight)
                            sellerHomeVC.shopcartView.shopcartTableView.frame.size.height = tableViewHeight
                            //刷新购物车tableview
                            sellerHomeVC.shopcartView.shopcartTableView.reloadData()
                            //如果购物车当中已经为空，收回购物车
                            if sellerHomeVC.sellerModel.shopcartModelArr.count == 0 {
                                sellerHomeVC.shopcartMaskView.removeMaskViewAct()
                            }
                        }
                        
                    sellerHomeVC.refreshBottomView()
                    }
                    
                    
                }, fialureAct: {
                    
                })
                
                
                
                }
            }
        }
    }
    
    
    
    //MARK: - 增加或减少购物车数据时更新主页面数据
    func updateGoodsTableView(){
        if let tatgetVC = GetCurrentViewController() as? SellerDetailPageVC {
            if  let sellerHomeVC =   tatgetVC.pageController.currentViewController  as? ShopcartVC {
            
            for modelIndex in 0..<sellerHomeVC.sellerModel.goodsCellModelArr.count {
                if sellerHomeVC.sellerModel.goodsCellModelArr[modelIndex].goodsID == sellerHomeVC.sellerModel.shopcartModelArr[currentIndex].goodsID {
                    
                    let indexPath = IndexPath(row: modelIndex, section: 0)
                    sellerHomeVC.goodsTableView.reloadRows(at: [indexPath], with: .none)
                    break
                }
            }
        }
        }
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
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
