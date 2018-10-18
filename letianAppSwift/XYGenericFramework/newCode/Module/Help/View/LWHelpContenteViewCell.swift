//
//  LWHelpContenteViewCell.swift
//  LoterSwift
//
//  Created by 张星星 on 2018/10/14.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// =================================================================================================================================
// MARK: - 帮助视图cell
class LWHelpContenteViewCell: UITableViewCell {

    // MARK: 懒加载背景视图
    /// 背景视图
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: 懒加载头像图片
    /// 头像图片
    lazy var headerImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    // MARK: 懒加载昵称标签
    /// 昵称标签
    lazy var nickLabel: UILabel = {
        let label = UILabel()
        label.textColor = LWBlackColor1
        label.textAlignment = .left
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    // MARK: 懒加载学校标签
    /// 学校标签
    lazy var schoolLabel: UILabel = {
        let label = UILabel()
        label.textColor = LWBlackColor2
        label.textAlignment = .left
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    // MARK: 懒加载内容标签
    /// 内容标签
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    // MARK: 懒加载人民符号标签
    /// 人民符号标签
    lazy var rmbLabel: UILabel = {
        let label = UILabel()
        label.textColor = LWOrangeColor
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        return label
    }()
    
    // MARK: 懒加载价格标签
    /// 价格标签
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = LWOrangeColor
        label.textAlignment = .right
        label.backgroundColor = UIColor.clear
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        return label
    }()
    // MARK: 懒加载分割线视图
    /// 分割线视图
    lazy var sepLineView: UIView = {
        let view = UIView()
        view.backgroundColor = LWSepLineColor
        return view
    }()
    // MARK: 懒加载举报按钮
    /// 举报按钮
    lazy var reportBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitleColor(LWBlackColor2, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        btn.setImage(UIImage.init(named: "help_report"), for: .normal)
        return btn
    }()
    // MARK: 懒加载时间按钮
    /// 时间按钮
    lazy var timeBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitleColor(LWBlackColor2, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        btn.setImage(UIImage.init(named: "help_time"), for: .normal)
        return btn
    }()
    // MARK: 懒加载查看标签
    /// 查看标签
    lazy var checkLabel: UILabel = {
        let label = UILabel()
        label.textColor = LWBlueColor
        label.textAlignment = .right
        label.backgroundColor = UIColor.clear
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        return label
    }()
    
    /// cell宽度
    var cellWidth :CGFloat = 0.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        bgView.addSubview(headerImageView)
        bgView.addSubview(nickLabel)
        bgView.addSubview(schoolLabel)
        bgView.addSubview(rmbLabel)
        bgView.addSubview(priceLabel)
        bgView.addSubview(contentLabel)
        bgView.addSubview(sepLineView)
        bgView.addSubview(reportBtn)
        bgView.addSubview(timeBtn)
        bgView.addSubview(checkLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutViewSubviews()
    }
    // MARK: 创建cell
    class func createCell(tableView: UITableView, identifier: String) -> LWHelpContenteViewCell{
        var cell : LWHelpContenteViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as! LWHelpContenteViewCell?
        if cell == nil {
            cell = LWHelpContenteViewCell.init(style: .default, reuseIdentifier: identifier)
            cell?.cellWidth = tableView.frame.size.width
            cell?.backgroundColor = .clear
            cell?.selectionStyle = .none
        }
        return cell!
    }
    /// cell模型数据
    var cellModle : LWHelpContentModel! {
        
        didSet {
         layoutViewSubviews()
        }
    }
    
    ///布局子控件
    //MARK: - 布局子控件
    func layoutViewSubviews() {
        if cellModle == nil {
            return
        }
        // 白色背景
        var x :CGFloat = 0.0
        var y :CGFloat = 10.0
        var w :CGFloat = cellWidth
        var h :CGFloat = LWHelpContenteViewCell.calCellHeight(cellModel: cellModle, cellWidth: cellWidth) - y
        bgView.frame = CGRect.init(x: x, y: y, width: w, height: h)
        // 头像
        w = 40.0
        h = w
        x = 15.0
        y = 10.0
        headerImageView.frame = CGRect.init(x: x, y: y, width: w, height: h)
        headerImageView.layer.cornerRadius = h / 2.0
        headerImageView.layer.masksToBounds = true
        UIImage.imageUrlAndPlaceImage(imageView: headerImageView, stringUrl: cellModle.HeadImg, placeholdImage: UIImage.init(named: "tab_me")!)
        //价格
        var price = cellModle.Money
        if price.count > 2 {
           let prefix = String(price.prefix(price.count - 2))
           let suffix = String(price.suffix(2))
            price = prefix + "." + suffix
        }
        
        if cellModle.IfYJ {
            price = "议价"
        }
        let priceSize = LWUITools.sizeWithStringFont(price, font: priceLabel.font, maxSize: CGSize.init(width: 200, height: 200))
        w = priceSize.width
        x = bgView.frame.maxX - w - 15.0
        priceLabel.frame = CGRect.init(x: x, y: y, width: w, height: h)
        priceLabel.text = price
        // 人民币
        let rmb = "￥"
        w = LWUITools.sizeWithStringFont(rmb, font: rmbLabel.font, maxSize: CGSize.init(width: 200, height: 200)).width
        x = priceLabel.frame.minX - w
        rmbLabel.frame = CGRect.init(x: x, y: y, width: w, height: h)
        rmbLabel.text = rmb
        // 昵称
        h = headerImageView.frame.size.height / 2.0
        x = headerImageView.frame.maxX + 15.0
        w = rmbLabel.frame.minX - x - 5.0
        nickLabel.frame = CGRect.init(x: x, y: y, width: w, height: h)
        nickLabel.text = cellModle.NickName
        // 学校
        y = nickLabel.frame.maxY
        schoolLabel.frame = CGRect.init(x: x, y: y, width: w, height: h)
        schoolLabel.text = cellModle.AreaName
        // 内容
        x = headerImageView.frame.minX
        y = headerImageView.frame.maxY
        w = priceLabel.frame.maxX - x
        h = 40.0
        contentLabel.frame = CGRect.init(x: x, y: y, width: w, height: h)
        contentLabel.text = cellModle.MsgContent
        // 分割线
        h = 1.0
        y = contentLabel.frame.maxY - h
        sepLineView.frame = CGRect.init(x: x, y: y, width: w, height: h)
        // 查看
        let check = "查看"
        w = LWUITools.sizeWithStringFont(check, font: checkLabel.font, maxSize: CGSize.init(width: 200, height: 200)).width
        x = sepLineView.frame.maxX - w
        y = sepLineView.frame.maxY
        h = 30.0
        checkLabel.frame = CGRect.init(x: x, y: y, width: w, height: h)
        checkLabel.text = check
        // 举报按钮
        let report = " 举报" + cellModle.ComplainCount
        reportBtn.setTitle(report, for: .normal)
        reportBtn.sizeToFit()
        x = sepLineView.frame.minX
        w = reportBtn.frame.size.width
        reportBtn.frame = CGRect.init(x: x, y: y, width: w, height: h)
        // 时间按钮
        var time = " 有效时间:" + cellModle.EffectTime + "小时"
        if cellModle.UpdateDT.count >= 17  {
            var sepTime = NSString.init(string: cellModle.UpdateDT)
            sepTime = sepTime.replacingOccurrences(of: "T", with: " ") as NSString
            sepTime = sepTime.substring(with: NSRange.init(location: 5, length: 11)) as NSString
            time = " " + (sepTime as String) + time
        }
        timeBtn.setTitle(time, for: .normal)
        timeBtn.sizeToFit()
        x = reportBtn.frame.maxX + 10.0
        w = timeBtn.frame.size.width
        timeBtn.frame = CGRect.init(x: x, y: y, width: w, height: h)
        
    }
    ///计算cell高度
    //MARK: - 布局子控件
   class func calCellHeight(cellModel: LWHelpContentModel?, cellWidth: CGFloat) -> CGFloat {
        
        return 140.0
        
    }
    
}
// =================================================================================================================================
