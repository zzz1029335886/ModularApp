//
//  BBSettingTitleTableViewCell.swift
//  BrainBank
//
//  Created by zerry on 2021/3/29.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

class BBSettingTitleTableViewCell: BBSettingTableViewCell {

    var titleLabel = UILabel()
    var titleItem: BBSettingTitleItem?

    override func setItem(_ item: BBSettingItem) {
        super.setItem(item)
        
        guard let titleItem = item as? BBSettingTitleItem else { return }
        self.titleLabel.text = titleItem.title
        self.titleLabel.textColor = titleItem.titleTextColor ?? UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.titleLabel.font = titleItem.titleFont ?? UIFont.medium(15)
        self.titleItem = titleItem
        
    }
    
    var contentWidth : CGFloat{
        guard let titleItem = titleItem else { return contentView.frame.width }
        return contentView.frame.width - titleItem.titleLabelWidth - 2 * titleItem.titleLabelPadding
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func displayed() {
        super.displayed()
        
        guard let titleItem = titleItem else { return }
        
        var titleFrame : CGRect = .zero
       
        titleFrame = CGRect(x: titleItem.titleLabelPadding,
                            y: 0,
                            width: titleItem.titleLabelWidth,
                            height: self.contentView.frame.height)
        titleLabel.frame = titleFrame
        
    }
}
