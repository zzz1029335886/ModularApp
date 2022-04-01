//
//  BBSettingSelectionTableViewCell.swift
//  BrainBank
//
//  Created by zerry on 2021/3/26.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit
import Common

class BBSettingSelectionTableViewCell: BBSettingTopTitleTableViewCell {
    var buttons : [UIButton] = []
    var selectedButton : UIButton?
    
    var selectionItem: BBSettingSelectionItem?{
        didSet{
            guard let selectionItem = selectionItem else { return }
            buttons.forEach{$0.removeFromSuperview()}
            buttons.removeAll()
            
            buttons = selectionItem.values.compactMap { (title) -> UIButton in
                let button = UIButton()
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = .regular(14)
                button.bb_setTitleColor(.black)
                if #available(iOS 13.0, *) {
                    button.setImage(UIImage.init(systemName: "circle"), for: .normal)
                    button.setImage(UIImage.init(systemName: "record.circle"), for: .selected)
                } else {
                    // Fallback on earlier versions
                }
                button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
                contentView.addSubview(button)
                return button
            }            
        }
    }
    
    @objc
    func buttonClick(_ button: UIButton) {
        if selectedButton == button {
            return
        }
        selectedButton?.isSelected = false
        button.isSelected = true
        selectedButton = button
        
        guard let selectionItem = selectionItem else { return }
        selectionItem.delegate?.settingSelectionItem(selectionItem, selected: button.tag)
    }
    
    override func setItem(_ item: BBSettingItem) {
        super.setItem(item)
        
        if let selectionItem = item as? BBSettingSelectionItem {
            self.selectionItem = selectionItem
        }
    }

    override func displayed() {
        super.displayed()
     
        guard let selectionItem = selectionItem else { return }
        let (frames, _) = BBStringCalculation(strings: selectionItem.values,
                                              font: .regular(14),
                                              marginLeft: titleLabel.frame.maxX,
                                              marginRight: selectionItem.titleLabelPadding,
                                              marginTop: titleLabel.frame.midY - 11,
                                              marginX: 32,
                                              extraWidth: 30,
                                              width: contentView.frame.width,
                                              itemHeight: 22).calculation()
        
        for (index,frame) in frames.enumerated() {
            if let button = buttons[safe: index]{
                if index == 0 {
                    buttonClick(button)
                }
                button.frame = frame
                button.tag = index
            }
        }

        self.selectionItem?.contentHeight = (frames.last?.maxY ?? 0) + titleLabel.frame.minY
        layoutIfNeeded()
    }

}
