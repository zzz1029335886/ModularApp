//
//  BBSettingViewController.swift
//  qqncp
//
//  Created by zerry on 2018/9/12.
//  Copyright © 2018年 zerry. All rights reserved.
//

import UIKit

public
protocol BBSettingViewControllerDelegate: AnyObject {
    func settingViewController(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, didSelectItem item: BBSettingItem)
    
    func settingViewController(_ tableView: UITableView, switchValueChanged item: BBSettingSwitchItem?)
    
    func settingViewController(_ item: BBSettingItem, didEndEditing textField: UITextField)
    
    func settingViewController(_ item: BBSettingItem, textChanged text: String?)
    
    func settingViewController(_ item: BBSettingItem, didBeginEditing textField: UITextField)
    
}

public
extension BBSettingViewControllerDelegate{
    func settingViewController(_ tableView: UITableView, switchValueChanged item: BBSettingSwitchItem?){}
    
    func settingViewController(_ item: BBSettingItem, didEndEditing textField: UITextField){}
    
    func settingViewController(_ item: BBSettingItem, textChanged text: String?){}
    
    func settingViewController(_ item: BBSettingItem, didBeginEditing textField: UITextField){}
}


open class BBSettingViewController: BBBaseTableViewController {
    
    open var groups: [BBSettingGroup] = []
    open weak var delegate : BBSettingViewControllerDelegate?
    
    open func addGroup(_ group:BBSettingGroup){
        self.groups.append(group)
    }
    
