//
//  LoadingAnimationView.swift
//  
//
//  Created by xiaoyi on 2017/7/12.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit



class XYLoadingAnimationView: UIView{

    
    //是否用于下拉刷新，用于网络加载时，加载完成会将View移除，默认用于网络加载
    var beUsedByRefreshHeader:Bool = false
    
    // 背景
    var loadMaskView:UIView!
    
    // 左
    var leftPoint:UIImageView!
    // 动画
    var leftAnimation:CAKeyframeAnimation!
    
    //中间
    var centerPoint:UIImageView!
    
    //右
    var rightPoint:UIImageView!
    //右动画
    var rightAnimation:CAKeyframeAnimation!
    //中间转换色
    var mainColor:UIColor = UIColor.white
    
    //计数
    var count:Float = 0
    //timer
    var timer:Timer!
    //开始动画标志位
    var startAnimation:Bool = false {
        didSet{
            if startAnimation == true {
                animationStart()
            }else{
                animationStop()
                if beUsedByRefreshHeader == false{
                leftPoint.layer.removeAllAnimations()
                rightPoint.layer.removeAllAnimations()
                self.removeFromSuperview()
                loadMaskView.removeFromSuperview()
                }
            }
        }
    }
    
    //MARK: - 暂停动画
    func animationStop(){
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        count = 0
    }
    
    //MARK: - 开始动画
    func animationStart(){
        
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .UITrackingRunLoopMode)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        
        leftPoint = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        leftPoint.layer.cornerRadius = 5
        leftPoint.layer.masksToBounds = true
        leftPoint.backgroundColor = cmColorWithString(colorName: "7FFFAA", alpha: 0.9)
        addSubview(leftPoint)
        rightPoint = UIImageView(frame: CGRect(x: 40, y: 0, width: 10, height: 10))
        rightPoint.layer.cornerRadius = 5
        rightPoint.layer.masksToBounds = true
        rightPoint.backgroundColor = cmColorWithString(colorName: "00BFFF", alpha: 0.9)
        addSubview(rightPoint)
        centerPoint = UIImageView(frame: CGRect(x: 20, y: 0, width: 10, height: 10))
        centerPoint.layer.cornerRadius = 5
        centerPoint.layer.masksToBounds = true
        centerPoint.backgroundColor = cmColorWithString(colorName: "F0E68C", alpha: 0.9)
        addSubview(centerPoint)
        loadMaskView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - STATUS_NAV_HEIGHT - TABBAR_HEIGHT))
        loadMaskView.backgroundColor = UIColor.clear
    }
    
    //MARK: - 配置动画并开始动画
    func startAnimationAction()  {
        leftAnimation = CAKeyframeAnimation(keyPath: "position")
        let value0 = NSValue.init(cgPoint: CGPoint(x: 5, y: 6))
        let value1 = NSValue.init(cgPoint: CGPoint(x: 25, y: 5))
        let value2 = NSValue.init(cgPoint: CGPoint(x: 45, y: 5))
        let value3 = NSValue.init(cgPoint: CGPoint(x: 25, y: 5))
        let value4 = NSValue.init(cgPoint: CGPoint(x: 5, y: 5))
        leftAnimation.values = [value0,value1,value2,value3,value4]
        leftAnimation.isRemovedOnCompletion = false
        leftAnimation.duration = 1.4
        leftAnimation.repeatCount = MAXFLOAT
        leftAnimation.repeatDuration = 0
        leftAnimation.fillMode = kCAFillModeForwards
        leftAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        leftPoint.layer.add(leftAnimation, forKey: "PostionAni")
        
        rightAnimation = CAKeyframeAnimation(keyPath: "position")
        let value5 = NSValue.init(cgPoint: CGPoint(x: 45, y: 5))
        let value6 = NSValue.init(cgPoint: CGPoint(x: 25, y: 5))
        let value7 = NSValue.init(cgPoint: CGPoint(x: 5, y: 5))
        let value8 = NSValue.init(cgPoint: CGPoint(x: 25, y: 5))
        let value9 = NSValue.init(cgPoint: CGPoint(x: 45, y: 5))
        rightAnimation.values = [value5,value6,value7,value8,value9]
        rightAnimation.duration = 1.4
        rightAnimation.repeatCount = MAXFLOAT
        rightAnimation.repeatDuration = 0
        rightAnimation.fillMode = kCAFillModeForwards
        rightAnimation.isRemovedOnCompletion = false
        rightAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        rightPoint.layer.add(rightAnimation, forKey: "PostionAni")
        //开始动画
        startAnimation = true
        
    }
    
    @objc func timerAction()  {
        //print("TIMER----run")
        
        //weak var weakMainColor = mainColor
        
        let totcount = Int(count*10)
        count += 0.1
        if totcount%3 == 0 {
            let lastCount = totcount/3
            if lastCount%2==1 {
                switch (lastCount/2)%2{
                case 0:
                    mainColor = centerPoint.backgroundColor!
                    centerPoint.backgroundColor = rightPoint.backgroundColor
                    rightPoint.backgroundColor = mainColor
                default:
                    mainColor = centerPoint.backgroundColor!
                    centerPoint.backgroundColor = leftPoint.backgroundColor
                    leftPoint.backgroundColor = mainColor
                }
            }
        }
    }
    
    deinit {
        cmFollowDebugPrint()
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
