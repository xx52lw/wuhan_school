//
//  DeliveryAdressManagerVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/17.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class DeliveryAdressManagerVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var topView:XYTopView!
    var mainTabView:UITableView!
    var addAdressBtn:UIButton!
    //网络异常空白页
    public var adressManagerAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var adressManagerNoDataView:XYAbnormalViewManager!
    
    var adressManagerModel:AdressManageModel!
    
    var service:DeliveryAdressService =  DeliveryAdressService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createAddBtn()
        service.deliveryAdressManagerListDataRequest(target: self)

        // Do any additional setup after loading the view.
    }

    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
            topView.titleLabel.text = "收货地址"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:isNetError ? topView.bottom:0 , width: SCREEN_WIDTH, height: isNetError ? SCREEN_HEIGHT-STATUS_NAV_HEIGHT:self.mainTabView.frame.size.height), in: isNetError ? self.view:self.mainTabView)
        
        if isNetError == false{
            adressManagerNoDataView = abnormalView
            adressManagerNoDataView.abnormalType = .noData
        }else if isNetError == true{
            adressManagerAbnormalView = abnormalView
            adressManagerAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            adressManagerAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.deliveryAdressManagerListDataRequest(target: self!)
            }
        }
    }
    
    
    func createAddBtn() {
        addAdressBtn = UIButton(frame: CGRect(x: 0, y: topView.bottom, width: SCREEN_WIDTH, height: cmSizeFloat(44)))
        addAdressBtn.setTitle("新增地址", for: .normal)
        addAdressBtn.setTitleColor(MAIN_BLUE, for: .normal)
        addAdressBtn.titleLabel?.font = cmSystemFontWithSize(14)
        addAdressBtn.addTarget(self, action: #selector(addAdressBtnAct), for: .touchUpInside)
        
        
        let seperateLine = XYCommonViews.creatCommonSeperateLine(pointY: addAdressBtn.frame.size.height - cmSizeFloat(1))
        addAdressBtn.addSubview(seperateLine)
        
        
        self.view.addSubview(addAdressBtn)
        
        
    }
    //MARK: - 新增地址响应
    @objc func addAdressBtnAct() {
        let newAdressVC = AddNewAdressVC()
        self.navigationController?.pushViewController(newAdressVC, animated: true)
    }
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:addAdressBtn.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - addAdressBtn.bottom), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }

        mainTabView.mj_header = XYRefreshHeader(refreshingBlock: { [unowned self] in
            self.service.refreshDeliveryAdressManagerListData(target: self)
            if self.mainTabView.mj_footer != nil {
                self.mainTabView.mj_footer.resetNoMoreData()
            }
        })
        
        mainTabView.showsVerticalScrollIndicator = false
        mainTabView.showsHorizontalScrollIndicator = false
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(AdressManageTabCell.self, forCellReuseIdentifier: "AdressManageTabCell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return adressManagerModel.adressCellModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  AdressManageTabCell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "AdressManageTabCell")
        if cell == nil {
            cell = AdressManageTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "AdressManageTabCell")
        }
        if let targetCell = cell as? AdressManageTabCell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: adressManagerModel.adressCellModelArr[indexPath.row], index: indexPath.row)
            return targetCell
        }else{
            return cell!
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.service.deleteDeliveryAdressRequest(deliveryAdressID: adressManagerModel.adressCellModelArr[indexPath.row].userAddressID, successAct: { [weak self] in
            
            self?.mainTabView.mj_header.beginRefreshing()
            
        }) {
            
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
