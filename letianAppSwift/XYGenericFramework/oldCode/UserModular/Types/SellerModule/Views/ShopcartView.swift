//
//  ShopcartView.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/18.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class ShopcartView: UIView,UITableViewDelegate,UITableViewDataSource {

    static let headerViewHeihgt = cmSizeFloat(40)
    let toside = cmSizeFloat(10)
    let sideBarHeight = cmSizeFloat(20)
    let sideBarWidth = cmSizeFloat(4)
    let deleteImage = #imageLiteral(resourceName: "shopCartDelete")
    
    var shopcartTableView:UITableView!
    var shopcartModel:SellerHomePageModel!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width , height: ShopcartView.headerViewHeihgt))
        headerView.backgroundColor = cmColorWithString(colorName: "cccccc")
        self.addSubview(headerView)
        
        let sideBarView = UIView(frame: CGRect(x: toside, y: (ShopcartView.headerViewHeihgt - sideBarHeight)/2, width: sideBarWidth, height: sideBarHeight))
        sideBarView.backgroundColor = cmColorWithString(colorName: "1d88da")
        self.addSubview(sideBarView)
        
        let headerLabel = UILabel(frame: CGRect(x: sideBarView.right + toside, y: 0, width:frame.size.width/2 , height: ShopcartView.headerViewHeihgt))
        headerLabel.font = cmBoldSystemFontWithSize(13)
        headerLabel.textColor = MAIN_BLACK
        headerLabel.textAlignment = .left
        headerLabel.text = "已选商品"
        self.addSubview(headerLabel)
        
        let deleteStr = "清空"
        let deleteStrWidth = deleteStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
        let deleteAllLabel = UILabel(frame: CGRect(x: frame.size.width - toside - deleteStrWidth, y: 0, width:deleteStrWidth , height: ShopcartView.headerViewHeihgt))
        deleteAllLabel.font = cmBoldSystemFontWithSize(13)
        deleteAllLabel.textColor = MAIN_BLACK
        deleteAllLabel.textAlignment = .left
        deleteAllLabel.text = deleteStr
        self.addSubview(deleteAllLabel)
        
        let deleteImageView = UIImageView(frame: CGRect(x: deleteAllLabel.left - cmSizeFloat(4) - deleteImage.size.width, y: ShopcartView.headerViewHeihgt/2 - deleteImage.size.height/2, width: deleteImage.size.width, height: deleteImage.size.height))
        deleteImageView.image = deleteImage
        self.addSubview(deleteImageView)
        
        let deleteBtn = UIButton(frame: CGRect(x: deleteImageView.left, y: 0, width: frame.size.width - deleteImageView.left, height: ShopcartView.headerViewHeihgt))
        deleteBtn.addTarget(self, action: #selector(deleteBtnAct), for: .touchUpInside)
        self.addSubview(deleteBtn)
        
        
        if let tatgetVC = GetCurrentViewController() as? SellerDetailPageVC {
            if  let currentVC =   tatgetVC.pageController.currentViewController  as? ShopcartVC {
                shopcartModel = currentVC.sellerModel
                creatShopCartTableView(frame:frame)
            }
        }
        
    }
    
    
    //MARK: - 清空按钮响应
    @objc func deleteBtnAct(){
        
        if let tatgetVC = GetCurrentViewController() as? SellerDetailPageVC {
            if  let currentVC =   tatgetVC.pageController.currentViewController  as? ShopcartVC {
                
                currentVC.shopcartService.removeShopcartAllGoodsRequest(merchantID: tatgetVC.merchantID, successAct: {
                    
                    DispatchQueue.main.async {
                        //同步清空所有分类下的数据
                        for goodsIndex in 0..<currentVC.sellerModel.shopcartModelArr.count{
                            
                            for tempTypeDicIndex in 0..<currentVC.sellerModel.typeAndGoodsModelDicArr.count {
                                
                                for modelIndex in 0..<currentVC.sellerModel.typeAndGoodsModelDicArr[tempTypeDicIndex].values.first!.count {
                                    if currentVC.sellerModel.typeAndGoodsModelDicArr[tempTypeDicIndex].values.first![modelIndex].goodsID == currentVC.sellerModel.shopcartModelArr[goodsIndex].goodsID {
                                        currentVC.sellerModel.typeAndGoodsModelDicArr[tempTypeDicIndex].values.first![modelIndex].selectedCount =  0
                                        break
                                    }
                                }
                                
                            }
                        }
                        
                        //刷新当前tableview中清空的数据
                        for goodsIndex in 0..<currentVC.sellerModel.shopcartModelArr.count{
                            for modelIndex in 0..<currentVC.sellerModel.goodsCellModelArr.count {
                                if currentVC.sellerModel.goodsCellModelArr[modelIndex].goodsID == currentVC.sellerModel.shopcartModelArr[goodsIndex].goodsID {
                                    let indexPath = IndexPath(row: modelIndex, section: 0)
                                    currentVC.goodsTableView.reloadRows(at: [indexPath], with: .none)
                                    break
                                }
                            }
                        }
                        
                        
                        
                        currentVC.sellerModel.shopcartModelArr.removeAll()
                        currentVC.shopcartMaskView.removeMaskViewAct()
                        currentVC.refreshBottomView()
                    }
                    
                }, fialureAct: {
                    
                })
                

        }
        }
        
    }
    
    
    //MARK: - 创建tableView
    func creatShopCartTableView(frame:CGRect){
        shopcartTableView = UITableView(frame: CGRect(x:toside ,y:ShopcartView.headerViewHeihgt, width:frame.size.width - toside*2, height:frame.size.height - ShopcartView.headerViewHeihgt), style: .plain)
        if #available(iOS 11, *) {
            shopcartTableView.contentInsetAdjustmentBehavior = .never
            shopcartTableView.estimatedRowHeight = 0
        }
        
        shopcartTableView.showsVerticalScrollIndicator = false
        shopcartTableView.showsHorizontalScrollIndicator = false
        
        shopcartTableView.separatorStyle = .none
        shopcartTableView.register(ShopCartTableViewCell.self, forCellReuseIdentifier: "ShopCartTableViewCell")
        shopcartTableView.register(ShopcartNoOtherInfoTabCell.self, forCellReuseIdentifier: "ShopcartNoOtherInfoTabCell")
        
        
        
        shopcartTableView.delegate = self
        shopcartTableView.dataSource = self
        
        self.addSubview(shopcartTableView)
    }


    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopcartModel.shopcartModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if shopcartModel.shopcartModelArr[indexPath.row].otherInfoStr.isEmpty {
        return ShopcartNoOtherInfoTabCell.ShopcartNoOtherInfoHeight
        }else{
           return ShopCartTableViewCell.ShopCartCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if shopcartModel.shopcartModelArr[indexPath.row].otherInfoStr.isEmpty {
            var cell = tableView.dequeueReusableCell(withIdentifier: "ShopcartNoOtherInfoTabCell")
            if cell == nil {
                cell = ShopcartNoOtherInfoTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "ShopcartNoOtherInfoTabCell")
            }
            if let targetCell = cell as? ShopcartNoOtherInfoTabCell{
                targetCell.selectionStyle = .none
                
                targetCell.setModel(model: shopcartModel.shopcartModelArr[indexPath.row], index: indexPath.row)
                
                
                return targetCell
            }else{
                return cell!
            }
        }else{
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "ShopCartTableViewCell")
            if cell == nil {
                cell = ShopCartTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "ShopCartTableViewCell")
            }
            if let targetCell = cell as? ShopCartTableViewCell{
                targetCell.selectionStyle = .none
                
                targetCell.setModel(model: shopcartModel.shopcartModelArr[indexPath.row], index: indexPath.row)
                
                
                return targetCell
            }else{
                return cell!
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
