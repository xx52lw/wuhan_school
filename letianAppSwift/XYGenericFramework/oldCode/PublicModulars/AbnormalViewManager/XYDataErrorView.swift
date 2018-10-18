//
//  XYDataErrorView.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/10/2.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class XYDataErrorView: UIView {
    private(set) var headerImageView: UIImageView!
    
    private(set) var titleLabel: UILabel!
    
    private(set) var detailLabel: UILabel!
    
    private(set) var refreshButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .background
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        headerImageView = UIImageView()
        headerImageView.image = #imageLiteral(resourceName: "dataError")
        addSubview(headerImageView)
        headerImageView.mas_makeConstraints { [unowned self] (make) in
            make?.top.mas_equalTo()(self.mas_top)?.offset()(cmSizeFloat(100))
            make?.centerX.mas_equalTo()(self.mas_centerX)
        }
        
        titleLabel = UILabel()
        titleLabel.textColor = MAIN_BLACK
        titleLabel.text = "服务器繁忙，请稍后再试"
        titleLabel.font = cmSystemFontWithSize(15)
        addSubview(titleLabel)
        titleLabel.mas_makeConstraints { [unowned self] (make) in
            make?.top.mas_equalTo()(self.headerImageView.mas_bottom)?.offset()(cmSizeFloat(29))
            make?.centerX.mas_equalTo()(self.mas_centerX)
        }
        
        detailLabel = UILabel()
        detailLabel.text = "请点击刷新按钮刷新页面"
        detailLabel.font = cmSystemFontWithSize(13)
        detailLabel.textColor = MAIN_GRAY
        addSubview(detailLabel)
        detailLabel.mas_makeConstraints { [unowned self] (make) in
            make?.top.mas_equalTo()(self.titleLabel.mas_bottom)?.offset()(cmSizeFloat(15))
            make?.centerX.mas_equalTo()(self.mas_centerX)
        }
        
        refreshButton = UIButton(type: .custom)
        refreshButton.backgroundColor = MAIN_BLUE
        refreshButton.layer.cornerRadius = 5
//        refreshButton.setBackgroundImage(UIImage(named: "icon_refresh"), for: .normal)
//        refreshButton.setImage(UIImage(named: "refresh"), for: .normal)
        refreshButton.setTitle("刷新试试", for: .normal)
        refreshButton.titleLabel?.font = cmSystemFontWithSize(14)
        refreshButton.titleLabel?.textColor = MAIN_WHITE
        addSubview(refreshButton)
        refreshButton.mas_makeConstraints { [unowned self] (make) in
            make?.top.mas_equalTo()(self.detailLabel.mas_bottom)?.offset()(cmSizeFloat(35))
            make?.centerX.mas_equalTo()(self.mas_centerX)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
