//
//  OderStatusDetailVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OderStatusDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var topView:XYTopView!
    var mainTabView:UITableView!
    
    
    var  statusModelArr:[StatusListModel] = Array()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        creatMainTabView()

        // Do any additional setup after loading the view.
    }

    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "订单状态"
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
        mainTabView.register(OrderStatusDetailCell.self, forCellReuseIdentifier: "OrderStatusDetailCell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statusModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let statusStrHeight = statusModelArr[indexPath.row].StatusDetail.stringHeight(SCREEN_WIDTH - cmSizeFloat(15+10)*2 , font: cmSystemFontWithSize(13))
        let cellHeight = cmSizeFloat(15)*2 + statusStrHeight + cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)) + cmSizeFloat(7) + cmSizeFloat(15)
        return  cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "OrderStatusDetailCell")
        if cell == nil {
            cell = OrderStatusDetailCell(style: UITableViewCellStyle.default, reuseIdentifier: "OrderStatusDetailCell")
        }
        if let targetCell = cell as? OrderStatusDetailCell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: statusModelArr[indexPath.row])
            return targetCell
        }else{
            return cell!
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
