//
//  areaSettingVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2018/1/6.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class AreaSettingVC: UIViewController,UITextFieldDelegate {

    let strWidth = "定位位置".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
    let toside = cmSizeFloat(20)
    let subViewHeight = cmSizeFloat(50)
    let textSpace = cmSizeFloat(10)
    let showMoreImage = #imageLiteral(resourceName: "sellerDetailShowMore")

    var topView:XYTopView!
    var selectCityTextfield:UITextField!
    var selectSchoolTextfield:UITextField!
    //var locationTextfield:UITextField!
    
    var userSettingInfoModel:UserInfoSettingModel!
    var service:UserInfoModifyService = UserInfoModifyService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createSubviews()
        // Do any additional setup after loading the view.
    }

    
    //MARK: - 创建子View
    func createSubviews() {
        let titleLabel = UILabel(frame: CGRect(x: toside, y: topView.bottom, width: strWidth, height: subViewHeight))
        titleLabel.font = cmSystemFontWithSize(15)
        titleLabel.textColor = MAIN_BLACK
        titleLabel.textAlignment = .left
        titleLabel.text = "城市"
        self.view.addSubview(titleLabel)
        
        selectCityTextfield = UITextField(frame: CGRect(x: strWidth + toside + textSpace, y: titleLabel.top, width: SCREEN_WIDTH - strWidth - toside - textSpace , height: subViewHeight))
        selectCityTextfield.font = cmSystemFontWithSize(15)
        selectCityTextfield.textColor = MAIN_GRAY
        selectCityTextfield.textAlignment = .right
        
        let showMoreImageView = UIImageView(frame: CGRect(x: selectCityTextfield.frame.size.width - toside*2 - showMoreImage.size.width, y: subViewHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + toside*2, height: showMoreImage.size.height))
        showMoreImageView.image = showMoreImage
        showMoreImageView.contentMode = .scaleAspectFit
        selectCityTextfield.rightView = showMoreImageView
        selectCityTextfield.rightViewMode = .always
        selectCityTextfield.delegate = self
        selectCityTextfield.returnKeyType = .done
        if userSettingInfoModel.selectedCityModel.cityName != nil {
            selectCityTextfield.text = userSettingInfoModel.selectedCityModel.cityName
        }
        self.view.addSubview(selectCityTextfield)
        
        self.view.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: selectCityTextfield.bottom - cmSizeFloat(1)))

        //学校
        let schoolTitleLabel = UILabel(frame: CGRect(x: toside, y: selectCityTextfield.bottom, width: strWidth, height: subViewHeight))
        schoolTitleLabel.font = cmSystemFontWithSize(15)
        schoolTitleLabel.textColor = MAIN_BLACK
        schoolTitleLabel.textAlignment = .left
        schoolTitleLabel.text = "学校"
        self.view.addSubview(schoolTitleLabel)
        
        selectSchoolTextfield = UITextField(frame: CGRect(x: strWidth + toside + textSpace, y: schoolTitleLabel.top, width: SCREEN_WIDTH - strWidth - toside - textSpace , height: subViewHeight))
        selectSchoolTextfield.font = cmSystemFontWithSize(15)
        selectSchoolTextfield.textColor = MAIN_GRAY
        selectSchoolTextfield.textAlignment = .right
        
        let schoolShowMoreImageView = UIImageView(frame: CGRect(x: selectSchoolTextfield.frame.size.width - toside*2 - showMoreImage.size.width, y: subViewHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + toside*2, height: showMoreImage.size.height))
        schoolShowMoreImageView.image = showMoreImage
        schoolShowMoreImageView.contentMode = .scaleAspectFit
        selectSchoolTextfield.rightView = schoolShowMoreImageView
        selectSchoolTextfield.rightViewMode = .always
        selectSchoolTextfield.delegate = self
        selectSchoolTextfield.returnKeyType = .done
        if userSettingInfoModel.selectedAreaModel.areaName != nil {
            selectSchoolTextfield.text = userSettingInfoModel.selectedAreaModel.areaName
        }
        self.view.addSubview(selectSchoolTextfield)
        
        self.view.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: selectSchoolTextfield.bottom - cmSizeFloat(1)))
        
        /*
        //定位位置
        let locationTitleLabel = UILabel(frame: CGRect(x: toside, y: selectSchoolTextfield.bottom, width: strWidth, height: subViewHeight))
        locationTitleLabel.font = cmSystemFontWithSize(15)
        locationTitleLabel.textColor = MAIN_BLACK
        locationTitleLabel.textAlignment = .left
        locationTitleLabel.text = "定位位置"
        self.view.addSubview(locationTitleLabel)
        
        locationTextfield = UITextField(frame: CGRect(x: strWidth + toside + textSpace, y: locationTitleLabel.top, width: SCREEN_WIDTH - strWidth - toside - textSpace , height: subViewHeight))
        locationTextfield.font = cmSystemFontWithSize(15)
        locationTextfield.textColor = MAIN_GRAY
        locationTextfield.textAlignment = .right
        
        let locationShowMoreImageView = UIImageView(frame: CGRect(x: locationTextfield.frame.size.width - toside*2 - showMoreImage.size.width, y: subViewHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + toside*2, height: showMoreImage.size.height))
        locationShowMoreImageView.image = showMoreImage
        locationShowMoreImageView.contentMode = .scaleAspectFit
        locationTextfield.rightView = locationShowMoreImageView
        locationTextfield.rightViewMode = .always
        locationTextfield.delegate = self
        locationTextfield.returnKeyType = .done
        if userSettingInfoModel.schoolAdress != nil {
            locationTextfield.text = userSettingInfoModel.schoolAdress
        }
        self.view.addSubview(locationTextfield)
        */
        
        let backgroundView = UIView(frame: CGRect(x: 0, y: selectSchoolTextfield.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-selectSchoolTextfield.bottom))
        backgroundView.backgroundColor = seperateLineColor
        self.view.addSubview(backgroundView)
        
        let submitModifyBtn = UIButton(frame: CGRect(x: toside, y: selectSchoolTextfield.bottom + cmSizeFloat(20), width: SCREEN_WIDTH - toside*2, height: cmSizeFloat(40)))
        submitModifyBtn.setTitle("确认修改", for: .normal)
        submitModifyBtn.setTitleColor(MAIN_WHITE, for: .normal)
        submitModifyBtn.titleLabel?.font = cmSystemFontWithSize(15)
        submitModifyBtn.layer.cornerRadius = cmSizeFloat(4)
        submitModifyBtn.clipsToBounds = true
        submitModifyBtn.backgroundColor = MAIN_GREEN
        submitModifyBtn.addTarget(self, action: #selector(submitModifyBtnAct(sender:)), for: .touchUpInside)
        self.view.addSubview(submitModifyBtn)
        
    }
    
    //MARK: - 刷新UI
    func refreshSubviewsUI() {
//        if userSettingInfoModel.schoolAdress != nil {
//            locationTextfield.text = userSettingInfoModel.schoolAdress
//        }
        if userSettingInfoModel.selectedAreaModel.areaName != nil {
            selectSchoolTextfield.text = userSettingInfoModel.selectedAreaModel.areaName
        }
        if userSettingInfoModel.selectedCityModel.cityName != nil {
            selectCityTextfield.text = userSettingInfoModel.selectedCityModel.cityName
        }
    }
    
    
    //MARK: - 地图定位
    func mapLocationBtnAct() {
        
        if userSettingInfoModel.selectedAreaModel == nil {
            cmShowHUDToWindow(message: "请先选择城市和学校")
            return
        }
        
        let geohashVC = chooseMapGeoHashVC()
        geohashVC.geohashStrArr = userSettingInfoModel.selectedAreaModel.expressPoints.components(separatedBy: "-")
        self.navigationController?.pushViewController(geohashVC, animated: true)
        
    }
    
    
    //MARK: - 提交修改
    @objc func submitModifyBtnAct(sender:UIButton) {
        
        if userSettingInfoModel.selectedCityModel == nil{
            cmShowHUDToWindow(message: "您还没有选择城市哦")
            return
        }
        if userSettingInfoModel.selectedAreaModel == nil{
            cmShowHUDToWindow(message: "您还没有选择学校哦")
            return
        }
        /*
        if userSettingInfoModel.geoHash == nil || userSettingInfoModel.schoolAdress == nil{
            cmShowHUDToWindow(message: "请选择在校内的地址")
            return
        }
        */
        
        sender.isEnabled = false
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["AreaCode"] = userSettingInfoModel.selectedAreaModel.areaCode
        paramsDict["Address"] = userSettingInfoModel.schoolAdress
        //paramsDict["Geohash"] = userSettingInfoModel.geoHash
        
        service.updateAreaRequest(paramsDict: paramsDict, successAct: { [weak self] in
            cmShowHUDToWindow(message: "更新成功")
            DispatchQueue.main.async {
                sender.isEnabled = true
                if let lastVC =  self?.navigationController?.viewControllers[(self?.navigationController?.viewControllers.count)! - 2] as? UserAccountInfoVC {
                    lastVC.service.userInfoRequest(target: lastVC)
                }
                self?.navigationController?.popViewController(animated: true)
            }
        }) {
            sender.isEnabled = true
        }
        
        
        
    }
    
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "所属区域"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    
    //MARK: - delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n"{
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == selectCityTextfield {
            let selectCityVC = ChooseCityVC()
            selectCityVC.cityModelArr =  userSettingInfoModel.cityModelArr
            self.navigationController?.pushViewController(selectCityVC, animated: true)
            return false
        }else if textField ==  selectSchoolTextfield{
            if userSettingInfoModel.selectedCityModel == nil{
                cmShowHUDToWindow(message: "请先选择城市")
                return false
            }
            let selectAreaVC = ChooseAreaVC()
            selectAreaVC.cityCode =  userSettingInfoModel.selectedCityModel.cityCode
            self.navigationController?.pushViewController(selectAreaVC, animated: true)
            return false
        }
        /*
        else if textField ==  locationTextfield{
            mapLocationBtnAct()
            return false
        }
         */
        return true
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
