//
//  BBSettingTopTitleTableViewCell.swift
//  qqncp
//
//  Created by zerry on 2018/10/10.
//  Copyright © 2018年 zerry. All rights reserved.
//

import UIKit

class BBSettingTopTitleTableViewCell: BBSettingTableViewCell {
    var titleLabel = UILabel()
    var titleItem : BBSettingTitleItem?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func setItem(_ item: BBSettingItem) {
        super.setItem(item)
        
        guard let titleItem = item as? BBSettingTitleItem else { return }
        titleLabel.text = titleItem.title
        titleLabel.textColor = titleItem.titleTextColor
        titleLabel.font = titleItem.titleFont
        self.titleItem = titleItem
        layoutIfNeeded()
    }
    
    override func displayed() {
        super.displayed()
        
        guard let titleItem = titleItem else { return }
        titleLabel.sizeToFit()
        var titleHeight = titleLabel.frame.size.height
        var y = titleItem.titleLabelPaddingY ?? (titleItem.height ?? 44 - titleLabel.frame.height) * 0.5
        
        if titleLabel.text == nil {
            titleHeight = 0
            y = titleItem.titleLabelPaddingY ?? 0
        }
        
        titleLabel.frame = CGRect(x: titleItem.titleLabelPadding,
                                  y: y,
                                  width: titleItem.titleLabelWidth,
                                  height: titleHeight)
    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        
//        let context = UIGraphicsGetCurrentContext()
//        context?.addRect(rect)
//        context?.setFillColor(UIColor.white.cgColor)
//        context?.fillPath()
//        
//    }


}
