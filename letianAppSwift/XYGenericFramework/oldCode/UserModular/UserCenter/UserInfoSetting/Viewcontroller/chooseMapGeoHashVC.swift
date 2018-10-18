//
//  chooseMapGeoHash.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/12/22.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class chooseMapGeoHashVC: UIViewController,BMKMapViewDelegate,BMKGeoCodeSearchDelegate {

    
    var topView:XYTopView!
    //基础地图
    var mapView:BMKMapView?
    //多边形
    var polygon:BMKPolygon!
    //已选择区域的标注
    var chooseAnnotation:BMKPointAnnotation!
    //已选择位置的geohash编码
    var chooseAdressGeoHashStr:String!
    //GEO反编码
    var geoSearch:BMKGeoCodeSearch?
    
    var selectedSchoolAdress:String!
    var selectedLocation:CLLocationCoordinate2D!
    
    //选择的学校或小区geohash数组
    var geohashStrArr:[String] = Array()
    var coords:[CLLocationCoordinate2D]  = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: #selector(backAct)).navigationTitleItem())
        topView.titleLabel.text = "校内地址选择"
    }
    
    
    @objc func  backAct() {
        
        if self.chooseAdressGeoHashStr != nil {
            if let lastVC =  self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as? AreaSettingVC {
                
                lastVC.userSettingInfoModel.geoHash = self.chooseAdressGeoHashStr
                self.creatReverseGeoCodeSearch(coordinate: selectedLocation)

            }
            
            if let lastVC =  self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as? RegisterViewController {
                lastVC.settingInfoModel.geoHash = self.chooseAdressGeoHashStr
                self.creatReverseGeoCodeSearch(coordinate: selectedLocation)
            }
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    //MARK: - 初始化地图
    func creatMapView(){
        //初始化地图
        mapView =  BMKMapView(frame: CGRect(x: 0, y: topView.frame.maxY, width:SCREEN_WIDTH , height: SCREEN_HEIGHT - topView.frame.maxY))
        //比例尺级别
        mapView?.zoomLevel = 15
        
        
        //是否展示定位图层
        mapView?.showsUserLocation = false
        mapView?.userTrackingMode = BMKUserTrackingModeFollow
        mapView?.showsUserLocation = true
        mapView?.delegate = self

        //定位到geohash数组的第一个位置
        if geohashStrArr.count > 0 {
            if  let location = Geohash.decode(geohashStrArr.first!) {
                let locationCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                self.setMapShowView(showCoordinate: locationCoordinate)
            }
        }
        
        polygon = BMKPolygon(coordinates: &coords, count: UInt(coords.count))
        mapView?.add(polygon)
        
        self.view.addSubview(mapView!)
        
        
        
    }
    
    //MARK: - 设置地图显示的点，比例尺级别，并显示
    func setMapShowView(showCoordinate:CLLocationCoordinate2D?){
        if showCoordinate != nil{
            //设置地图显示到第一个geohash的地点
            var showRegin = BMKCoordinateRegion()
            showRegin.center = showCoordinate!
            //设置中心点显示范围
            //houseRegin.span.latitudeDelta = 0.01
            // houseRegin.span.longitudeDelta = 0.01
            mapView?.region = showRegin
        }
    }
    
    
    
    //MARK: - 地图 delegate
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
        
        if chooseAnnotation != nil {
        mapView?.removeAnnotation(chooseAnnotation)
        }
        //重新添加新的标注
        chooseAnnotation =  BMKPointAnnotation()
        chooseAnnotation.coordinate = coordinate
        mapView?.addAnnotation(chooseAnnotation)
        
        //将位置进行hash编码
        self.chooseAdressGeoHashStr = Geohash.encode(latitude:coordinate.latitude , longitude: coordinate.longitude, 11)
        selectedLocation = coordinate
    }
    
    
    
    
    //MARK: - 创建反GEO搜索方法
    func creatReverseGeoCodeSearch(coordinate:CLLocationCoordinate2D){
        let  reverseGeoCodeSearchOption = BMKReverseGeoCodeOption()
        reverseGeoCodeSearchOption.reverseGeoPoint = coordinate
        
        //*TEST
        cmDebugPrint(coordinate.latitude)
        cmDebugPrint(coordinate.longitude)
        let geohashCode =  Geohash.encode(latitude: coordinate.latitude, longitude: coordinate.longitude, 11)
        
        cmDebugPrint(geohashCode)
        let cord =  Geohash.decode(geohashCode)
        cmDebugPrint(cord?.latitude)
        cmDebugPrint(cord?.longitude)
        //TEST*/
        
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
    
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            if let lastVC =  self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2 ] as? RegisterViewController {
                lastVC.settingInfoModel.schoolAdress = result.address
                cmDebugPrint(result.address)
                lastVC.refreshSubviewsUI()
                self.navigationController?.popViewController(animated: true)
            }
            
            if let lastVC =  self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2 ] as? AreaSettingVC {
                lastVC.userSettingInfoModel.schoolAdress = result.address
                cmDebugPrint(result.address)
                lastVC.refreshSubviewsUI()
                self.navigationController?.popViewController(animated: true)
            }
            
        }else{
            cmDebugPrint(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        tabBarController?.tabBar.isHidden = true
        
        mapView?.viewWillAppear()
        //mapView?.delegate = self
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView?.viewWillDisappear()
         mapView?.delegate = nil
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
