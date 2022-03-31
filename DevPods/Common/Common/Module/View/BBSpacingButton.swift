//
//  BBSpacingButton.swift
//  BrainBank
//
//  Created by zerry on 2021/4/19.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

open
class BBSpacingButton: UIButton {
    /*
     默认的图片在左文字在右侧
     */
    public enum ImagePosition {
        case left(_ padding: CGFloat = 0)
        case right(_ padding: CGFloat = 0)
        case bottom(_ padding: CGFloat = 0)
        case top(_ padding: CGFloat = 0)
    }
    
    public var spacing: CGFloat = 0
    public var imagePosition: ImagePosition = .left()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutImagePosition()
    }
    
    private func layoutImagePosition() {
        let content = super.contentRect(forBounds: bounds)
        let titleRect = super.titleRect(forContentRect: content)
        let imageRect = super.imageRect(forContentRect: content)
        var spacing = self.spacing
        
        switch imagePosition {
        case .left(let padding):
            spacing += padding
            
            switch contentHorizontalAlignment {
            case .center:
                titleEdgeInsets.updateLeftAndRight(left: spacing / 2)
                imageEdgeInsets.updateLeftAndRight(left: -spacing / 2)
            case .left, .leading:
                titleEdgeInsets.updateLeftAndRight(left: spacing)
                imageEdgeInsets.updateLeftAndRight(left: padding)
            case .right, .trailing:
                titleEdgeInsets.updateLeftAndRight(left: padding)
                imageEdgeInsets.updateLeftAndRight(left: -spacing)
            default:
                break
            }
            
        case .right(let padding):
            spacing += padding
            
            var imageOffset = titleRect.width
            var titleOffset = imageRect.width
            switch contentHorizontalAlignment {
            case .center:
                imageOffset = imageOffset + spacing * 0.5
                titleOffset = titleOffset + spacing * 0.5
            case .left, .leading:
                imageOffset = imageOffset + spacing
            case .right, .trailing: // check，调试完成
                imageOffset = imageOffset - padding
                titleOffset = titleOffset + spacing
            default:
                break
            }
            imageEdgeInsets.updateLeftAndRight(left: imageOffset)
            titleEdgeInsets.updateLeftAndRight(left: -titleOffset)
            contentEdgeInsets = .init(top: 0, left: spacing, bottom: 0, right: 0)
            
        case .top(let padding):
            spacing += padding
            
            let allWidth = imageRect.width + titleRect.width
            let allHeight = imageRect.height + titleRect.height
            let maxHeight = max(imageRect.height, titleRect.height)
            switch contentHorizontalAlignment {
            case .center:
                let imageOffsetX = allWidth * 0.5 - imageRect.width * 0.5
                let titleOffsetX = allWidth * 0.5 - titleRect.width * 0.5
                imageEdgeInsets.updateLeftAndRight(left: imageOffsetX)
                titleEdgeInsets.updateLeftAndRight(left: -titleOffsetX)
            case .left, .leading:
                titleEdgeInsets.updateLeftAndRight(left: -imageRect.width)
                imageEdgeInsets.updateLeftAndRight(left: 0)
            case .right, .trailing:
                titleEdgeInsets.updateLeftAndRight(left: 0)
                imageEdgeInsets.updateLeftAndRight(left: titleRect.width)
            default:
                break
            }
            
            switch contentVerticalAlignment {
            case .center:
                let baseHeight = allHeight - maxHeight
                let imageOffsetY = baseHeight * 0.5 + spacing * 0.5
                let titleOffsetY = baseHeight * 0.5 + spacing * 0.5
                imageEdgeInsets.updateTopAndBottom(top: -imageOffsetY)
                titleEdgeInsets.updateTopAndBottom(top: titleOffsetY)
            case .top:
                imageEdgeInsets.updateTopAndBottom(top: 0)
                titleEdgeInsets.updateTopAndBottom(top: imageRect.height + spacing)
            case .bottom:
                imageEdgeInsets.updateTopAndBottom(top: -titleRect.height - spacing)
                titleEdgeInsets.updateTopAndBottom(top: 0)
            default:
                break
            }
            
        case .bottom(let padding):
            spacing += padding
            
            let allWidth = imageRect.width + titleRect.width
            let allHeight = imageRect.height + titleRect.height
            let maxHeight = max(imageRect.height, titleRect.height)
            switch contentHorizontalAlignment {
            case .center:
                let imageOffsetX = allWidth * 0.5 - imageRect.width * 0.5
                let titleOffsetX = allWidth * 0.5 - titleRect.width * 0.5
                imageEdgeInsets.updateLeftAndRight(left: imageOffsetX)
                titleEdgeInsets.updateLeftAndRight(left: -titleOffsetX)
            case .left, .leading:
                titleEdgeInsets.updateLeftAndRight(left: -imageRect.width)
                imageEdgeInsets.updateLeftAndRight(left: 0)
            case .right, .trailing:
                titleEdgeInsets.updateLeftAndRight(left: 0)
                imageEdgeInsets.updateLeftAndRight(left: titleRect.width)
            default:
                break
            }
            
            switch contentVerticalAlignment {
            case .center:
                let baseHeight = allHeight - maxHeight
                let imageOffsetY = baseHeight * 0.5 + spacing * 0.5
                let titleOffsetY = baseHeight * 0.5 + spacing * 0.5
                imageEdgeInsets.updateTopAndBottom(top: imageOffsetY)
                titleEdgeInsets.updateTopAndBottom(top: -titleOffsetY)
            case .top:
                imageEdgeInsets.updateTopAndBottom(top: titleRect.height + spacing)
                titleEdgeInsets.updateTopAndBottom(top: 0)
            case .bottom:
                imageEdgeInsets.updateTopAndBottom(top: 0)
                titleEdgeInsets.updateTopAndBottom(top: -imageRect.height - spacing)
            default:
                break
            }
        }
    }
}

fileprivate
extension UIEdgeInsets {
    mutating func updateLeftAndRight(left: CGFloat) {
        self.left = left
        self.right = -left
    }
    
    mutating func updateTopAndBottom(top: CGFloat) {
        self.top = top
        self.bottom = -top
    }
}
