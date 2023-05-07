//
//  BBAutoSizeCollectionViewCell.swift
//  BrainBank
//
//  Created by zerry on 2021/10/25.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

protocol BBAutoSizeCollectionViewCellLayoutDelegate: AnyObject {
    func autoSizeCollectionViewCell(_ cell: BBAutoSizeCollectionViewCell, layout size: CGSize)
    func autoSizeCollectionViewCellComplete(_ cell: BBAutoSizeCollectionViewCell, size: CGSize)
    func autoSizeCollectionViewCellReload(_ cell: BBAutoSizeCollectionViewCell, isLayout: Bool)
}

class BBAutoSizeCollectionViewCell: UICollectionViewCell {
    weak var layoutDelegate: BBAutoSizeCollectionViewCellLayoutDelegate?
    var defaultHeight = BBListSectionController.defaultHeight
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 是否自适应高度
    var shouldPreferredLayoutAttributesFitting = true
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        if !shouldPreferredLayoutAttributesFitting {
            self.layoutDelegate?.autoSizeCollectionViewCellComplete(self, size: .zero)
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }
        
        if Int(layoutAttributes.frame.size.height) != defaultHeight {
            self.layoutDelegate?.autoSizeCollectionViewCellComplete(self, size: layoutAttributes.frame.size)
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        
        var size = contentView.systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        size.height = ceil(size.height)
        
        if size.height == 0 {
            self.layoutDelegate?.autoSizeCollectionViewCellComplete(self, size: size)
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }
        
        layoutAttributes.frame.size.height = size.height
        self.layoutDelegate?.autoSizeCollectionViewCell(self, layout: size)
        
        return super.preferredLayoutAttributesFitting(layoutAttributes)
    }
}
