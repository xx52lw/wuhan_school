//
//  LWTextField.swift
//  LoterSwift
//
//  Created by liwei on 2018/9/3.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// =================================================================================================================================
// MARK: - 创建带占位文字的输入框代理属性
protocol LWTextFieldDelegate :NSObjectProtocol {
    /// 输入框内容改变的代理方法
    func textFielfChange(view : LWTextField ,changeString: String)
}
// =================================================================================================================================
/// 创建带占位文字的输入框
class LWTextField: UIView {

    /// 代理属性
    weak var delegate : LWTextFieldDelegate?
    /// 输入框（暴露在外边，用于灵活设置）
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.clear
        tf.textAlignment = NSTextAlignment.left
        return tf
    }()
    /// 占位文字(暴露在外边，用于灵活设置）
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    // MARK: 创建视图
    /// 创建视图 frame 大小位置 placeholderString占位文字,默认占位文字是浅灰色，
    public class func createPlaceholderTextField(_ frame: CGRect, placeholderString : String) -> LWTextField {
        let view = LWTextField.init(frame: frame)
        // 添加子控件
        view.addSubview(view.placeholderLabel)
        view.addSubview(view.textField)
        // 设置子控件
        view.placeholderLabel.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        view.placeholderLabel.text = placeholderString
        view.placeholderLabel.textColor = UIColor.lightGray
        view.textField.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        view.textField.addTarget(view, action: #selector(textFielfChange), for: UIControl.Event.editingChanged)
        view.textField.textColor = UIColor.black
        return view
    }
    /// 输入框内容改变
    @objc func textFielfChange() {
       
        guard let textFieldString = textField.text
        else {
            placeholderLabel.isHidden = true
            delegate?.textFielfChange(view: self, changeString: "")
            return
        }
        if textFieldString.count > 0 {
            placeholderLabel.isHidden = true
            delegate?.textFielfChange(view: self, changeString: textFieldString)
        }
        else {
            placeholderLabel.isHidden = false
            delegate?.textFielfChange(view: self, changeString: "")
        }
    }
}

// =================================================================================================================================
