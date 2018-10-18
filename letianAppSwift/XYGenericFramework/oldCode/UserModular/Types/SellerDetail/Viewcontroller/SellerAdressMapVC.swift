//
//  SellerAdressMapVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/3/16.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class SellerAdressMapVC: UIViewController,BMKMapViewDelegate {
    
    
    var topView:XYTopView!
    //基础地图
    var mapView:BMKMapView?
    //位置标注
    var sellerAnnotation:BMKPointAnnotation!
    //商家位置的geohash编码
    var sellerAdressGeoHashStr:String!
    //商家location
    var sellerLocation:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //将geohash转换为经纬度地址
        if  let location = Geohash.decode(sellerAdressGeoHashStr) {
            sellerLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        creatNavTopView()
        creatMapView()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).navigationTitleItem())
        topView.titleLabel.text = "商家地址"
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
        
        //定位到显示位置
        self.setMapShowView(showCoordinate: sellerLocation)
        
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
            
            sellerAnnotation =  BMKPointAnnotation()
            sellerAnnotation.coordinate = showCoordinate!
            mapView?.addAnnotation(sellerAnnotation)
            
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


