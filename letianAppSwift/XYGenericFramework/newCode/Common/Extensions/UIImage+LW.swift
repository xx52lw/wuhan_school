//
//  LWImage+LW.swift
//  Loter-swift
//
//  Created by 张星星 on 2018/3/30.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import Kingfisher
// ==================================================================================================================
/// image拓展方法
extension UIImage {
    //MARK: 对Kingfisher的再次封装
    ///  对Kingfisher的再次封装
    class func imageUrlAndPlaceImage(imageView : UIImageView , stringUrl : String? , placeholdImage : UIImage, completionHandler: CompletionHandler? = nil) {
        var urlString = stringUrl
        if  urlString == nil {
            urlString = ""
        }
        let url = URL(string : urlString!)
        imageView.kf.setImage(with: url, placeholder: placeholdImage, options: nil, progressBlock: nil, completionHandler: completionHandler)
    }
    
    //MARK: 从bundle文件夹里面获取图片
    /// 从bundle文件夹里面获取图片
    class func imageFromeBundleFile(fileName : String, imageName : String) -> UIImage {
        let name = fileName + "/" + imageName
        return imageFromBundle(imageName: name)
    }
    //MARK: 从bundle获取图片
    /// 从bundle获取图片
    class func imageFromBundle(imageName: String) -> UIImage {
        let scale = NSInteger(UIScreen.main.scale)
        var name = "imageResources.bundle/\(imageName)@\(scale)x.png"
        var path = Bundle.main.path(forResource: name, ofType: nil)
        if path == nil {
            name = "imageResources.bundle/\(imageName)@2x.png"
            path = Bundle.main.path(forResource: name, ofType: nil)
            if path == nil {
                name = "imageResources.bundle/\(imageName).png"
                path = Bundle.main.path(forResource: name, ofType: nil)
                if path == nil {
                    name = "imageResources.bundle"
                    path = Bundle.main.path(forResource: name, ofType: nil)
                }
            }
        }
        let image = UIImage(contentsOfFile : path!)
        if (image != nil)  {
            return image!
        }
        return UIImage()
    }
    //MARK: 根据图片,返回一个拉伸后的图片
    ///  根据图片,返回一个拉伸后的图片
    class func imageStretchableImageName(imageName: String) -> UIImage {
        let image = UIImage(named: imageName)!
        let width = NSInteger(image.size.width * 0.5)
        let height = NSInteger(image.size.height * 0.5)
        return image.stretchableImage(withLeftCapWidth: width, topCapHeight: height)
    }
    //MARK: 获取颜色图片
    /// 获取颜色图片
    class func imageDrawWithColor(color : UIColor, size : CGSize) -> UIImage? {
        let rect = CGRect.init(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return colorImage
    }
    //MARK: 获取尺寸图片
    /// 获取尺寸图片
    class func imageMarginImage(size: CGSize , origionImage : UIImage) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let imageRect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        origionImage.draw(in: imageRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
        
    }
    //MARK: 绘制圆角图片 image 原始图片 size 返回图片尺寸
    /// 绘制圆角图片 image 原始图片 size 返回图片尺寸
    class func drawImageWithRoundedRect(_ image: UIImage? = nil, size : CGSize, cornerRadius: CGFloat,
                                         borderWidth: CGFloat = 0, borderColor: UIColor? = UIColor.clear) -> UIImage? {
        if (image == nil || size.width * size.height <= 0) {
            return UIImage()
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIBezierPath(roundedRect:rect, cornerRadius: cornerRadius).addClip()
        image?.draw(in: rect)
        if (borderWidth > 0) {
            context.setStrokeColor((borderColor?.cgColor)!);
            context.setLineWidth(borderWidth);
            
            let borderRect = CGRect(x: 0, y: 0,
                                    width: size.width, height: size.height)
            
            let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadius)
            borderPath.lineWidth = borderWidth * 2
            borderPath.stroke()
            context.addPath(borderPath.cgPath)
        }
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    //MARK: 绘制带光圈圆形图片 image 原始图片 size 返回图片尺寸 inColor内圈图片颜色 宽度width
    /// 绘制带光圈圆形图片 image 原始图片 size 返回图片尺寸 inColor内圈图片颜色 宽度width
    class func drawIconImage(image : UIImage?, size : CGSize, outColor : UIColor? = nil, borderWidth : CGFloat = 0.0) -> UIImage {
    
        if (image == nil || size.width * size.height <= 0) {
            return UIImage()
        }
        let center = CGPoint.init(x: size.width / 2, y: size.height / 2)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        var width1 = borderWidth
        var color = outColor
        if (outColor == nil) {
         width1 = 0.0
         color = UIColor.clear
        }
        context?.setStrokeColor((color?.cgColor)!)
        context!.setLineWidth(width1)
        context?.addArc(center: center, radius: center.x - width1, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        context?.drawPath(using: CGPathDrawingMode.stroke)
        let imageRect = CGRect.init(x: width1, y: width1, width: (center.x - width1) * 2, height: (center.x - width1) * 2)
        context?.addEllipse(in: imageRect)
        context?.clip()
        image?.draw(in: imageRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    //MARK: 旋转图片，正向
    /// 旋转图片，正向
    class func CGImageWithCorrectOrientation(_ image : UIImage) -> UIImage {
        
        if (image.imageOrientation == UIImage.Orientation.up) {
            return UIImage()
        }
        
        var transform : CGAffineTransform = CGAffineTransform.identity;
        
        switch (image.imageOrientation) {
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by: .pi / -2.0)
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2.0)
            break
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: .pi)
            break
        default:
            break
        }
        
        switch (image.imageOrientation) {
        case UIImage.Orientation.rightMirrored, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
            break
        case UIImage.Orientation.downMirrored, UIImage.Orientation.upMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
            break
        default:
            break
        }
        
        let contextWidth : Int
        let contextHeight : Int
        
        switch (image.imageOrientation) {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored,
             UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            contextWidth = (image.cgImage?.height)!
            contextHeight = (image.cgImage?.width)!
            break
        default:
            contextWidth = (image.cgImage?.width)!
            contextHeight = (image.cgImage?.height)!
            break
        }
        
        let context : CGContext = CGContext(data: nil, width: contextWidth, height: contextHeight,
                                            bitsPerComponent: image.cgImage!.bitsPerComponent,
                                            bytesPerRow: 0,
                                            space: image.cgImage!.colorSpace!,
                                            bitmapInfo: image.cgImage!.bitmapInfo.rawValue)!;
        
        context.concatenate(transform);
        context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: CGFloat(contextWidth), height: CGFloat(contextHeight)));
        
        let cgImage = context.makeImage();
        let newImage = UIImage.init(cgImage: cgImage!)
        
        return newImage;
    }
    
}
// ==================================================================================================================
