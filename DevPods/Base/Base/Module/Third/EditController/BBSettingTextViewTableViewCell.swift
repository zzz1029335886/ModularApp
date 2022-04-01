//
//  BBSettingTextViewTableViewCell.swift
//  qqncp
//
//  Created by zerry on 2018/10/10.
//  Copyright © 2018年 zerry. All rights reserved.
//

import UIKit

class BBSettingTextViewTableViewCell: BBSettingTopTitleTableViewCell {
    var textView = BBPlaceholerTextView.init(placeholder: "", placeholderColor: .lightGray, frame: .zero)
    
    var textViewItem : BBSettingTextViewItem?{
        didSet{
            guard let textViewItem = textViewItem else { return }
            
            textView.placeholderGlobal = textViewItem.placeholder
            textView.text = textViewItem.content
            textView.limitWords = UInt(textViewItem.contentLimitCount)
            textView.isShowCountLabel = textViewItem.contentLimitCount != 9999
            textView.isUserInteractionEnabled = textViewItem.isTextUserInteractionEnabled
            
            textView.font = textViewItem.contentFont ?? UIFont.systemFont(ofSize: 15)
            textView.placeholderLabel.font = textViewItem.contentFont ?? UIFont.systemFont(ofSize: 15)
            textView.placeholderLabelPoint = textViewItem.originalPoint
            textView.placeholderLabel.sizeToFit()
            textView.textColor = textViewItem.contentColor ?? UIColor.darkGray
            textView.keyboardType = textViewItem.keyboardType
            textView.backgroundColor = textViewItem.inputBackgroundColor
            backgroundColor = textViewItem.backgroundColor ?? .white
            contentView.backgroundColor = .clear
            
            placeholerTextViewDidChange(textView)

        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textView.textContainerInset = UIEdgeInsets.init(top: 0, left: -4, bottom: 0, right: 0)
        textView.placeholderLabelPoint = .zero
        textView.kDelegate = self
        contentView.addSubview(textView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func becomeFirstResponder() -> Bool {
        textView.becomeFirstResponder()
        return super.becomeFirstResponder()
    }
    
    override func setItem(_ item: BBSettingItem) {
        super.setItem(item)
        
        if item is BBSettingTextViewItem {
            textViewItem = item as? BBSettingTextViewItem
        }
    }
    
    override func displayed() {
        super.displayed()
        
        guard let textViewItem = textViewItem else { return }
        
        let x = textViewItem.isBottom ? titleLabel.frame.minX : textViewItem.titleLabelWidth + textViewItem.titleLabelPadding
        let y = textViewItem.isBottom ? titleLabel.frame.maxY : titleLabel.frame.minY
        
        var width = contentView.frame.width - x - textViewItem.titleLabelPadding
        if let rightView = textViewItem.rightView{
            width = rightView.frame.minX - x - textViewItem.rightViewLeftPadding
        }
        
        textView.frame = CGRect(x: x,
                                y: y,
                                width: width,
                                height: contentView.frame.height - y)
        
    }
}

extension BBSettingTextViewTableViewCell: BBPlaceholerTextViewDelegate{
    func setContentHeight(_ placeholerTextView: BBPlaceholerTextView){
        guard let textViewItem = textViewItem else { return }
        textViewItem.content = placeholerTextView.text
        let contentHeight = max(placeholerTextView.frame.minY + placeholerTextView.contentSize.height + 15, textViewItem.height ?? 44)
        var height = textViewItem.contentHeight ?? textViewItem.height
        if height == contentHeight {
            return
        }
        height = contentHeight
        textViewItem.contentHeight = height
    }
    
    func placeholerTextViewDidChange(_ placeholerTextView: BBPlaceholerTextView) {
        setContentHeight(placeholerTextView)
        superTableView()?.beginUpdates()
        superTableView()?.endUpdates()
        displayed()
    }
}

extension UITableViewCell {
    /// 获取父tableView
    func superTableView() -> UITableView? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let tableView = view as? UITableView {
                return tableView
            }
        }
        return nil
    }
    
}
