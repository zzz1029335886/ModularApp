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
    
    lazy var item0: BBSettingImageViewItem = {
        let item = BBSettingImageViewItem()
        item.title = "Icon"
        item.image = UIImage.init(systemName: "brain.head.profile", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 44))
        item.height = 100
        return item
    }()
    
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
        item.title = "Tip: Custom Right View"
        item.titleFont = .regular(12)
        item.titleTextColor = .red
        let btn = UIButton.init(type: .contactAdd)
        item.rightView = btn
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
    
    lazy var item6: BBSettingTitleTextItem = {
        let item = BBSettingTitleTextItem.init()
        item.title = "TextEdit"
        item.content = "It seems like you are trying to create a new struct out of another module. Best solution would probably be to create your own init instead of the automatically generated one and declare it also as public."
        item.isBottom = true
        return item
    }()
    
    lazy var item67: BBSettingTextViewItem = {
        let item = BBSettingTextViewItem.init()
        item.title = "TextEdit"
        item.content = "Content"
        item.placeholder = "placeholder"
        item.isBottom = true
        item.height = 66
        item.titleLabelPaddingY = 6
        return item
    }()
    
    lazy var item7: BBSettingUploadImageViewItem = {
        let item = BBSettingUploadImageViewItem.init()
        item.titleLabelWidth = 300
        item.title = "UploadImages Under Title"
        item.isBottom = true
        return item
    }()
    
    lazy var item8: BBSettingUploadImageViewItem = {
        let item = BBSettingUploadImageViewItem.init()
        item.title = "UploadImages"
        return item
    }()
    
    lazy var item9: BBSettingCustomContentItem = {
        let item = BBSettingCustomContentItem.init()
        item.title = "CustomView frame is invalid"
        item.titleNumberOfLines = 2
        item.view = UIView.init(frame: CGRect.init(x: 110, y: 10, width: 66, height: 88))
        item.rightView = UIButton.init(type: UIButton.ButtonType.contactAdd)
        item.view?.backgroundColor = .red
        item.height = 100
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Setting"
        
        group.items = [item0, item1, item2, item3, item4, item5, item67, item6, item7, item8, item9]
        
        addGroup(group)
        
        delegate = self
    }
    
    

}

extension BBMineSettingViewController: BBSettingViewControllerDelegate{
    func settingViewController(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, didSelectItem item: BBSettingItem) {
        print("didSelect \(item)")
    }
    
    
    
}
