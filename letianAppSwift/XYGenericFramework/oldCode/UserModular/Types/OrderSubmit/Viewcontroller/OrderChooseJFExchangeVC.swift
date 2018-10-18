//
//  OrderChooseJFExchangeVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/23.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderChooseJFExchangeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    typealias SelectedFinishAct = ()->Void
    
    var topView:XYTopView!
    var mainTabView:UITableView!
    var tableHeaderView:UIView!
    var unuseJiFenBtn:UIButton!
    
    var jfModelArr:[OrderSelectJFModel] = Array()
    var selectedFinishAct:SelectedFinishAct!
    var seperateLine:UIView!
    
    var jfAmount:Int!
    var jfExchangeAmount:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createCellData()
        createTableHeaderView()
        creatMainTabView()
        // Do any additional setup after loading the view.
    }
    
    
    func createCellData() {
        for index in 1..<6{
            let cellModel = OrderSelectJFModel()
            cellModel.isSelected = false
            cellModel.jfAmount = 100*index
            jfModelArr.append(cellModel)
        }
    }
    
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).navigationTitleItem().rightStrBtnItem(target: self, action: #selector(selectedOkBtnAct), btnStr: "确认", fontSize: 15))
        topView.titleLabel.text = "商家代金券"
    }
    
    @objc func  selectedOkBtnAct() {
        
        let navVCCount = self.navigationController!.viewControllers.count
        if  let lastVC = self.navigationController?.viewControllers[navVCCount - 2] as? OrderSubmitViewController {
            lastVC.refreshUI()
            selectedFinishAct()
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    func createTableHeaderView(){
        
        let headerViewHeight = cmSizeFloat(7+44+7*2+10) + cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(14))*2 + cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))
        let spaceHeight = cmSizeFloat(7)
        let toSide = cmSizeFloat(20)
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: headerViewHeight))
        
        unuseJiFenBtn = UIButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: cmSizeFloat(44)))
        unuseJiFenBtn.setTitle("不使用优惠券", for: .normal)
        unuseJiFenBtn.setTitleColor(MAIN_BLACK, for: .normal)
        unuseJiFenBtn.titleLabel?.font = cmSystemFontWithSize(14)
        unuseJiFenBtn.addTarget(self, action: #selector(unuseJiFenBtnAct), for: .touchUpInside)
        tableHeaderView.addSubview(unuseJiFenBtn)
        
        
        seperateLine = XYCommonViews.creatCustomSeperateLine(pointY: unuseJiFenBtn.bottom, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
        tableHeaderView.addSubview(seperateLine)
        
        let sellerJFAmountLabel = UILabel(frame: CGRect(x: toSide, y: seperateLine.bottom + spaceHeight, width: SCREEN_WIDTH - toSide*2, height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(14))))
        sellerJFAmountLabel.font = cmBoldSystemFontWithSize(14)
        sellerJFAmountLabel.textColor = MAIN_BLACK
        sellerJFAmountLabel.textAlignment = .left
        sellerJFAmountLabel.text = "商家积分  " + String(jfAmount)
        tableHeaderView.addSubview(sellerJFAmountLabel)
        
        let exchangeJFTipsLabel = UILabel(frame: CGRect(x: toSide, y: sellerJFAmountLabel.bottom + spaceHeight, width: SCREEN_WIDTH - toSide*2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
        exchangeJFTipsLabel.font = cmSystemFontWithSize(12)
        exchangeJFTipsLabel.textColor = MAIN_GRAY
        exchangeJFTipsLabel.textAlignment = .left
        exchangeJFTipsLabel.text = "兑换规则  " + String(jfExchangeAmount) + "积分兑换1元"
        tableHeaderView.addSubview(exchangeJFTipsLabel)
        
        let chooseJFTitleLabel = UILabel(frame: CGRect(x: toSide, y: exchangeJFTipsLabel.bottom + cmSizeFloat(10), width: SCREEN_WIDTH - toSide*2, height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(14))))
        chooseJFTitleLabel.font = cmBoldSystemFontWithSize(14)
        chooseJFTitleLabel.textColor = MAIN_BLACK
        chooseJFTitleLabel.textAlignment = .left
        chooseJFTitleLabel.text = "选择使用的积分"
        tableHeaderView.addSubview(chooseJFTitleLabel)

        
    }
    

    
    @objc func unuseJiFenBtnAct() {
        let navVCCount = self.navigationController!.viewControllers.count
        if  let lastVC = self.navigationController?.viewControllers[navVCCount - 2] as? OrderSubmitViewController {
            for index  in 0..<jfModelArr.count {
                jfModelArr[index].isSelected = false
            }
            lastVC.submitPrametersModel.isUseJF = false
            lastVC.submitPrametersModel.useJFAmount = 0
            selectedOkBtnAct()
        }
        
    }
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - seperateLine.bottom), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        mainTabView.tableHeaderView = self.tableHeaderView
        mainTabView.showsVerticalScrollIndicator = false
        mainTabView.showsHorizontalScrollIndicator = false
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(OrderJFExchangeTabCell.self, forCellReuseIdentifier: "OrderJFExchangeTabCell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jfModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  OrderJFExchangeTabCell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "OrderJFExchangeTabCell")
        if cell == nil {
            cell = OrderJFExchangeTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "OrderJFExchangeTabCell")
        }
        if let targetCell = cell as? OrderJFExchangeTabCell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: jfModelArr[indexPath.row])
            return targetCell
        }else{
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.jfAmount < jfModelArr[indexPath.row].jfAmount {
            cmShowHUDToWindow(message: "积分不够哦")
            return
        }
        
        
        let navVCCount = self.navigationController!.viewControllers.count
        if  let lastVC = self.navigationController?.viewControllers[navVCCount - 2] as? OrderSubmitViewController {
            for index  in 0..<jfModelArr.count {
                jfModelArr[index].isSelected = false
            }
            jfModelArr[indexPath.row].isSelected = true
            lastVC.submitPrametersModel.isUseJF = true
            lastVC.submitPrametersModel.useJFAmount = jfModelArr[indexPath.row].jfAmount
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
