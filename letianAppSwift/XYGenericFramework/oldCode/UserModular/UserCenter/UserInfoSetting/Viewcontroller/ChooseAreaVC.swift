//
//  ChooseAreaVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/28.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class ChooseAreaVC: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    

    var topView:XYTopView!
    var mainTableView:UITableView!
    var chooseAreaModel:ChooseAreaModel!
    var tableViewDataArr:[Dictionary<String,[ChooseAreaCellModel]>] = Array()
    var cityCode:Int!
    var chooseAreaService:UserInfoSettingService =  UserInfoSettingService()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        chooseAreaService.areaRequestBycity(target: self, cityCode: cityCode)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 对数据进行处理
    
    func cityDataManage() {
        for areaModel in chooseAreaModel.areaModelArr {
            let areaFirstStr = areaModel.areaName.getChineseFirstWord()
            if tableViewDataArr.count == 0 {
                var dataDict: [String: [ChooseAreaCellModel]] = Dictionary()
                dataDict[areaFirstStr] = [areaModel]
                tableViewDataArr.append(dataDict)
            }else{
                
                for index in 0..<tableViewDataArr.count {
                    
                    if tableViewDataArr[index].keys.first == areaFirstStr {
                        var valuArr = tableViewDataArr[index].values.first!
                        valuArr.append(areaModel)
                        tableViewDataArr[index][areaFirstStr] = valuArr
                        break
                    }
                    
                    if index == tableViewDataArr.count - 1 {
                        var dataDict: [String: [ChooseAreaCellModel]] = Dictionary()
                        dataDict[areaFirstStr] = [areaModel]
                        tableViewDataArr.append(dataDict)
                    }
                    
                }
            }
            cmDebugPrint(areaFirstStr)
            cmDebugPrint(tableViewDataArr.count)
        }
        //按照拼音进行排序
        tableViewDataArr = tableViewDataArr.sorted { (dic1, dic2) -> Bool in
            if dic1.keys.first! < dic2.keys.first! {
                return true
            }else{
                return false
            }
        }
    }
    
    
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: #selector(backAction)))
        topView.titleLabel.text = "学校选择"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    //MARK: - 返回按钮响应
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func creatTableView(){
        
        
        
        mainTableView = UITableView(frame: CGRect(x:0 ,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - topView.bottom), style: .grouped)
        if #available(iOS 11, *) {
            mainTableView.contentInsetAdjustmentBehavior = .never
            mainTableView.estimatedRowHeight = 0
        }
        
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        
        mainTableView.separatorStyle = .none
        mainTableView.register(ChooseAreaTabCell.self, forCellReuseIdentifier: "ChooseAreaTabCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        self.view.addSubview(mainTableView)
    }
    
    
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewDataArr.count
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataArr[section].values.first!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ChooseAreaTabCell.cellHeight
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ChooseAreaTabCell")
        if cell == nil {
            cell = ChooseAreaTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "ChooseAreaTabCell")
        }
        if let targetCell = cell as? ChooseAreaTabCell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: tableViewDataArr[indexPath.section].values.first![indexPath.row])
            
            return targetCell
        }else{
            return cell!
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cmSizeFloat(25)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: cmSizeFloat(25)))
        sectionView.backgroundColor = cmColorWithString(colorName: "f1f2f3")
        let titleLabel = UILabel(frame: CGRect(x: cmSizeFloat(10), y: 0, width: SCREEN_WIDTH - cmSizeFloat(10)*2, height: cmSizeFloat(25)))
        titleLabel.font = cmSystemFontWithSize(15)
        titleLabel.textColor = MAIN_BLACK
        titleLabel.textAlignment = .left
        titleLabel.text = tableViewDataArr[section].keys.first!
        sectionView.addSubview(titleLabel)
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let lastVC = self.navigationController?.viewControllers[self.navigationController!.viewControllers.count - 2] as? AreaSettingVC {
            lastVC.userSettingInfoModel.selectedAreaModel = tableViewDataArr[indexPath.section].values.first![indexPath.row]
            lastVC.refreshSubviewsUI()
            self.navigationController?.popViewController(animated: true)
            
        }
        
        if let lastVC = self.navigationController?.viewControllers[self.navigationController!.viewControllers.count - 2] as? RegisterViewController {
            lastVC.settingInfoModel.selectedAreaModel = tableViewDataArr[indexPath.section].values.first![indexPath.row]
            lastVC.refreshSubviewsUI()
            self.navigationController?.popViewController(animated: true)
            
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
