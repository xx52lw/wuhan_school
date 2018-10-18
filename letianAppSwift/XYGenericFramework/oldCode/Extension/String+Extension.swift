//
//  
//XYGenericFramework
//
//  Created by xiaoyi on 2017/6/9.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

extension String {
    //MARK: - 通过下标截取字符串
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex =   self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    //MARK: - 通过下标截取字符
    subscript (i: Int) -> Character {
        let index = self.index(self.startIndex, offsetBy: i)
        return self[index]
    }
    //MARK: - 通过起始位置截取到指定位置字符
    func subString(to i: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: i)
        return self.substring(to: index)
    }
    //MARK: - 通过指定位置截取到结束位置字符
    func subString(from i: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: i)
        return self.substring(from: index)
    }
}

extension String {
    func stringIsEmpty() -> Bool {
        if self.isEmpty {
            return true
        } else if self.characters.count <= 0 {
            return true
        } else {
            let string = self.trimmingCharacters(in: .whitespacesAndNewlines)
            if string.isEmpty {
                return true
            }
        }
        return false
    }
    
    func stringIsEmpty(shouldCleanWhiteSpace clean: Bool) -> Bool {
        if self.isEmpty {
            return true
        }
        
        if clean {
            let string = self.trimmingCharacters(in: .whitespacesAndNewlines)
            if string.isEmpty {
                return true
            }
        }
        
        return false
    }
    
    func stringIsEmpty(cleanCharacterSet characterSet: CharacterSet) -> Bool {
        if self.isEmpty {
            return true
        } else {
            let string = self.trimmingCharacters(in: characterSet)
            if string.isEmpty {
                return true
            }
        }
        return false
    }
}

extension String {
    //MARK: - 获取字符串高度
    func stringHeight(_ width: CGFloat, font: UIFont) -> CGFloat {
        
        let text = self as NSString
        let attri = [NSAttributedStringKey.font: font]
        let rect = text.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: attri, context: nil)
        return rect.height
    }
    //MARK: - 获取字符串宽度
    func stringWidth(_ height: CGFloat, font: UIFont) -> CGFloat {
        let text = self as NSString
        let attri = [NSAttributedStringKey.font: font]
        let rect = text.boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: attri, context: nil)
        return rect.width
    }
}

//MARK: - 字符判断
extension String{
    
    //MARK: -  转大写（1个字母）
    func transToBigCharacter() -> String {
        let char = self.unicodeScalars.first
        if (char?.value)! > 96 && (char?.value)! < 123{
            let big = UnicodeScalar((char?.value)!-32)?.escaped(asASCII: false)
            return big!
        }
        return self
    }
    
    //MARK: - 判断是否是数字
    public func isNumberOrNot() -> Bool{
        do{
            let regex = try NSRegularExpression(pattern: "^[0-9]+$", options: NSRegularExpression.Options.allowCommentsAndWhitespace)
            let matches = regex.matches(in: self, options:[], range: NSMakeRange(0, self.characters.count))
            if matches.first != nil {
                return true
            }
        }catch{
            return false
        }
        return false
    }
    
    //MARK: -  中文转换成拼音字母
    func transformToPinYin() -> String {
        let mutableString = NSMutableString(string: self)
        //把汉字转为拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        //去掉拼音的音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        //去掉空格
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    //MARK: - 提取汉字的首字母并大写
    func getChineseFirstWord() -> String {
        if self.transformToPinYin().characters.count > 0 {
        return self.transformToPinYin().subString(to: 1).transToBigCharacter()
        }else{
            return ""
        }
    }
    
    //MARK: -  大写转小写
    func transToSmallCharacters() -> String {
        var charStr = ""
        for char in self.unicodeScalars {
            if (char.value) > 64 && (char.value) < 91{
                let big = UnicodeScalar(char.value+32)?.escaped(asASCII: false)
                charStr += big!
            }else{
                charStr += char.description
            }
        }
        return charStr
    }
    
    
    //MARK: - 字符是否为字母
    
    func isCharacterOrNot() -> Bool {
        var characterBool = true
        for char in self.unicodeScalars {
            if (char.value > 64 && char.value < 91)||(char.value > 96 && char.value < 123) {
                characterBool  = true
            }else{
                characterBool  = false
            }
        }
        return characterBool
    }
    
    
    // MARK: - 验证是否为手机号码
    func isTelNumber()->Bool{
        let mobile = "^1((3[0-9]|4[57]|5[0-35-9]|7[03678]|8[0-9])\\d{8}$)"
        let  CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)"
        let  CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)"
        let  CT = "(^1(33|53|77|73|8[019])\\d{8}$)|(^1700\\d{7}$)"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: self) == true) || (regextestcm.evaluate(with: self)  == true) || (regextestct.evaluate(with: self) == true) || (regextestcu.evaluate(with: self) == true)){
            return true
        }else{
            return false
        }
    }
    
    //MARK: - 非严格意义的手机号码
    func isNotPerfectMatchTelNum()->Bool{
        let mobile = "^1(\\d{10}$)"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if (regextestmobile.evaluate(with: self) == true) {
            return true
        }else{
            return false
        }
    }
    
}





