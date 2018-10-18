//
//  XYAbnormalViewManager.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/10/2.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

enum AbnormalType {
    
    case none
    
    case noData
    
    case dataError
    
    case networkError
}
class XYAbnormalViewManager: NSObject {

    
    var refreshActionBlock: (() -> ())!
    
    private(set) var noDataView: XYNoDataView!
    
    private(set) var dataErrorView: XYDataErrorView!
    
    private(set) var networkErrorView: XYNetErrorView!
    
    private(set) var superView: UIView!
    
    private(set) var frame: CGRect!
    
    var abnormalType: AbnormalType = .none {
        didSet {
            switch abnormalType {
            case .none:
                noDataView.isHidden = true
                dataErrorView.isHidden = true
                networkErrorView.isHidden = true
                superView.sendSubview(toBack: noDataView)
                superView.sendSubview(toBack: networkErrorView)
                superView.sendSubview(toBack: dataErrorView)
            case .noData:
                noDataView.isHidden = false
                dataErrorView.isHidden = true
                networkErrorView.isHidden = true
                superView.bringSubview(toFront: noDataView)
            case .dataError:
                noDataView.isHidden = true
                dataErrorView.isHidden = false
                networkErrorView.isHidden = true
                superView.bringSubview(toFront: dataErrorView)
            case .networkError:
                noDataView.isHidden = true
                dataErrorView.isHidden = true
                networkErrorView.isHidden = false
                superView.bringSubview(toFront: networkErrorView)
            }
        }
    }
    
    init(frame: CGRect, in superView: UIView) {
        super.init()
        
        self.frame = frame
        
        self.superView = superView
        
        createAbnormalView()
    }
    
    private func createAbnormalView() {
        noDataView = XYNoDataView(frame: frame)
        noDataView.isHidden = true
        superView.addSubview(noDataView)
        
        dataErrorView = XYDataErrorView(frame: frame)
        dataErrorView.isHidden = true
        dataErrorView.refreshButton.addTarget(self, action: #selector(refreshAction(_:)), for: .touchUpInside)
        superView.addSubview(dataErrorView)
        
        networkErrorView = XYNetErrorView(frame: frame)
        networkErrorView.isHidden = true
        networkErrorView.refreshButton.addTarget(self, action: #selector(refreshAction(_:)), for: .touchUpInside)
        superView.addSubview(networkErrorView)
        
    }
    
    @objc private func refreshAction(_ sender: UIButton) {
        if refreshActionBlock != nil {
            refreshActionBlock()
        }
    }

    
}
