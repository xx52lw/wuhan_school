//
//  GoodsPromotionTableViewController.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/31.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class GoodsPromotionTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {

    let segmentBtnsViewHeight = cmSizeFloat(40)
    
    
    //网络异常空白页
    public var promotionAbnormalView:XYAbnormalViewManager!
    
    var canScroll:Bool = false
    
    var promotionModel:GoodsPromotionModel =  GoodsPromotionModel()
    
    var service:GoodsPromotionService =  GoodsPromotionService()
    var tableFooterView:UIView!
    var mainTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.sellerPromotionDataRequest(target: self, merchantID: SellerDetailPageVC.commonMerchantID)

        NotificationCenter.default.addObserver(self, selector: #selector(acceptMsg(notification:)), name: NSNotification.Name(rawValue: "Home_Go_Top"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMsg(notification:)), name: NSNotification.Name(rawValue: "Home_Leave_Top"), object: nil)
    }

    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y: 0 , width: SCREEN_WIDTH, height:  SCREEN_HEIGHT - STATUS_NAV_HEIGHT - segmentBtnsViewHeight), in: self.view)
        
        if isNetError == true{
            promotionAbnormalView = abnormalView
            promotionAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            promotionAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.sellerPromotionDataRequest(target: self!, merchantID: SellerDetailPageVC.commonMerchantID)
            }
        }
    }
    
    
    //MARK: - 监听通知
    @objc   func acceptMsg(notification:Notification) {
        let notificationName = notification.name
        if notificationName.rawValue == "Home_Go_Top"  {
            let userInfo = notification.userInfo
            let canscroll = userInfo!["canScroll"] as! String
            if canscroll == "1" {
                self.canScroll = true
                
            }
        }else if notificationName.rawValue == "Home_Leave_Top"  {
            mainTableView.contentOffset = CGPoint.zero
            self.canScroll = false;
        }
    }
    
    func creatTableView(){
        creatSeciotnFooter()
        
        mainTableView = UITableView(frame: CGRect(x:0 ,y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - segmentBtnsViewHeight - STATUS_NAV_HEIGHT), style: .plain)
        if #available(iOS 11, *) {
            mainTableView.contentInsetAdjustmentBehavior = .never
            mainTableView.estimatedRowHeight = 0
        }
        if promotionModel.promotionArr.count > 0 {
            mainTableView.tableFooterView = tableFooterView
        }
        mainTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        
        mainTableView.separatorStyle = .none
        mainTableView.delegate = self
        mainTableView.dataSource = self
    
        mainTableView.register(GoodsPromotionTabCell.self, forCellReuseIdentifier: "GoodsPromotionTabCell")

        self.view.addSubview(mainTableView)
    }
    
    func creatSeciotnFooter(){
        let lableSpaceHeight = cmSizeFloat(7)
        let seperateLineHeight = cmSizeFloat(7)
        let promotionTypeToside = cmSizeFloat(20)
        let promotionTitleHeight = cmSizeFloat(50)
        let footerViewHeight = (cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)) + CGFloat(4))  * CGFloat(promotionModel.promotionArr.count) + lableSpaceHeight*CGFloat(promotionModel.promotionArr.count+1) + seperateLineHeight + promotionTitleHeight
        
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: footerViewHeight))
        tableFooterView.backgroundColor = .white
        
        let sperateLine = XYCommonViews.creatCustomSeperateLine(pointY: 0, lineWidth:SCREEN_WIDTH , lineHeight: seperateLineHeight)
        tableFooterView.addSubview(sperateLine)
        
        
        let promotionTitleLabel = UILabel(frame: CGRect(x: promotionTypeToside, y: sperateLine.bottom, width: SCREEN_WIDTH - promotionTypeToside*2 , height: promotionTitleHeight))
        promotionTitleLabel.font = cmBoldSystemFontWithSize(15)
        promotionTitleLabel.textColor = MAIN_BLACK
        promotionTitleLabel.textAlignment = .left
        promotionTitleLabel.text = "商家活动"
        tableFooterView.addSubview(promotionTitleLabel)
        
        let detailInfosperateLine = XYCommonViews.creatCustomSeperateLine(pointY: promotionTitleLabel.bottom - cmSizeFloat(1), lineWidth:SCREEN_WIDTH , lineHeight: cmSizeFloat(1))
        detailInfosperateLine.frame.origin.x = promotionTypeToside
        detailInfosperateLine.frame.size.width = SCREEN_WIDTH - promotionTypeToside*2
        tableFooterView.addSubview(detailInfosperateLine)
        
        for index in 0..<promotionModel.promotionArr.count {
            //优惠分类
            let promotionTypeLabelWidth = cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)) + CGFloat(4)
            let promotionTypeLabel =  UILabel(frame: CGRect(x: promotionTypeToside, y: detailInfosperateLine.bottom  + lableSpaceHeight + ( promotionTypeLabelWidth + lableSpaceHeight)  * CGFloat(index), width: promotionTypeLabelWidth, height: promotionTypeLabelWidth))
                    promotionTypeLabel.font = cmSystemFontWithSize(13)
                    promotionTypeLabel.textColor = .white
                    promotionTypeLabel.textAlignment = .center
                    promotionTypeLabel.layer.cornerRadius = CGFloat(4)
                    promotionTypeLabel.clipsToBounds = true
            tableFooterView.addSubview(promotionTypeLabel)
            //具体优惠信息
            let promotionInfoLabel =  UILabel(frame: CGRect(x: promotionTypeLabel.right + cmSizeFloat(5), y: promotionTypeLabel.frame.origin.y, width: SCREEN_WIDTH -  promotionTypeToside*2 - promotionTypeLabelWidth - cmSizeFloat(5), height: promotionTypeLabelWidth))
                promotionInfoLabel.font = cmSystemFontWithSize(14)
                promotionInfoLabel.textColor = MAIN_BLACK2
                promotionInfoLabel.textAlignment = .left
                promotionInfoLabel.text = promotionModel.promotionArr[index].values.first!
            tableFooterView.addSubview(promotionInfoLabel)
            
            switch promotionModel.promotionArr[index].keys.first! {
            case 1:
                promotionTypeLabel.text =   "积"
                promotionTypeLabel.backgroundColor = globalPromotionCorlorArr[0]
                break
            case 2:
                promotionTypeLabel.text =   "新"
                promotionTypeLabel.backgroundColor =  globalPromotionCorlorArr[1]
                break
            case 3:
                promotionTypeLabel.text =   "免"
                promotionTypeLabel.backgroundColor = globalPromotionCorlorArr[2]
                break
            case 4:
                promotionTypeLabel.text =   "减"
                promotionTypeLabel.backgroundColor = globalPromotionCorlorArr[5]
                break
            case 5:
                promotionTypeLabel.text =   "券"
                promotionTypeLabel.backgroundColor = globalPromotionCorlorArr[4]
                break
            case 6:
                promotionTypeLabel.text =   "折"
                promotionTypeLabel.backgroundColor = globalPromotionCorlorArr[3]
                break
            default:
                break
            }
            
           
        }
        

        
    }
    
    

    
    
    //MARK: - tableview delegate
     
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotionModel.cellModelArr.count
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GoodsPromotionTabCell.cellHeight
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell = tableView.dequeueReusableCell(withIdentifier: "GoodsPromotionTabCell")
            if cell == nil {
                cell = GoodsPromotionTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "GoodsPromotionTabCell")
            }
            if let targetCell = cell as? GoodsPromotionTabCell{
                targetCell.selectionStyle = .none
                targetCell.setModel(model: promotionModel.cellModelArr[indexPath.row],index:indexPath.row)
                
                return targetCell
            }else{
                return cell!
            }
    }
    
    
  
    
    
    
    
    //MARK: - Scrollview delegate
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.canScroll == false {
            scrollView.contentOffset = .zero
        }
        
        let offsetY = scrollView.contentOffset.y
        if (offsetY < 0) {
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Home_Leave_Top") , object: nil, userInfo: ["canScroll":"1"])
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
