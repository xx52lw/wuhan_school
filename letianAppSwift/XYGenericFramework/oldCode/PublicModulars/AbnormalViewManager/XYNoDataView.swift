//
//  XYNoDataView.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/10/2.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class XYNoDataView: UIView {

    private(set) var headerImageView: UIImageView!
    
    private(set) var titleLabel: UILabel!
    
    private(set) var detailLabel: UILabel!
    
    private(set) var clickButton: UIButton!
    
    var clickAction: (() -> ())?
    
    var showClickButton: Bool = false {
        didSet {
            if showClickButton == false {
                clickButton.isHidden = true
                
                clickButton.mas_remakeConstraints({ (make) in
                })
                
                detailLabel.mas_remakeConstraints({ [unowned self] (make) in
                    make?.width.mas_equalTo()(SCREEN_WIDTH - cmSizeFloat(130))
                    make?.centerX.mas_equalTo()(self.mas_centerX)
                    make?.top.mas_equalTo()(self.titleLabel.mas_bottom)?.offset()(cmSizeFloatHeight(15))
                })
            } else {
                clickButton.isHidden = false
                
                clickButton.mas_remakeConstraints({ [unowned self] (make) in
                    make?.top.mas_equalTo()(self.titleLabel.mas_bottom)?.offset()(cmSizeFloat(13))
                    make?.centerX.mas_equalTo()(self.mas_centerX)
                })
                
                detailLabel.mas_remakeConstraints({ [unowned self] (make) in
                    make?.width.mas_equalTo()(SCREEN_WIDTH - cmSizeFloat(130))
                    make?.centerX.mas_equalTo()(self.mas_centerX)
                    make?.top.mas_equalTo()(self.clickButton.mas_bottom)?.offset()(cmSizeFloatHeight(30))
                })
            }
        }
    }
    
    var clickTitle: String? = nil {
        didSet {
            clickButton.setTitle(clickTitle, for: .normal)
            clickButton.setTitle(clickTitle, for: .highlighted)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .background
        
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        headerImageView = UIImageView()
        headerImageView.image = #imageLiteral(resourceName: "noData")
        addSubview(headerImageView)
        headerImageView.mas_makeConstraints { [unowned self] (make) in
            make?.top.mas_equalTo()(self.mas_top)?.offset()(cmSizeFloatHeight(45))
            make?.centerX.mas_equalTo()(self.mas_centerX)
        }
        
        titleLabel = UILabel()
        titleLabel.textColor = MAIN_BLACK
        titleLabel.font = cmSystemFontWithSize(15)
        titleLabel.text = ""
        addSubview(titleLabel)
        titleLabel.mas_makeConstraints { [unowned self] (make) in
            make?.top.mas_equalTo()(self.headerImageView.mas_bottom)?.offset()(cmSizeFloatHeight(22))
            make?.centerX.mas_equalTo()(self.mas_centerX)
        }
        
        clickButton = UIButton(type: .custom)
        clickButton.addTarget(self, action: #selector(clickButtonAction(_:)), for: .touchUpInside)
//        clickButton.setBackgroundImage(UIImage(named: "nodata_icon_click"), for: .normal)
//        clickButton.setBackgroundImage(UIImage(named: "nodata_icon_click"), for: .highlighted)
        clickButton.setTitleColor(cmColorWithString(colorName:"ffffff"), for: .normal)
        clickButton.setTitleColor(cmColorWithString(colorName:"ffffff"), for: .highlighted)
        clickButton.titleLabel?.font = cmSystemFontWithSize(14)
        clickButton.isHidden = false
        addSubview(clickButton)
        
        detailLabel = UILabel()
        detailLabel.textColor = MAIN_GRAY
        detailLabel.numberOfLines = 0
        detailLabel.font = cmSystemFontWithSize(13)
        addSubview(detailLabel)
        detailLabel.mas_makeConstraints { [unowned self] (make) in
            make?.width.mas_equalTo()(SCREEN_WIDTH - cmSizeFloat(130))
            make?.centerX.mas_equalTo()(self.mas_centerX)
            make?.top.mas_equalTo()(self.titleLabel.mas_bottom)?.offset()(cmSizeFloatHeight(15))
        }
        
        let string = "没有找到符合要求的相关数据哦"
        let attriSting = NSMutableAttributedString(string: string)
        let attri = [NSAttributedStringKey.foregroundColor: MAIN_BLACK]
        attriSting.addAttributes(attri, range: NSRange(location: 0, length: 14))
        detailLabel.attributedText = attriSting
        detailLabel.textAlignment = .center
    }
    
    @objc private func clickButtonAction(_ sender: UIButton) {
        if let action = clickAction {
            action()
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
