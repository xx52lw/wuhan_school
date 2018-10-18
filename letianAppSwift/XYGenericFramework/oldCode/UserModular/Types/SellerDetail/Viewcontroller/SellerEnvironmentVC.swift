//
//  SellerEnvironmentVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/26.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class SellerEnvironmentVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    var topView:XYTopView!
    var mainTabView:UITableView!
    
    var imageUrlArr:[String] = Array()
    
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
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).navigationTitleItem())
        topView.titleLabel.text = "商家环境"
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
        mainTabView.register(SellerEnvironmentTabCell.self, forCellReuseIdentifier: "SellerEnvironmentTabCell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imageUrlArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  SellerEnvironmentTabCell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "SellerEnvironmentTabCell")
        if cell == nil {
            cell = SellerEnvironmentTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "SellerEnvironmentTabCell")
        }
        if let targetCell = cell as? SellerEnvironmentTabCell{
            targetCell.selectionStyle = .none
            targetCell.setModel(imageUrlStr: imageUrlArr[indexPath.row])
            if indexPath.row == imageUrlArr.count - 1{
                targetCell.seperateView.isHidden = true
            }else{
                targetCell.seperateView.isHidden = false
            }
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

