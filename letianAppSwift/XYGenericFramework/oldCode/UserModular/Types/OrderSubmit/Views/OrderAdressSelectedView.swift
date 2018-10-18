//
//  OrderAdressSelectedView.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/18.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderAdressSelectedView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    let textViewHeight = cmSizeFloat(50)
    
    var control:UIControl!
    var sheetView:UIView!
    var schollDormTableView:UITableView!
    var dormBuildingTableView:UITableView!
    
    let MORE_CONTENT_VIEW_HEIGHT = SCREEN_HEIGHT/2
    
    var adressModelArr:[OrderRecieverAdressModel] = Array()
    
    var selectedDormFlag = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        control = UIControl.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        control.backgroundColor = cmColorWithString(colorName: "000000", alpha: 0.3)
        control.addTarget(self, action: #selector(controlClick), for: .touchUpInside)
        
        sheetView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: MORE_CONTENT_VIEW_HEIGHT))
        sheetView.backgroundColor = cmColorWithString(colorName: "fafafa")
        self.addSubview(sheetView)
        
        let deliveryTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: textViewHeight))
            deliveryTitleLabel.backgroundColor = MAIN_GRAY
        deliveryTitleLabel.font = cmBoldSystemFontWithSize(16)
        deliveryTitleLabel.textColor = MAIN_BLACK
        deliveryTitleLabel.textAlignment = .center
        deliveryTitleLabel.text = "配送区域"
        sheetView.addSubview(deliveryTitleLabel)
        
        if let currentVC = GetCurrentViewController() as? OrderSubmitViewController {
            
            self.adressModelArr = currentVC.submiteModel.recieverAdressArr
            
        }
        
        //公寓Tableview
        schollDormTableView = UITableView(frame: CGRect(x:0,y:deliveryTitleLabel.bottom, width:SCREEN_WIDTH/2, height:MORE_CONTENT_VIEW_HEIGHT-textViewHeight), style: .plain)
        if #available(iOS 11, *) {
            schollDormTableView.contentInsetAdjustmentBehavior = .never
        }
        schollDormTableView.backgroundColor = seperateLineColor
        schollDormTableView.separatorStyle = .none
        schollDormTableView.delegate = self
        schollDormTableView.dataSource = self
        schollDormTableView.register(OrderAdressDormTabCell.self, forCellReuseIdentifier: "OrderAdressDormTabCell")
        sheetView.addSubview(schollDormTableView)
        
        //楼栋tableview
        dormBuildingTableView = UITableView(frame: CGRect(x:SCREEN_WIDTH/2,y:deliveryTitleLabel.bottom, width:SCREEN_WIDTH/2, height:MORE_CONTENT_VIEW_HEIGHT-textViewHeight), style: .plain)
        if #available(iOS 11, *) {
            dormBuildingTableView.contentInsetAdjustmentBehavior = .never
        }
        dormBuildingTableView.separatorStyle = .none
        dormBuildingTableView.delegate = self
        dormBuildingTableView.dataSource = self
        dormBuildingTableView.register(OrderDetailGoodsCell.self, forCellReuseIdentifier: "OrderDetailGoodsCell")
        sheetView.addSubview(dormBuildingTableView)
        //sheetView.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: selectThirdBtn.bottom - cmSizeFloat(1)))
        
    }
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == schollDormTableView {
            return self.adressModelArr.count
        }else{
            if adressModelArr.count > 0 {
            return self.adressModelArr[selectedDormFlag].SAreaListModelArr.count
            }else{
                return 0
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == schollDormTableView {
            return  OrderAdressDormTabCell.cellHeight
        }else{
            return  OrderDormBuildingTabCell.cellHeight
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == schollDormTableView {
            var cell = tableView.dequeueReusableCell(withIdentifier: "OrderAdressDormTabCell")
            if cell == nil {
                cell = OrderAdressDormTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "OrderAdressDormTabCell")
            }
            if let targetCell = cell as? OrderAdressDormTabCell{
                targetCell.selectionStyle = .none
                targetCell.setModel(model: adressModelArr[indexPath.row])
                if selectedDormFlag == indexPath.row {
                    targetCell.backgroundColor = .white
                }else{
                    targetCell.backgroundColor = seperateLineColor
                }
                return targetCell
            }else{
                return cell!
            }
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "OrderDormBuildingTabCell")
            if cell == nil {
                cell = OrderDormBuildingTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "OrderDormBuildingTabCell")
            }
            if let targetCell = cell as? OrderDormBuildingTabCell{
                targetCell.selectionStyle = .none
                targetCell.setModel(model: adressModelArr[selectedDormFlag].SAreaListModelArr[indexPath.row])
                return targetCell
            }else{
                return cell!
            }
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  tableView == schollDormTableView {
            selectedDormFlag = indexPath.row
            schollDormTableView.reloadData()
            dormBuildingTableView.reloadData()
            
        }else{
            if let currentVC = GetCurrentViewController() as? OrderSubmitViewController {
                
                currentVC.submitPrametersModel.selectedSchoolBuildingModel = adressModelArr[selectedDormFlag].SAreaListModelArr[indexPath.row]
                currentVC.submitPrametersModel.selectedAdressModel = adressModelArr[selectedDormFlag]
                currentVC.refreshUI()
                
            }
            for index in 0..<adressModelArr[selectedDormFlag].SAreaListModelArr.count {
                adressModelArr[selectedDormFlag].SAreaListModelArr[index].isSelected = false
            }
            adressModelArr[selectedDormFlag].SAreaListModelArr[indexPath.row].isSelected = true
            dormBuildingTableView.reloadData()
            self.hideInView()
        }
    }
    

    //展示View
    func showInView(view:UIView){
        self.isHidden = false
        if (control.superview==nil) {
            view.addSubview(control)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.control.alpha = 1
        })
        let animation = CATransition()
        
        animation.duration = 0.2
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        self.layer.add(animation, forKey: "animation1")
        self.frame = CGRect(x:0,y:view.frame.size.height - MORE_CONTENT_VIEW_HEIGHT, width:SCREEN_WIDTH, height:MORE_CONTENT_VIEW_HEIGHT);
        view.addSubview(self)
    }
    
    
    
    func hideInView() {
        if !self.isHidden {
            self.isHidden = true
            let animation = CATransition()
            
            animation.duration = 0.2
            animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            
            animation.type = kCATransitionPush
            animation.subtype = kCATransitionFromBottom
            self.layer.add(animation, forKey: "animation2")
            UIView.animate(withDuration: 0.2, animations: {
                self.control.alpha = 0
            }) { (Bool) in
                self.removeFromSuperview()
            }
        }
    }
    
    
    
    @objc func controlClick() {
        self.hideInView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    //    func showAlert(title:String?,message:String?,vc:UIViewController) {
    //        let alertController = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: .alert)
    //        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
    //        vc.present(alertController, animated: true, completion: nil)
    //    }
    
    
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
