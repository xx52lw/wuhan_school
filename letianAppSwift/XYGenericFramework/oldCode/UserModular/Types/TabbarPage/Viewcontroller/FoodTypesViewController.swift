//
//  FoodTypesViewController.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/10/2.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

var foodTypeModel = FoodTypeModel()



class FoodTypesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var firstTypeTableView:UITableView!
    var secondTypeTableView:UITableView!
    var topView:XYTopView!
    var secondTypeModeArr:[FoodSecondTypeModel] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        creatFirstTypeTableView()
        creatSecondTypeTableView()
        
        // Do any additional setup after loading the view.
    }

    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().rightImageBtnItme(target: self, action: #selector(rightAct), btnImage: #imageLiteral(resourceName: "topviewSearch")))
        topView.titleLabel.text = "分类"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    @objc func rightAct(){
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    
    //MARK: - 创建一级TableView
    func creatFirstTypeTableView() {
        
        firstTypeTableView = UITableView(frame: CGRect(x: 0, y: topView.bottom, width: SCREEN_WIDTH/2, height: SCREEN_HEIGHT-topView.bottom-TABBAR_HEIGHT), style: .plain)
        if #available(iOS 11, *) {
            firstTypeTableView.contentInsetAdjustmentBehavior = .never
        }
        firstTypeTableView.showsVerticalScrollIndicator = false
        firstTypeTableView.showsHorizontalScrollIndicator = false
        firstTypeTableView.backgroundColor = .clear
        
        firstTypeTableView.register(FirstTypeTableCell.self, forCellReuseIdentifier: "FirstTypeTableCell")
        firstTypeTableView.separatorStyle = .none
                firstTypeTableView.delegate = self
        firstTypeTableView.dataSource = self
        self.view.addSubview(firstTypeTableView)
    }
    
    //MARK: - 创建二级TableView
    func creatSecondTypeTableView(){
        
        secondTypeTableView = UITableView(frame: CGRect(x: SCREEN_WIDTH/2, y: topView.bottom, width: SCREEN_WIDTH/2, height: SCREEN_HEIGHT-topView.bottom-TABBAR_HEIGHT), style: .plain)
        if #available(iOS 11, *) {
            secondTypeTableView.contentInsetAdjustmentBehavior = .never
        }
        secondTypeTableView.showsVerticalScrollIndicator = false
        secondTypeTableView.showsHorizontalScrollIndicator = false
        secondTypeTableView.backgroundColor = .clear
        
        secondTypeTableView.register(SecondTypeTableCell.self, forCellReuseIdentifier: "SecondTypeTableCell")
        secondTypeTableView.separatorStyle = .none
        secondTypeTableView.delegate = self
        secondTypeTableView.dataSource = self
        self.view.addSubview(secondTypeTableView)

    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == firstTypeTableView {
            return foodTypeModel.FoodTypeModelArr.count
        }else{
            return secondTypeModeArr.count
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == firstTypeTableView {
            return FirstTypeTableCell.cellHeight
        }else{
            return  SecondTypeTableCell.cellHeight
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == firstTypeTableView {
            var cell = tableView.dequeueReusableCell(withIdentifier: "FirstTypeTableCell")
            if cell == nil {
                cell = FirstTypeTableCell(style: UITableViewCellStyle.default, reuseIdentifier: "FirstTypeTableCell")
            }
            if let targetCell = cell as? FirstTypeTableCell{
                targetCell.selectionStyle = .none
                
                targetCell.setModel(model:foodTypeModel.FoodTypeModelArr[indexPath.row].keys.first!)
                
                
                return targetCell
            }else{
                return cell!
            }
        }else{
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "SecondTypeTableCell")
            if cell == nil {
                cell = SecondTypeTableCell(style: UITableViewCellStyle.default, reuseIdentifier: "SecondTypeTableCell")
            }
            if let targetCell = cell as? SecondTypeTableCell{
                targetCell.selectionStyle = .none
                
                targetCell.setModel(model:secondTypeModeArr[indexPath.row])
                
                
                return targetCell
            }else{
                return cell!
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if tableView == firstTypeTableView {
        
            secondTypeModeArr = foodTypeModel.FoodTypeModelArr[indexPath.row].values.first!
            self.secondTypeTableView.reloadData()
            
         }else if tableView == secondTypeTableView {
            let catVC =  CatsViewController()
            catVC.catName = secondTypeModeArr[indexPath.row].goodsSCatStr
            catVC.catID = secondTypeModeArr[indexPath.row].goodsSCatID
            catVC.goodsCatsUrl = secondTypeSellerUrl
            self.navigationController?.pushViewController(catVC, animated: true)
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        tabBarController?.tabBar.isHidden = false
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
