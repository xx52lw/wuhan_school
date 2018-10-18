//
//  OrderReciverSetVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/18.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderReciverSetVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var topView:XYTopView!
    var mainTabView:UITableView!
    var addAdressBtn:UIButton!
    var seperateLine:UIView!
    
    //收货人数组
    var recieverArr:[OrderRecieverSetModel] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createAddBtn()
        creatMainTabView()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).navigationTitleItem())
        topView.titleLabel.text = "设置收货人"
    }
    
    func createAddBtn() {
        addAdressBtn = UIButton(frame: CGRect(x: 0, y: topView.bottom, width: SCREEN_WIDTH, height: cmSizeFloat(44)))
        addAdressBtn.setTitle("新增收货人", for: .normal)
        addAdressBtn.setTitleColor(MAIN_BLUE, for: .normal)
        addAdressBtn.titleLabel?.font = cmSystemFontWithSize(14)
        addAdressBtn.addTarget(self, action: #selector(addAdressBtnAct), for: .touchUpInside)
        self.view.addSubview(addAdressBtn)

        
        seperateLine = XYCommonViews.creatCustomSeperateLine(pointY: addAdressBtn.bottom, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
        self.view.addSubview(seperateLine)
        
        
        
        
    }
    
    //MARK: - 新增地址响应
    @objc func addAdressBtnAct() {
        let newAdressVC = OrderAddReciverVC()
        self.navigationController?.pushViewController(newAdressVC, animated: true)
    }
    
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:seperateLine.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - seperateLine.bottom), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        //        mainTabView.mj_header = XYRefreshHeader(refreshingBlock: { [weak self] in
        //            self?.service.refreshTakeFoodOutData(target: self!)
        //        })
        
        mainTabView.showsVerticalScrollIndicator = false
        mainTabView.showsHorizontalScrollIndicator = false
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(OrderRecieverCell.self, forCellReuseIdentifier: "OrderRecieverCell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recieverArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  OrderRecieverCell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "OrderRecieverCell")
        if cell == nil {
            cell = OrderRecieverCell(style: UITableViewCellStyle.default, reuseIdentifier: "OrderRecieverCell")
        }
        if let targetCell = cell as? OrderRecieverCell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: recieverArr[indexPath.row], index: indexPath.row)
            return targetCell
        }else{
            return cell!
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
        
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
