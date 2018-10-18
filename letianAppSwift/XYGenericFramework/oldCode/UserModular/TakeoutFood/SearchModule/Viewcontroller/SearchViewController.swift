//
//  SearchViewController.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/10.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var topView:XYTopView!
    var searchTable:UITableView!
    var actionSheetView:CommonAlertSheetView!
    var SearchArr:[String] = Array()
    var searchfilepath:NSString = ""
    var searchWord:String!
    var service:SearchSellerGoodsService = SearchSellerGoodsService()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        creatActionSheetView()
        service.searchHistoryRequest(target: self)
        // Do any additional setup after loading the view.
    }

    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).rightStrBtnItem(target: self, action: #selector(searchAction), btnStr: "搜索", fontSize:15).searchTextFieldItem(placeholderStr: nil))
    }
    
    //MARK: - 创建弹框按钮View
    func creatActionSheetView(){
        actionSheetView = CommonAlertSheetView(frame:CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 131))
        self.view.addSubview(actionSheetView)
    }

    //MARK: - 删除输入框中文字
    func deleteBtnAct(){
        topView.searchTextField.rightViewMode = .never
        topView.searchTextField.text = ""
    }
    
    
    
    func CreateSearchTable()
    {
        self.searchTable = UITableView(frame:CGRect(x: 0, y: topView.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-topView.frame.maxY) , style: .grouped)
        
        self.searchTable.backgroundColor = cmColorWithString(colorName: "f4f4f4")
        self.searchTable.separatorStyle = .none
        if #available(iOS 11, *) {
            searchTable.contentInsetAdjustmentBehavior = .never
        }
        self.searchTable.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        
        self.searchTable.delegate = self
        self.searchTable.dataSource = self
        
        self.view.addSubview(self.searchTable)
        
    }
    
    
    //MARK: - tableview的delegate和dataDource---
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        let view = UIView(frame: .zero)
        return view
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cmSizeFloat(44)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  cmSizeFloat(35)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let TableHeaderSectionView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: cmSizeFloat(35)))
        TableHeaderSectionView.backgroundColor = cmColorWithString(colorName: "f4f4f4")

        
        let tipsText = "清空历史记录"
        
        let tipsTextWdith = tipsText.stringWidth(cmSingleLineHeight(fontSize:cmSystemFontWithSize(13) ), font: cmSystemFontWithSize( 13))
        
        
        let tipsLabel = UILabel(frame: CGRect(x: cmSizeFloat(18), y: 0, width: tipsTextWdith, height: cmSizeFloat(35)))
        tipsLabel.text = tipsText
        tipsLabel.textColor = MAIN_BLACK2
        tipsLabel.font = cmSystemFontWithSize( 13)
        TableHeaderSectionView.addSubview(tipsLabel)
        

        
        let clearBtn:UIButton = UIButton.init(frame: CGRect(x: SCREEN_WIDTH - cmSizeFloat(44), y: 0, width: cmSizeFloat(44), height: cmSizeFloat(35)))
        clearBtn.setTitle("清除", for: .normal)
        clearBtn.setTitleColor(MAIN_BLACK2, for: .normal)
        clearBtn.titleLabel?.font = cmSystemFontWithSize(13)
        clearBtn.addTarget(self, action: #selector(self.clearAction(send:)), for: .touchUpInside)
        TableHeaderSectionView.addSubview(clearBtn)
        
        if self.SearchArr.count == 0
        {
            tipsLabel.text = "无搜索记录"
            clearBtn.isHidden = true
        }
        
        
        return TableHeaderSectionView
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SearchArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath as IndexPath) as! SearchTableViewCell
        cell.selectionStyle = .none
        cell.searchHistoryLabel.text = self.SearchArr[indexPath.row]
        return cell
    }
    
    

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if SearchArr.count > 0{
            self.searchWord = SearchArr[indexPath.row]
            self.view.endEditing(true)
            self.actionSheetView.showInView(view: self.view)
            //设置textField显示
            self.topView.searchTextField.text = SearchArr[indexPath.row]
            self.topView.searchTextField.rightViewMode = .always

            
        }
        
    }
    
    
    
    //MARK: - 搜索分类按钮响应
    func searchCommonAction(searchType:Int){
        let resultVC = SearchResultVC()
        resultVC.searchWord = self.searchWord
        resultVC.searchType = searchType
        self.navigationController?.pushViewController(resultVC, animated: true)
        self.actionSheetView.hideInView()
        
    }
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - 回收键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    
    
    //MARK: - 搜索按钮绑定事件
    @objc func searchAction()
    {
        if self.topView.searchTextField.text?.count == 0
        {
            cmShowHUDToWindow(message:"搜索内容不能为空")
        }
        else
        {
            self.view.endEditing(true)
            self.searchWord = self.topView.searchTextField.text
            actionSheetView.showInView(view: self.view)
        }
 
    }
    
    

    
    
    //MARK: - 清除历史记录
    @objc func clearAction(send:UIButton)
    {
        if self.SearchArr.count != 0
        {
            self.service.deleteSearchHistoryRequest(successAct: { [weak self] in
                DispatchQueue.main.async {
                    self?.SearchArr.removeAll()
                    self?.searchTable.reloadData()
                }
            }, failureAct: {
                
            })
            
        }
        
        
    }
    
    
    

    

    
    
    @objc private func textFiledTextDidChange(_ notification: Notification) {
        
        let markRange = topView.searchTextField.markedTextRange
        if markRange == nil {
            if topView.searchTextField.text!.count == 0 {
                topView.searchTextField.rightViewMode = .never
            } else {
                topView.searchTextField.rightViewMode = .always
            }
            
        }
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        UIApplication.shared.statusBarStyle = .default
        tabBarController?.tabBar.isHidden = true
        
        if searchTable != nil {
            searchTable.reloadData()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(textFiledTextDidChange(_:)), name: .UITextFieldTextDidChange, object: topView.searchTextField)
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
