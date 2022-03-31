//
//  UITableViewExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/9/16.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

extension UITableView{
    func reloadLastSection(with animation: RowAnimation = .none) {
        self.reloadSections(IndexSet.init(integer: self.numberOfSections - 1), with: animation)
    }
    
    func reloadFirstSection(with animation: RowAnimation = .none) {
        self.reloadSections(IndexSet.init(integer: 0), with: animation)
    }
}

public struct SectionLayerShadowPosition : OptionSet {
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    public let rawValue: Int
    
    public static var top = SectionLayerShadowPosition.init(rawValue: 1 << 0)
    public static var bottom = SectionLayerShadowPosition.init(rawValue: 1 << 1)
    public static var left = SectionLayerShadowPosition.init(rawValue: 1 << 2)
    public static var right = SectionLayerShadowPosition.init(rawValue: 1 << 3)
}

extension CAShapeLayer{
    func shadowPathPosition(
        _ position: SectionLayerShadowPosition,
        insetX: CGFloat = 16,
        shadowWidth: CGFloat = 3
    ) {
        let shapeLayer = self
        let bounds = shapeLayer.bounds.insetBy(dx: insetX, dy: 0)
        
        let maxX = bounds.maxX
        let maxY = bounds.maxY
        
        let path = UIBezierPath.init()
        
        //右边
        if position.contains(.right) {
            path.move(to: .init(x: maxX, y: 0))
            path.addLine(to: .init(x: maxX + shadowWidth, y: 0))
            path.addLine(to: .init(x: maxX + shadowWidth, y: maxY))
            path.addLine(to: .init(x: maxX, y: maxY))
        }
        
        //左边
        if position.contains(.left) {
            path.move(to: .init(x: insetX - shadowWidth, y: 0))
            path.addLine(to: .init(x: insetX, y: 0))
            path.addLine(to: .init(x: insetX, y: maxY))
            path.addLine(to: .init(x: insetX - shadowWidth, y: maxY))
        }
        
        //上边
        if position.contains(.top) {
            path.move(to: .init(x: insetX, y: 0))
            path.addLine(to: .init(x: insetX, y: -shadowWidth))
            path.addLine(to: .init(x: maxX, y: -shadowWidth))
            path.addLine(to: .init(x: maxX, y: 0))
        }
        
        //下边
        if position.contains(.bottom) {
            path.move(to: .init(x: insetX, y: maxY))
            path.addLine(to: .init(x: maxX, y: maxY))
            path.addLine(to: .init(x: maxX, y: maxY + shadowWidth))
            path.addLine(to: .init(x: insetX, y: maxY + shadowWidth))
        }
        
        shapeLayer.shadowPath = path.cgPath
        shapeLayer.shadowOffset = .zero
        shapeLayer.shadowRadius = shadowWidth
    }
    
}

extension UITableView{
    
    @discardableResult
    /// 设置section圆角
    /// - Parameters:
    ///   - cell: cell
    ///   - indexPath: indexPath
    ///   - cornerRadius: 圆角
    ///   - insetX: 偏移量x，默认无
    ///   - shadowWidth: 阴影宽度，nil表示不设置
    /// - Returns: BackgroundLayer
    public func setSectionCornerRadius(
        _ cornerRadius: CGFloat = 12,
        cell: UITableViewCell,
        indexPath: IndexPath,
        insetX: CGFloat = 0,
        shadowWidth: CGFloat? = nil
    ) -> CAShapeLayer {
        let tableView = self
        //下面为设置圆角操作（通过遮罩实现）
        let sectionCount = tableView.numberOfRows(inSection: indexPath.section)
        let bounds = cell.bounds
        let layerBounds = bounds.insetBy(dx: insetX, dy: 0)
        let cornerRadii = CGSize.init(width: cornerRadius, height: cornerRadius)
        let bezierPath : UIBezierPath
        
        let exitBackgroundView = cell.backgroundView
        let backgroundView = exitBackgroundView ?? UIView()
        if exitBackgroundView != backgroundView {
            cell.backgroundView = backgroundView
        }
        
        let exitLayer = backgroundView.layer.sublayers?.first as? CAShapeLayer
        let shapeLayer = exitLayer ?? CAShapeLayer()
        
        if exitLayer != shapeLayer {
            backgroundView.layer.addSublayer(shapeLayer)
        }
        shapeLayer.frame = bounds
        
        /// 当前分区有多行数据时
        if sectionCount > 1 {
            switch indexPath.row {
                
            case 0: /// 如果是第一行,左上、右上角为圆角
                bezierPath = UIBezierPath(roundedRect: layerBounds,
                                          byRoundingCorners: [.topLeft, .topRight],
                                          cornerRadii: cornerRadii)
                if let shadowWidth = shadowWidth {
                    shapeLayer.shadowPathPosition([.left, .top, .right], insetX: insetX, shadowWidth: shadowWidth)
                } else {
                    shapeLayer.path = nil
                }
                
            case sectionCount - 1: /// 如果是最后一行,左下、右下角为圆角
                bezierPath = UIBezierPath(roundedRect: layerBounds,
                                          byRoundingCorners: [.bottomLeft, .bottomRight],
                                          cornerRadii: cornerRadii)
                if let shadowWidth = shadowWidth {
                    shapeLayer.shadowPathPosition([.left, .bottom, .right], insetX: insetX, shadowWidth: shadowWidth)
                } else {
                    shapeLayer.path = nil
                }
                
            default:
                bezierPath = .init(rect: layerBounds)
                if let shadowWidth = shadowWidth {
                    shapeLayer.shadowPathPosition([.left, .right], insetX: insetX, shadowWidth: shadowWidth)
                } else {
                    shapeLayer.path = nil
                }
            }
        } else { /// 当前分区只有一行行数据时
            
            /// 四个角都为圆角（同样设置偏移隐藏首、尾分隔线）
            bezierPath = UIBezierPath(roundedRect: layerBounds, cornerRadius: cornerRadius)
            if let shadowWidth = shadowWidth {
                shapeLayer.shadowPathPosition([.top, .bottom, .left, .right], insetX: insetX, shadowWidth: shadowWidth)
            } else {
                shapeLayer.shadowPath = nil
            }
        }
        
        shapeLayer.path = bezierPath.cgPath
        return shapeLayer
    }
    
}
