//
//  MapSearchResultVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/23.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class MapSearchResultVC: UIViewController,BMKPoiSearchDelegate,UITableViewDelegate,UITableViewDataSource {

    var topView:XYTopView!
    var mainTabView:UITableView!
    
    var searchWord:String!
    var service:MapCommonService = MapCommonService()
    //当前的城市搜索结果数组
    var currentResultModelArr:[NearbySearchResultModel] = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        creatNavTopView()
        if searchWord != nil{
        createPoiNearbySearch(keyWord: searchWord)
        }
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).rightStrBtnItem(target: self, action: #selector(searchAction), btnStr: "搜索", fontSize:15).searchTextFieldItem(placeholderStr: nil))
        topView.searchTextField.returnKeyType = .done
    }
    
    //MARK: - 搜索按钮
    @objc func searchAction() {
        if !(topView.searchTextField.text?.isEmpty)! {
            self.view.endEditing(true)
            createPoiNearbySearch(keyWord: topView.searchTextField.text!)
        }else{
            cmShowHUDToWindow(message: "搜索内容不能为空哦")
        }
    }
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - topView.bottom), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        
        
        
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(MapSearchResultCell.self, forCellReuseIdentifier: "MapSearchResultCell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - 创建城市搜索
    func  createPoiNearbySearch(keyWord:String) {
        
        //创建城市搜索选项
        let poiCitySearchOption = BMKCitySearchOption()
        poiCitySearchOption.keyword = keyWord
        //每页返回的结果最大数量
        poiCitySearchOption.pageCapacity = 20
        poiCitySearchOption.city = currentSelectedCity
        
        let poiCitySearch = XYBMKPoiSearch()
        poiCitySearch.searchKeyWord = keyWord


        //返回true则表示成功
        if   poiCitySearch.poiSearch(inCity: poiCitySearchOption) == true {
            poiCitySearch.delegate = self
        }else{
            cmDebugPrint("poiSearch失败")
            return
        }
    }
    
    //MARK: - 当前城市搜索代理
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        
        if errorCode == BMK_SEARCH_NO_ERROR {
            self.currentResultModelArr.removeAll()
            for poiInfo in poiResult.poiInfoList as! [BMKPoiInfo]
            {
                let model = NearbySearchResultModel()
                model.resultName = poiInfo.name
                model.resultAdress = poiInfo.address
                model.locationCor = poiInfo.pt
                self.currentResultModelArr.append(model)

            }
            
            if mainTabView != nil {
                mainTabView.reloadData()
            }else{
               self.creatMainTabView()
            }
            
        }else{
            cmShowHUDToWindow(message: "搜索内容失败")
        }
    }
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentResultModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  MapSearchResultCell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "MapSearchResultCell")
        if cell == nil {
            cell = MapSearchResultCell(style: UITableViewCellStyle.default, reuseIdentifier: "MapSearchResultCell")
        }
        if let targetCell = cell as? MapSearchResultCell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: currentResultModelArr[indexPath.row], index: indexPath.row)
            return targetCell
        }else{
            return cell!
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let chooseAdressGeoHashStr = Geohash.encode(latitude:currentResultModelArr[indexPath.row].locationCor.latitude , longitude: currentResultModelArr[indexPath.row].locationCor.longitude, 11)
        let navVCCount = self.navigationController!.viewControllers.count
        //根界面是主页，选择则更新主页地址信息及位置
        if  let rootVC = self.navigationController?.viewControllers.first! as? TakeOutFoodVC {
            service.updateDeliveryAdressRequest(AreaCode: getLoginInfo().areaCode!, Location: currentResultModelArr[indexPath.row].resultName, Geohash: chooseAdressGeoHashStr, successAct: { [weak self] in
                DispatchQueue.main.async {
                    currentSelectedAdress = self!.currentResultModelArr[indexPath.row].resultName
                    rootVC.mainTabView.mj_header.beginRefreshing()
                    self?.navigationController?.popToRootViewController(animated: true)
                }
                
                
            }) {
                
            }
        }

        
        //上一个界面是收货地址编辑页面
        if navVCCount >= 3 {
            if  let lastVC = self.navigationController?.viewControllers[navVCCount - 3] as? AddNewAdressVC {
                
                lastVC.submitModel.userAdress = self.currentResultModelArr[indexPath.row].resultName
                lastVC.submitModel.addressGeohash = Geohash.encode(latitude:currentResultModelArr[indexPath.row].locationCor.latitude , longitude: currentResultModelArr[indexPath.row].locationCor.longitude, 11)
                lastVC.refreshUI()
                self.navigationController?.popToViewController(lastVC, animated: true)
                
            }
        }

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
