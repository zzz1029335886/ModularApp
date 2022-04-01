//
//  BBSettingTextTableViewCell.swift
//  BrainBank
//
//  Created by zerry on 2021/3/31.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit
import Common

class BBSettingTextTableViewCell: BBSettingTopTitleTableViewCell {
    var label = UILabel()
    
    var textItem : BBSettingTitleTextItem?{
        didSet{
            guard let textItem = textItem else { return }
            
            label.text = textItem.content
            label.font = textItem.contentFont
            label.textColor = textItem.contentColor
            backgroundColor = textItem.backgroundColor ?? .white
            contentView.backgroundColor = .clear
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label.numberOfLines = 0
        contentView.addSubview(label)
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
        
        guard let textItem = item as? BBSettingTitleTextItem else { return }
        self.textItem = textItem
    }
    
    override func displayed() {
        super.displayed()

        guard let textItem = textItem else { return }

        let x = textItem.isBottom ? titleLabel.frame.minX : textItem.titleLabelWidth + textItem.titleLabelPadding
        let y = textItem.isBottom ? titleLabel.frame.maxY : titleLabel.frame.minY
        
        var width = contentView.frame.width - textItem.titleLabelPadding - x
        if let rightView = textItem.rightView{
            width = rightView.frame.minX - x - textItem.rightViewLeftPadding
        }
        
        let size = label.sizeThatFits(CGSize.init(width: width, height: BBCommon.kScreenHeight))
        let height = max(size.height, titleLabel.frame.size.height)
        label.frame = CGRect(x: x,
                             y: y,
                             width: width,
                             height: height)
        updateHeight()
        
    }
    
    func updateHeight() {
        guard let textItem = textItem else { return }

        let contentHeight = max(label.frame.minY + label.frame.height + 15, textItem.height ?? 44)
        let height = textItem.contentHeight ?? textItem.height
        if height == contentHeight {
            return
        }        
        textItem.contentHeight = contentHeight
//        tableView?.beginUpdates()
//        tableView?.endUpdates()
    }
        
}
