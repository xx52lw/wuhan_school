//
//  MerchantSettlementVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantSettlementVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let toside = cmSizeFloat(20)
    let functionImageArr = [#imageLiteral(resourceName: "settlementFinishOrder")]
    let functionStrArr = ["已完成订单"]
    
    var functionModelArr:[SettlementHomeCellModel] = Array()
    
    var topView:XYTopView!
    var mainTabView:UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        makeModelCellData()
        creatMainTabView()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - 数据构建
    func makeModelCellData(){
        
        for index in 0..<functionImageArr.count {
            let cellModel = SettlementHomeCellModel()
            cellModel.functionImage = functionImageArr[index]
            cellModel.functionStr = functionStrArr[index]
            functionModelArr.append(cellModel)
        }
        
    }
    
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "结算"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }

    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - topView.bottom), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        

        
        mainTabView.showsVerticalScrollIndicator = false
        mainTabView.showsHorizontalScrollIndicator = false
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(SettlementHomeTabcell.self, forCellReuseIdentifier: "SettlementHomeTabcell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return functionModelArr.count

        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  SettlementHomeTabcell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "SettlementHomeTabcell")
        if cell == nil {
            cell = SettlementHomeTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "SettlementHomeTabcell")
        }
        if let targetCell = cell as? SettlementHomeTabcell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: functionModelArr[indexPath.row])
            return targetCell
        }else{
            return cell!
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let finishOrderVC = SettlementFinishOrderVC()
            self.navigationController?.pushViewController(finishOrderVC, animated: true)
            break
        default:
            break
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        tabBarController?.tabBar.isHidden = true
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
