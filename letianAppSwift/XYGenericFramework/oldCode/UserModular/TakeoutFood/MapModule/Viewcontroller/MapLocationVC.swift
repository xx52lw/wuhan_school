//
//  MapLocationVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/21.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class MapLocationVC: UIViewController,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,UITableViewDelegate,UITableViewDataSource{

    
    var topView:XYTopView!
    var chooseAnnotation:BMKPointAnnotation!
    //多边形
    var polygon:BMKPolygon!
    var coords:[CLLocationCoordinate2D]  = Array()

    var mainTabView:UITableView!
    
    //基础地图
    var mapView:BMKMapView?
    //定位
    var mapLocService:BMKLocationService?
    //当前位置
    var houseRegin:BMKCoordinateRegion!
    //GEO反编码
    var geoSearch:BMKGeoCodeSearch?
    //地图附近搜索
    var poiNearbySearch:BMKPoiSearch?
    //已选的geohash地址
    var selectedGeohashLocation:CLLocationCoordinate2D!
    //重新选择位置的geohash编码
    var chooseAdressGeoHashStr:String!
    //当前已选择的Geohash
    var currentSelectedGeoHashStr:String!
    
    //当前的周边结果数组
    var currentResultModelArr:[NearbySearchResultModel] = Array()
    var geohashStrArr:[String] = Array()
    
    //当前定位的元素model
    var currentNearbySearchResultModel:NearbySearchResultModel!
    
    
    var currentSelectedTag:Int = 0
    var service:MapCommonService = MapCommonService()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
        geohashStrArr = getLoginInfo().areaGeoHashStr!.components(separatedBy: "-")
        //将geohash转换为经纬度地址
        for geohashStr in geohashStrArr {
            if  let location = Geohash.decode(geohashStr) {
                let locationCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                self.coords.append(locationCoordinate)
            }
            
        }
        creatNavTopView()
        creatMapView()
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
            let searchResultVC = MapSearchResultVC()
            searchResultVC.searchWord = topView.searchTextField.text
            self.navigationController?.pushViewController(searchResultVC, animated: true)
            self.view.endEditing(true)
        }else{
            cmShowHUDToWindow(message: "搜索内容不能为空哦")
        }
        
    }
    
    
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:mapView!.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - mapView!.bottom), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(MapLocationCell.self, forCellReuseIdentifier: "MapLocationCell")
        
        self.view.addSubview(mainTabView)
    }
    
    
    
    
    //MARK: - 初始化地图
    func creatMapView(){
        //初始化地图
        mapView =  BMKMapView(frame: CGRect(x: 0, y: topView.frame.maxY, width:SCREEN_WIDTH , height: (SCREEN_HEIGHT - topView.frame.maxY)/2))
        //比例尺级别
        mapView?.zoomLevel = 19
        
        
        //是否展示定位图层
        mapView?.showsUserLocation = false
        mapView?.userTrackingMode = BMKUserTrackingModeFollow
        mapView?.showsUserLocation = true

        //定位
        mapLocService = BMKLocationService()
        
        if CLLocationManager.authorizationStatus() == .denied {
            if CLLocationManager.locationServicesEnabled(){
                //print("定位开启,但被拒绝")
                let locationAlertVC = UIAlertController(title: "开启定位", message:"是否前往开启定位功能？" , preferredStyle: .alert)
                let okAction = UIAlertAction(title: "立即开启", style: .default, handler: { (action) in
                    UIApplication.shared.openURL(URL(string:"prefs:root=LOCATION_SERVICES")!)
                })
                locationAlertVC.addAction(okAction)
                
                let alertActCancel = UIAlertAction(title: "取消", style: .cancel, handler:{ (action) in
                    
                })
                locationAlertVC.addAction(alertActCancel)
                self.present(locationAlertVC, animated: true, completion: nil)
            }
            
        }else{
            //如果已经打开了定位功能，则进行定位
            mapLocService?.delegate = self
            mapLocService?.startUserLocationService()
            
        }
        //如果为新增收货地址，则currentSelectedGeoHashStr为nil
        if currentSelectedGeoHashStr != nil {
            //显示GeoHash位置
            if  let location = Geohash.decode(currentSelectedGeoHashStr) {
                let locationCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                self.setMapShowView(showCoordinate: locationCoordinate)
            }
            //画电子围栏
            polygon = BMKPolygon(coordinates: &coords, count: UInt(coords.count))
            mapView?.add(polygon)
        }else{
            if  let location = Geohash.decode(geohashStrArr.first!) {
                let locationCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                self.setMapShowView(showCoordinate: locationCoordinate)
            }
        }
        self.view.addSubview(mapView!)

    }
    
    
    //MARK: - 设置地图显示的点，比例尺级别，并显示
    func setMapShowView(showCoordinate:CLLocationCoordinate2D?){
        if showCoordinate != nil{
            selectedGeohashLocation = showCoordinate!
            //设置地图显示到定位的地点
            var showRegin = BMKCoordinateRegion()
            showRegin.center = showCoordinate!
            //设置中心点显示范围
            //houseRegin.span.latitudeDelta = 0.01
            // houseRegin.span.longitudeDelta = 0.01
            mapView?.region = showRegin
            
            chooseAnnotation =  BMKPointAnnotation()
            chooseAnnotation.coordinate = showCoordinate!
            mapView?.addAnnotation(chooseAnnotation)
            
        }
    }
    
    /*
    //MARK: - 创建附近搜索
    func  createPoiNearbySearch(location:CLLocationCoordinate2D,keyWord:String) {

        //创建附近搜索选项
        let poiSearchNearbyOption = BMKNearbySearchOption()
        poiSearchNearbyOption.location = location
        //搜索半径单位：米
        poiSearchNearbyOption.radius = 100
        poiSearchNearbyOption.keyword = keyWord
        //每页返回的结果最大数量
        poiSearchNearbyOption.pageCapacity = 20


        let poiNearbySearch = XYBMKPoiSearch()
        poiNearbySearch.searchKeyWord = keyWord
        //返回true则表示成功
        if   poiNearbySearch.poiSearchNear(by: poiSearchNearbyOption) == true {
            poiNearbySearch.delegate = self
        }else{
            cmDebugPrint("poiSearch失败")
            return
        }
    }
    */
    
    
    //MARK: - 地图定位代理实现
    func didUpdate(_ userLocation: BMKUserLocation!) {
        
        //根据定位的地理位置经纬度获取当前的位置
        self.creatReverseGeoCodeSearch(coordinate: userLocation.location.coordinate)
        //关闭定位
        mapLocService?.stopUserLocationService()
        

        
    }
    //MARK: - 创建反GEO搜索方法
    func creatReverseGeoCodeSearch(coordinate:CLLocationCoordinate2D){
        let  reverseGeoCodeSearchOption = BMKReverseGeoCodeOption()
        reverseGeoCodeSearchOption.reverseGeoPoint = coordinate
        
        
        geoSearch = BMKGeoCodeSearch()
        //根据经纬度获得位置，返回true则表示成功
        if   geoSearch?.reverseGeoCode(reverseGeoCodeSearchOption) == true {
            geoSearch?.delegate = self
        }else{
            cmDebugPrint("反GEO失败")
            return
        }
    }
    
    //MARK: - 反GEO搜索代理方法
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            currentSelectedCity = getLoginInfo().selectedCity!//result.addressDetail.city
            
            if currentNearbySearchResultModel == nil {
                if result.poiList.count > 0 {
                    if let poiInfo = result.poiList[0] as? BMKPoiInfo {
                        currentNearbySearchResultModel = NearbySearchResultModel()
                        currentNearbySearchResultModel.resultAdress = poiInfo.address
                        currentNearbySearchResultModel.resultName = poiInfo.name
                        currentNearbySearchResultModel.locationCor = poiInfo.pt
                        self.currentResultModelArr.append(currentNearbySearchResultModel)
                        
                        //首次时需加载对应的geohash位置Poi
                        if currentSelectedGeoHashStr != nil {
                            if  let location = Geohash.decode(currentSelectedGeoHashStr) {
                                let locationCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                                refreshPoiSearchInfo(coordinate: locationCoordinate)
                            }
                        }else{
                            if  let location = Geohash.decode(geohashStrArr.first!) {
                                let locationCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                                refreshPoiSearchInfo(coordinate:locationCoordinate)
                            }
                        }
                    }
                    
                }
            }else {
                self.currentResultModelArr.append(currentNearbySearchResultModel)
                for poiItem in result.poiList {
                    if let poiInfo = poiItem as? BMKPoiInfo {
                        let poiResultModel = NearbySearchResultModel()
                        poiResultModel.resultAdress = poiInfo.address
                        poiResultModel.resultName = poiInfo.name
                        poiResultModel.locationCor =  poiInfo.pt
                        self.currentResultModelArr.append(poiResultModel)
                    }
                }
                
            }
            
            if mainTabView == nil {
                creatMainTabView()
            }else{
                mainTabView.reloadData()
            }
            
        }else{
            cmDebugPrint(error)
        }
    }
    

    
    
    //根据点画区域
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if overlay is BMKPolygon {
            let polygonView = BMKPolygonView(overlay: overlay)
            polygonView?.strokeColor = cmColorWithString(colorName: "123456")
            polygonView?.fillColor = cmColorWithString(colorName: MAIN_BLUE_STR, alpha: 0.2)
            polygonView?.lineWidth = 2.0
            polygonView?.lineDash = true
            return polygonView
            
        }
        return nil
    }
    
    //MARK: - 地图点击事件监听
    func mapView(_ mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        cmDebugPrint(coordinate)
        
//        if currentSelectedGeoHashStr != nil {
//            if BMKPolygonContainsCoordinate(coordinate, &coords, UInt(coords.count)) == false {
//                cmShowHUDToWindow(message: "当前选择位置不在指定区域内")
//                return
//            }
//        }
        
        if chooseAnnotation != nil {
            mapView?.removeAnnotation(chooseAnnotation)
        }
        //重新添加新的标注
        chooseAnnotation =  BMKPointAnnotation()
        chooseAnnotation.coordinate = coordinate
        mapView?.addAnnotation(chooseAnnotation)
        
        //将位置进行hash编码
        self.chooseAdressGeoHashStr = Geohash.encode(latitude:coordinate.latitude , longitude: coordinate.longitude, 11)
        selectedGeohashLocation = coordinate
        refreshPoiSearchInfo(coordinate: coordinate)
        

    }
    
    
    //MARK: - 刷新选择位置的周边信息
    func refreshPoiSearchInfo(coordinate:CLLocationCoordinate2D){
        self.currentResultModelArr.removeAll()
        creatReverseGeoCodeSearch(coordinate:coordinate)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentResultModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  MapLocationCell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "MapLocationCell")
        if cell == nil {
            cell = MapLocationCell(style: UITableViewCellStyle.default, reuseIdentifier: "MapLocationCell")
        }
        if let targetCell = cell as? MapLocationCell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: currentResultModelArr[indexPath.row], index: indexPath.row)
            return targetCell
        }else{
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chooseAdressGeoHashStr = Geohash.encode(latitude:currentResultModelArr[indexPath.row].locationCor.latitude , longitude: currentResultModelArr[indexPath.row].locationCor.longitude, 11)
        
        let navVCCount = self.navigationController!.viewControllers.count
        //上一个界面时主页，选择则更新主页地址信息及位置
        if  let lastVC = self.navigationController?.viewControllers[navVCCount - 2] as? TakeOutFoodVC {
            
            service.updateDeliveryAdressRequest(AreaCode: getLoginInfo().areaCode!, Location: currentResultModelArr[indexPath.row].resultName, Geohash: self.chooseAdressGeoHashStr, successAct: { [weak self] in
                DispatchQueue.main.async {
                    currentSelectedAdress = self!.currentResultModelArr[indexPath.row].resultName
                    self?.navigationController?.popViewController(animated: true)
                    lastVC.mainTabView.mj_header.beginRefreshing()
                }
                
                
            }) {
                
            }
        }

        //上一个界面是收货地址编辑页面
        if  let lastVC = self.navigationController?.viewControllers[navVCCount - 2] as? AddNewAdressVC {
            
            lastVC.submitModel.userAdress = self.currentResultModelArr[indexPath.row].resultName
            lastVC.submitModel.addressGeohash = Geohash.encode(latitude:currentResultModelArr[indexPath.row].locationCor.latitude , longitude: currentResultModelArr[indexPath.row].locationCor.longitude, 11)
            
            lastVC.refreshUI()
            self.navigationController?.popViewController(animated: true)
            
        }

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        tabBarController?.tabBar.isHidden = true
        
        mapView?.viewWillAppear()
        mapView?.delegate = self
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView?.viewWillDisappear()
        mapView?.delegate = nil
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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


class XYBMKPoiSearch: BMKPoiSearch {
    var searchKeyWord = ""
    override init() {
        super.init()
    }
}

