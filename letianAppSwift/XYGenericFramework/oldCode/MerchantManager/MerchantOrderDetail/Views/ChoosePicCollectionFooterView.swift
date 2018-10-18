//
//  ChoosePicCollectionFooterView.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/3/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class ChoosePicCollectionFooterView: UICollectionReusableView {
    
    let toside = cmSizeFloat(20)
    let btnViewHeight = cmSizeFloat(50)
    let btnHeight = cmSizeFloat(35)
    var updateBtn:UIButton!
    var service:MerchantOrderDetailService = MerchantOrderDetailService()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let updateBtnView = UIButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - toside*2, height: btnViewHeight))
        self.addSubview(updateBtnView)
        
        updateBtn  = UIButton(frame: CGRect(x: cmSizeFloat(10), y: btnViewHeight/2 - btnHeight/2, width: SCREEN_WIDTH - toside*2, height:btnHeight))
        updateBtn.setTitle("上传图片", for: .normal)
        updateBtn.setTitleColor(MAIN_WHITE, for: .normal)
        updateBtn.titleLabel?.font = cmSystemFontWithSize(15)
        updateBtn.layer.cornerRadius = cmSizeFloat(4)
        updateBtn.clipsToBounds = true
        updateBtn.backgroundColor = MAIN_GREEN
        updateBtn.addTarget(self, action: #selector(updateBtnAct), for: .touchUpInside)
        updateBtnView.addSubview(updateBtn)
        

    }
    
    
    @objc func updateBtnAct() {
        updateBtn.isEnabled = false
        if let currentVC = GetCurrentViewController() as? MerchantArbitrationEvidenceSubmitVC {
            service.uploadMerchantServicePic(userOrderID: currentVC.userOrderId, imageArr: currentVC.chooseImageArray, successAct: {
                cmShowHUDToWindow(message: "上传成功")
                let navVCCount = currentVC.navigationController!.viewControllers.count
                //直接返回到商家的订单列表
                if  let lastVC = currentVC.navigationController?.viewControllers[navVCCount - 3] as? MerchantOrderManageVC {
                    currentVC.navigationController?.popToViewController(lastVC, animated: true)
                }
                //currentVC.navigationController?.popViewController(animated: true)
            }, failureAct: { [weak self] in
                self?.updateBtn.isEnabled = true

            })
        }
        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
