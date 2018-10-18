//
//  OrderDeliveryTimeSelectedView.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/4/2.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderDeliveryTimeSelectedView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    let textViewHeight = cmSizeFloat(50)
    
    var control:UIControl!
    var sheetView:UIView!
    var currentTimeTableView:UITableView!
    var appointTimeTableView:UITableView!
    
    let MORE_CONTENT_VIEW_HEIGHT = SCREEN_HEIGHT/2
    
    var deliveryTimeModelArr:[DeliverChooseTypeModel] = Array()
    
    var selectedTimeFlag = 0
    
    //当前时间及周几
    var currentDateStr:String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = TimeStampDateFormatter.DateType1.rawValue
        currentDateStr =  dateFormatter.string(from: nowDate)

        
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
        deliveryTitleLabel.text = "送达时间"
        sheetView.addSubview(deliveryTitleLabel)
        
        if let currentVC = GetCurrentViewController() as? OrderSubmitViewController {
            
            self.deliveryTimeModelArr = currentVC.submiteModel.DeliverChooseTypeArr
            
        }
        
        //公寓Tableview
        currentTimeTableView = UITableView(frame: CGRect(x:0,y:deliveryTitleLabel.bottom, width:SCREEN_WIDTH/2, height:MORE_CONTENT_VIEW_HEIGHT-textViewHeight), style: .plain)
        if #available(iOS 11, *) {
            currentTimeTableView.contentInsetAdjustmentBehavior = .never
        }
        currentTimeTableView.backgroundColor = seperateLineColor
        currentTimeTableView.separatorStyle = .none
        currentTimeTableView.delegate = self
        currentTimeTableView.dataSource = self
        currentTimeTableView.register(OrderAppointDataTabcell.self, forCellReuseIdentifier: "OrderAppointDataTabcell")
        sheetView.addSubview(currentTimeTableView)
        
        //楼栋tableview
        appointTimeTableView = UITableView(frame: CGRect(x:SCREEN_WIDTH/2,y:deliveryTitleLabel.bottom, width:SCREEN_WIDTH/2, height:MORE_CONTENT_VIEW_HEIGHT-textViewHeight), style: .plain)
        if #available(iOS 11, *) {
            appointTimeTableView.contentInsetAdjustmentBehavior = .never
        }
        appointTimeTableView.separatorStyle = .none
        appointTimeTableView.delegate = self
        appointTimeTableView.dataSource = self
        appointTimeTableView.register(OrderDetailGoodsCell.self, forCellReuseIdentifier: "OrderDetailGoodsCell")
        sheetView.addSubview(appointTimeTableView)
        //sheetView.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: selectThirdBtn.bottom - cmSizeFloat(1)))
        
    }
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == currentTimeTableView {
            return 1
        }else{
                return self.deliveryTimeModelArr.count
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == currentTimeTableView {
            return  OrderAppointDataTabcell.cellHeight
        }else{
            return  OrderDeliveryTimeTabcell.cellHeight
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == currentTimeTableView {
            var cell = tableView.dequeueReusableCell(withIdentifier: "OrderAppointDataTabcell")
            if cell == nil {
                cell = OrderAppointDataTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "OrderAppointDataTabcell")
            }
            if let targetCell = cell as? OrderAppointDataTabcell{
                targetCell.selectionStyle = .none
                targetCell.appointDateLabel.text = currentDateStr
                if selectedTimeFlag == indexPath.row {
                    targetCell.backgroundColor = .white
                }else{
                    targetCell.backgroundColor = seperateLineColor
                }
                return targetCell
            }else{
                return cell!
            }
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "OrderDeliveryTimeTabcell")
            if cell == nil {
                cell = OrderDeliveryTimeTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "OrderDeliveryTimeTabcell")
            }
            if let targetCell = cell as? OrderDeliveryTimeTabcell{
                targetCell.selectionStyle = .none
                targetCell.setModel(model: deliveryTimeModelArr[indexPath.row])
                return targetCell
            }else{
                return cell!
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  tableView == currentTimeTableView {
            selectedTimeFlag = indexPath.row
            currentTimeTableView.reloadData()
            appointTimeTableView.reloadData()
            
        }else{
            if let currentVC = GetCurrentViewController() as? OrderSubmitViewController {
                currentVC.submitPrametersModel.selectedDeliveryTimeModel = deliveryTimeModelArr[indexPath.row]
                currentVC.refreshUI()
            }
            for index in 0..<deliveryTimeModelArr.count {
                deliveryTimeModelArr[index].isSelected = false
            }
            deliveryTimeModelArr[indexPath.row].isSelected = true
            appointTimeTableView.reloadData()
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

