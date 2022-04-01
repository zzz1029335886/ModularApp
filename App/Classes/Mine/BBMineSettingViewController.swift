//
//  BBSettingViewController.swift
//  App
//
//  Created by zerry on 2022/4/1.
//

import UIKit
import Base

class BBMineSettingViewController: BBSettingViewController {
    var group = BBSettingGroup.init()
    
    lazy var item1: BBSettingTextFieldItem = {
        let item = BBSettingTextFieldItem()
        item.title = "TextField"
        item.placeholder = "placeholder"
        item.content = "content"
        return item
    }()
    
    lazy var item2: BBSettingButtonItem = {
        let item = BBSettingButtonItem.init()
        item.title = "Button"
        item.placeholder = "placeholder"
        item.content = "content"
        return item
    }()
    
    lazy var item3: BBSettingTipItem = {
        let item = BBSettingTipItem.init()
        item.title = "Tip"
        item.titleFont = .regular(12)
        item.titleTextColor = .red
        return item
    }()
    
    lazy var item4: BBSettingSwitchItem = {
        let item = BBSettingSwitchItem.init()
        item.title = "Switch"
        return item
    }()
    
    lazy var item5: BBSettingSelectionItem = {
        let item = BBSettingSelectionItem.init()
        item.title = "Selection"
        item.values = ["Item0", "Item1", "Item2", "Item3"]
        return item
    }()
    
    lazy var item6: BBSettingTitleTextEditItem = {
        let item = BBSettingTitleTextEditItem.init()
        item.title = "TextEdit"
        item.content = "It seems like you are trying to create a new struct out of another module. Best solution would probably be to create your own init instead of the automatically generated one and declare it also as public."
        item.placeholder = "placeholder"
        item.isBottom = true
        return item
    }()
    
    lazy var item7: BBSettingUploadImageViewItem = {
        let item = BBSettingUploadImageViewItem.init()
        item.title = "UploadImages"
        item.height = 100
//        item.isBottom = true
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Setting"
        
        group.items = [item1, item2, item3, item4, item5, item6, item7]
        
        addGroup(group)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
