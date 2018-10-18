//
//  OrderChoosePromotionVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/23.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderChoosePromotionVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    typealias SelectedFinishAct = ()->Void
    
    var topView:XYTopView!
    var mainTabView:UITableView!
    var unusePromotionBtn:UIButton!
    
    var promotionModelArr:[SellerPromotionCellModel] = Array()
    var selectedFinishAct:SelectedFinishAct!
    var seperateLine:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createUnusePromotionBtn()
        creatMainTabView()
        // Do any additional setup after loading the view.
    }

    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).navigationTitleItem())
        topView.titleLabel.text = "商家代金券"
    }
    

    
    
    func createUnusePromotionBtn() {
        unusePromotionBtn = UIButton(frame: CGRect(x: 0, y: topView.bottom, width: SCREEN_WIDTH, height: cmSizeFloat(44)))
        unusePromotionBtn.setTitle("不使用优惠券", for: .normal)
        unusePromotionBtn.setTitleColor(MAIN_BLACK, for: .normal)
        unusePromotionBtn.titleLabel?.font = cmSystemFontWithSize(14)
        unusePromotionBtn.addTarget(self, action: #selector(unusePromotionBtnAct), for: .touchUpInside)
        self.view.addSubview(unusePromotionBtn)
        
        
        seperateLine = XYCommonViews.creatCustomSeperateLine(pointY: unusePromotionBtn.bottom, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
        self.view.addSubview(seperateLine)

    }
    
    @objc func unusePromotionBtnAct() {
        let navVCCount = self.navigationController!.viewControllers.count
        if  let lastVC = self.navigationController?.viewControllers[navVCCount - 2] as? OrderSubmitViewController {
            lastVC.submitPrametersModel.selectedPromotionModel = nil
            for index  in 0..<promotionModelArr.count {
                promotionModelArr[index].isSelected = false
            }
            lastVC.refreshUI()
            selectedFinishAct()
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:seperateLine.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - seperateLine.bottom), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }

        mainTabView.showsVerticalScrollIndicator = false
        mainTabView.showsHorizontalScrollIndicator = false
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(OrderPromotionTabCell.self, forCellReuseIdentifier: "OrderPromotionTabCell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return promotionModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  OrderPromotionTabCell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "OrderPromotionTabCell")
        if cell == nil {
            cell = OrderPromotionTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "OrderPromotionTabCell")
        }
        if let targetCell = cell as? OrderPromotionTabCell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: promotionModelArr[indexPath.row])
            return targetCell
        }else{
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navVCCount = self.navigationController!.viewControllers.count
        if  let lastVC = self.navigationController?.viewControllers[navVCCount - 2] as? OrderSubmitViewController {
            for index  in 0..<promotionModelArr.count {
                promotionModelArr[index].isSelected = false
            }
            promotionModelArr[indexPath.row].isSelected = true
            lastVC.submitPrametersModel.selectedPromotionModel = promotionModelArr[indexPath.row]
            lastVC.refreshUI()
            selectedFinishAct()
            self.navigationController?.popViewController(animated: true)
        }
        self.mainTabView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
