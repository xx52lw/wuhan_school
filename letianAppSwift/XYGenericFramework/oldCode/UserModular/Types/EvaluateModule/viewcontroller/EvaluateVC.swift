//
//  EvaluateVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/26.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class EvaluateVC: UIViewController {

    //评价View
    var evaluateView:EvaluateView!
    //网络异常空白页
    public var evaluateAbnormalView:XYAbnormalViewManager!

    let segmentBtnsViewHeight = cmSizeFloat(40)
    var service:EvaluateService =  EvaluateService()
    var evaluateModel:EvaluateModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.service.sellerEvaluatesDataRequest(target: self, merchantID: SellerDetailPageVC.commonMerchantID)

        // Do any additional setup after loading the view.
    }

    //MARK: - 创建评价View
    func creatEvaluateView(){
        evaluateView = EvaluateView(frame: CGRect(x:0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - STATUS_NAV_HEIGHT - segmentBtnsViewHeight), model: self.evaluateModel)
        evaluateView.mjfooterAct = {[weak self] in
            self?.service.sellerEvaluatesPullListData(target: self!, merchantID: SellerDetailPageVC.commonMerchantID)
        }
        self.view.addSubview(evaluateView.evaluateTableView)
    }
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y: 0 , width: SCREEN_WIDTH, height:  SCREEN_HEIGHT - STATUS_NAV_HEIGHT - segmentBtnsViewHeight), in: self.view)
        
        if isNetError == true{
            evaluateAbnormalView = abnormalView
            evaluateAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            evaluateAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.sellerEvaluatesDataRequest(target: self!, merchantID: SellerDetailPageVC.commonMerchantID)
            }
        }
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
