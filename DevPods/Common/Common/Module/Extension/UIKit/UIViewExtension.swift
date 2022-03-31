//
//  UIViewExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/1/21.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit


extension UIView {
    var captureImage: UIImage?{
        UIGraphicsBeginImageContext(self.bounds.size)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    ///移除view上的所有子视图
    func removeAllSubviews(){
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            addSubview(view)
        }
    }
    /**
     添加底部线
     */
    func setBottomLineView(
        _ color: UIColor = .lightGray,
        leadingOffset: CGFloat = 0,
        trailingOffset: CGFloat = 0,
        height: CGFloat = 0.333
    ) {
        if self.viewWithTag(11112222) != nil {
            return
        }
        
        let lineView = UIView()
        lineView.tag = 11112222
        lineView.backgroundColor = color
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (m) in
            m.height.equalTo(height)
            m.leading.equalToSuperview().offset(leadingOffset)
            m.trailing.equalToSuperview().offset(trailingOffset)
            m.bottom.equalToSuperview()
        }
    }
    
    /**
     删除添加底部线
     */
    func unsetBottomLineView(leadingOffset: CGFloat = 0, trailingOffset: CGFloat = 0) {
        let lineView = self.viewWithTag(11112222)
        lineView?.removeFromSuperview()
    }
    
    /**
     添加顶部线
     */
    func setTopLineView(
        _ color: UIColor = .lightGray,
        leadingOffset: CGFloat = 0,
        trailingOffset: CGFloat = 0,
        height: CGFloat = 0.333
    ) {
        if self.viewWithTag(22221111) != nil {
            return
        }
        
        let lineView = UIView()
        lineView.tag = 22221111
        lineView.backgroundColor = color
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (m) in
            m.height.equalTo(height)
            m.leading.equalToSuperview().offset(leadingOffset)
            m.trailing.equalToSuperview().offset(trailingOffset)
            m.top.equalToSuperview()
        }
    }
    
    /**
     删除添加顶部线
     */
    func unsetTopLineView(leadingOffset: CGFloat = 0, trailingOffset: CGFloat = 0) {
        let lineView = self.viewWithTag(22221111)
        lineView?.removeFromSuperview()
    }
    
    /// 添加任意方向线段
    /// - Parameters:
    ///   - direction: 方向
    ///   - leadingOffset: 左或上边距
    ///   - trailingOffset: 右或下边距
    ///   - thickness: 粗细
    func setLineView(direction: ShadowType, leadingOffset: CGFloat = 0, trailingOffset: CGFloat = 0, thickness: CGFloat = 0.333, lineColor: UIColor = .lightGray) {
        let lineView = UIView()
        lineView.tag = direction.rawValue
        lineView.backgroundColor = lineColor
        self.addSubview(lineView)
        switch direction {
        case .top:
            lineView.snp.makeConstraints { (m) in
                m.height.equalTo(thickness)
                m.leading.equalToSuperview().offset(leadingOffset)
                m.trailing.equalToSuperview().offset(trailingOffset)
                m.top.equalToSuperview()
            }
        case .left:
            lineView.snp.makeConstraints { (m) in
                m.top.equalToSuperview().offset(leadingOffset)
                m.bottom.equalToSuperview().offset(-trailingOffset)
                m.left.equalToSuperview()
                m.width.equalTo(thickness)
            }
        case .right:
            lineView.snp.makeConstraints { (m) in
                m.top.equalToSuperview().offset(leadingOffset)
                m.bottom.equalToSuperview().offset(-trailingOffset)
                m.right.equalToSuperview()
                m.width.equalTo(thickness)
            }
        case .bottom:
            lineView.snp.makeConstraints { (m) in
                m.height.equalTo(thickness)
                m.leading.equalToSuperview().offset(leadingOffset)
                m.trailing.equalToSuperview().offset(trailingOffset)
                m.bottom.equalToSuperview()
            }
        default:
            break
        }
        
    }
    
    
    
    /// 部分圆角
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func setCorner(byRoundingCorners corners: UIRectCorner = [.allCorners],
                   radii: CGFloat,
                   borderColor: UIColor? = nil,
                   borderWidth: CGFloat = 1,
                   size: CGSize = .zero) {
        setCornerBorder(byRoundingCorners: corners, radii: radii, borderColor: borderColor, borderWidth: borderWidth, size: size)
    }
    
    
    /// 设置圆角带边框线
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角值
    ///   - borderColor: 边框颜色
    ///   - borderWidth: 边框宽度
    func setCornerBorder(byRoundingCorners corners: UIRectCorner = [.allCorners],
                         radii: CGFloat,
                         borderColor: UIColor?,
                         borderWidth: CGFloat? = nil,
                         size: CGSize = .zero
    ) {
        unsetCornerBorder()
        
        var bounds = self.bounds
        if size != .zero{
            bounds.size = size
            self.bounds = bounds
        }
        
        /// 处理一些错误，但不完全
        guard bounds != .zero else { return }
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        
        if let borderColor = borderColor,
           let borderWidth = borderWidth,
           borderWidth > 0{
            // Add border
            let borderLayer = CAShapeLayer()
            borderLayer.path = maskPath.cgPath // Reuse the Bezier path
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = borderColor.cgColor
            borderLayer.lineWidth = borderWidth
            borderLayer.frame = bounds
            self.layer.addSublayer(borderLayer)
        }
    }
    
    /// 重置圆角边框
    func unsetCornerBorder() {
        self.layer.mask?.removeFromSuperlayer()
        if let layer = self.layer.sublayers?.last as? CAShapeLayer{
            if layer.path != nil,
               layer.frame != .zero,
               layer.fillColor != nil,
               layer.strokeColor != nil {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    func setShadow(borderWidth: CGFloat,
                   borderColor: UIColor,
                   showColor: UIColor,
                   offset: CGSize,
                   opacity: Float,
                   radius: CGFloat,
                   isLayoutSubviews:Bool = false) {
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.shadowColor = showColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.cornerRadius = radius
        self.layer.shadowRadius = 5
        if isLayoutSubviews {
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        }
    }
    
    //阴影方向
    enum ShadowType: Int {
        case all = 110 ///四周
        case top  = 111 ///上方
        case left = 112///左边
        case right = 113///右边
        case bottom = 114///下方
    }
    
    ///   黑色阴影, 阴影所占视图的比例
    /// - Parameters:
    ///   - type:
    ///   - color:阴影颜色
    ///   - opactiy:阴影透明度，默认0.4
    ///   - shadowRadius: 阴影半径，默认4
    ///   - shadowSize: 默认1
    ///   - radius:
    ///   - borderWidth:
    ///   - borderColor:
    func shadow(type: ShadowType,
                color: UIColor = .init(white: 0, alpha: 0.3),
                opactiy: Float = 0.4 ,
                shadowRadius : CGFloat = 4 ,
                shadowSize: CGFloat = 1 ,
                radius: CGFloat = 8 ,
                borderWidth : CGFloat = 0.5,
                borderColor : UIColor = .white) -> Void {
        layer.shadowColor = color.cgColor // 阴影颜色
        layer.shadowOpacity = opactiy// 阴影透明度，默认0.4
        layer.shadowOffset = .zero //shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        layer.shadowRadius = shadowRadius //阴影半径，默认4
        layer.backgroundColor = UIColor.white.cgColor
        
        layer.masksToBounds = false //必须要等于NO否则会把阴影切割隐藏掉
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
        var shadowRect: CGRect = .zero
        switch type {
        case .top:
            shadowRect = CGRect.init(x: -shadowSize, y: -shadowSize, width: bounds.size.width + 2 * shadowSize, height: 2 * shadowSize)
        case .bottom:
            shadowRect = CGRect.init(x: -shadowSize, y: bounds.size.height - shadowSize, width: bounds.size.width + 2 * shadowSize, height: 2 * shadowSize)
        case .left:
            shadowRect = CGRect.init(x: -shadowSize, y: -shadowSize, width: 2 * shadowSize, height: bounds.size.height + 2 * shadowSize)
        case .right:
            shadowRect = CGRect.init(x: bounds.size.width - shadowSize, y: -shadowSize, width: 2 * shadowSize, height: bounds.size.height + 2 * shadowSize)
        case .all:
            layer.shadowOffset = CGSize(width: 0, height: 0)
            return
        }
        layer.shadowPath = UIBezierPath.init(rect: shadowRect).cgPath
        
    }
    
    ///绘制虚线
    func drawDashLine(strokeColor: UIColor,
                      lineWidth: CGFloat = 1,
                      lineLength: Int = 6,
                      lineSpacing: Int = 3,
                      isLevel: Bool = true) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPhase = 0
        //每一段虚线长度 和 每两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        
        let path = CGMutablePath()
        ///起点
        path.move(to: CGPoint(x: self.frame.width, y: 0))
        ///终点
        if isLevel {
            ///  横向 y = 0
            path.addLine(to: CGPoint(x: 0, y: 0))
        }else{
            ///纵向 Y = view 的height
            path.addLine(to: CGPoint(x: self.frame.width/2, y: self.frame.height))
        }
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
    
    
    /// 虚线边框
    func drawDottedLine(_ rect: CGRect, _ radius: CGFloat, _ color: UIColor) {
        let layer = CAShapeLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        layer.position = CGPoint(x: rect.midX, y: rect.midY)
        layer.path = UIBezierPath(rect: layer.bounds).cgPath
        layer.path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: radius).cgPath
        layer.lineWidth = 1/UIScreen.main.scale
        //虚线边框
        layer.lineDashPattern = [NSNumber(value: 5), NSNumber(value: 5)]
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color.cgColor
        self.layer.addSublayer(layer)
    }
    
    ///设置圆角
    func setCornerRadius(_ cornerRadius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
    
    ///设置圆角和边框
    func setCornerRadiusAddBorder(_ cornerRadius: CGFloat,_ borderWidth:CGFloat,_ borderColor:CGColor) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
    
    ///去掉圆角
    func resetCornerRadius() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 0
    }
    
    
    func checkEmptyView(dataSourceCount: Int) {
        let subView = self.viewWithTag(-10000)
        subView?.removeFromSuperview()
        
        guard dataSourceCount == 0 else { return }
        
        let backView = UIView()
        backView.tag = -10000
        backView.backgroundColor = .hex(hexString: "#F8F8F8")
        self.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.textColor = .hex(hexString: "#666666")
        titleLabel.textAlignment = .center
        titleLabel.font = .regular(12)
        titleLabel.text = "暂无数据"
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalToSuperview()
        }
        
    }
    
    func checkEmptyBlackView(dataSourceCount: Int) {
        let subView = self.viewWithTag(-10000)
        subView?.removeFromSuperview()
        
        guard dataSourceCount == 0 else { return }
        
        let backView = UIView()
        backView.tag = -10000
        backView.backgroundColor = .clear
        self.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.textColor = .hex(hexString: "#FFFFFF")
        titleLabel.textAlignment = .center
        titleLabel.font = .regular(12)
        titleLabel.text = "暂无数据"
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalToSuperview()
        }
        
    }
    
    
    //MARK:- 绘制虚线
    func drawDashLine(_ lineView:UIView,strokeColor: UIColor, lineWidth: CGFloat = 1, lineLength: Int = 10, lineSpacing: Int = 5) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = lineView.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        //每一段虚线长度 和 每两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        
        let path = CGMutablePath()
        //        let y = lineView.layer.bounds.height - lineWidth
        let x = lineView.layer.bounds.width - lineWidth
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: lineView.layer.bounds.height))
        shapeLayer.path = path
        lineView.layer.addSublayer(shapeLayer)
    }
}