    open func removeAll(){
        self.groups.removeAll()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView.init(frame: view.bounds, style: .plain)
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.register(BBSettingTextFieldTableViewCell.self, forCellReuseIdentifier: "BBSettingTextFieldTableViewCell")
        self.tableView.register(BBSettingButtonTableViewCell.self, forCellReuseIdentifier: "BBSettingButtonTableViewCell")
        self.tableView.register(BBSettingImageViewTableViewCell.self, forCellReuseIdentifier: "BBSettingImageViewTableViewCell")
        self.tableView.register(BBSettingTextViewTableViewCell.self, forCellReuseIdentifier: "BBSettingTextViewTableViewCell")
        self.tableView.register(BBSettingUploadImageTableViewCell.self, forCellReuseIdentifier: "BBSettingUploadImageTableViewCell")
        self.tableView.register(BBSettingTipTableViewCell.self, forCellReuseIdentifier: "BBSettingTipTableViewCell")
        self.tableView.register(BBSettingSwitchTableViewCell.self, forCellReuseIdentifier: "BBSettingSwitchTableViewCell")
        self.tableView.register(BBSettingSelectionTableViewCell.self, forCellReuseIdentifier: "BBSettingSelectionTableViewCell")
        self.tableView.register(BBSettingCustomViewTableViewCell.self, forCellReuseIdentifier: "BBSettingCustomViewTableViewCell")
        self.tableView.register(BBSettingTextTableViewCell.self, forCellReuseIdentifier: "BBSettingTextTableViewCell")
        self.tableView.register(BBSettingCustomContentTableViewCell.self, forCellReuseIdentifier: "BBSettingCustomContentTableViewCell")
        
        self.tableView.sectionFooterHeight = 0.01
        self.tableView.sectionHeaderHeight = 0.01
        self.tableView.separatorStyle = .none
        view.addSubview(self.tableView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
}

extension BBSettingViewController:UITableViewDelegate,UITableViewDataSource{
    public func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups[section].items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = groups[indexPath.section].items[indexPath.row]
        var cell: BBSettingTableViewCell?
        
        if item is BBSettingTextFieldItem, cell == nil {
            let subCell = tableView.dequeueReusableCell(withIdentifier: "BBSettingTextFieldTableViewCell") as! BBSettingTextFieldTableViewCell
            subCell.controller = self
            cell = subCell
            
        } else if item is BBSettingButtonItem, cell == nil{
            let subCell = tableView.dequeueReusableCell(withIdentifier: "BBSettingButtonTableViewCell") as! BBSettingButtonTableViewCell
            cell = subCell
            
        } else if item is BBSettingImageViewItem, cell == nil{
            let subCell = tableView.dequeueReusableCell(withIdentifier: "BBSettingImageViewTableViewCell") as! BBSettingImageViewTableViewCell
            cell = subCell
        } else if item is BBSettingTextViewItem, cell == nil{
            let subCell = tableView.dequeueReusableCell(withIdentifier: "BBSettingTextViewTableViewCell") as! BBSettingTextViewTableViewCell
            cell = subCell
        } else if item is BBSettingUploadImageViewItem, cell == nil{
            let subCell = tableView.dequeueReusableCell(withIdentifier: "BBSettingUploadImageTableViewCell") as! BBSettingUploadImageTableViewCell
            cell = subCell
        } else if item is BBSettingTipItem, cell == nil{
            let subCell = tableView.dequeueReusableCell(withIdentifier: "BBSettingTipTableViewCell") as! BBSettingTipTableViewCell
            
            cell = subCell
        } else if item is BBSettingSwitchItem, cell == nil{
            let subCell = tableView.dequeueReusableCell(withIdentifier: "BBSettingSwitchTableViewCell") as! BBSettingSwitchTableViewCell
            subCell.delegate = self
            cell = subCell
        } else if item is BBSettingSelectionItem, cell == nil{
            let subCell = tableView.dequeueReusableCell(withIdentifier: "BBSettingSelectionTableViewCell") as! BBSettingSelectionTableViewCell
            cell = subCell
        } else if item is BBSettingTitleTextItem, cell == nil{
            let subCell = tableView.dequeueReusableCell(withIdentifier: "BBSettingTextTableViewCell") as! BBSettingTextTableViewCell
            cell = subCell
        } else if item is BBSettingCustomViewItem, cell == nil{
            let subCell = tableView.dequeueReusableCell(withIdentifier: "BBSettingCustomViewTableViewCell") as! BBSettingCustomViewTableViewCell
            cell = subCell
        } else if item is BBSettingCustomContentItem, cell == nil{
            let subCell = tableView.dequeueReusableCell(withIdentifier: "BBSettingCustomContentTableViewCell") as! BBSettingCustomContentTableViewCell
            cell = subCell
        }
        
        guard let cell = cell else { return BBSettingTableViewCell() }
        item.cell = cell
        cell.setItem(item)
        cell.controller = self
        cell.displayed()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let itemCell = cell as? BBSettingTableViewCell else {
            return
        }
        
        itemCell.didDisplay()
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let itemCell = cell as? BBSettingTableViewCell else {
            return
        }
        itemCell.willDisplay()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = groups[indexPath.section].items[indexPath.row]
        return model.contentHeight ?? model.height ?? 44
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return groups[section].spaceTop
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return groups[section].spaceBottom
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.groups[indexPath.section].items[indexPath.row]
        guard item.isUserInteractionEnabled else {
            return
        }
        
        self.delegate?.settingViewController(tableView, didSelectRowAt: indexPath, didSelectItem: item)
    }
    
}

extension BBSettingViewController: BBSettingSwitchTableViewCellDelegate{
    func settingSwitchTableViewCellValueChanged(_ cell: BBSettingSwitchTableViewCell,
                                                isOn: Bool) {
        self.delegate?.settingViewController(tableView, switchValueChanged: cell.switchItem)
    }
}

extension BBSettingViewController{
    
    func setFooterButtonView(
        paddingX: CGFloat = 16,
        paddingY: CGFloat = 16,
        height: CGFloat = 44
    ) -> UIButton {
        let viewHeight = paddingY * 2 + height
        let width = tableView.frame.width
        let view = UIView(frame: .init(x: 0, y: 0, width: width, height: viewHeight))
        
        let button = UIButton(frame: .init(x: paddingX, y: paddingY, width: width - 2 * paddingX, height: height))
        view.addSubview(button)
        
        tableView.tableFooterView = view
        return button
    }
    
}
