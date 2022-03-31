//
//  ZZSnapMutipleViewExtension.swift
//  ZZSnapMutipleViewSetup
//
//  Created by zerry on 2021/9/30.
//

import UIKit
import SnapKit

fileprivate
extension Array{
    subscript (zz_safe index: Int) -> Element? {
        return (0 ..< count).contains(index) ? self[index] : nil
    }
}

extension UIView{
    
    /// 批量设置子视图
    /// - Parameters:
    ///   - views: subviews
    ///   - styles: style
    func zz_setupSubViews(_ views: [UIView], _ styles: ZZSnapMutipleViewSetup.Style...) {
        zz_setupSubViews(views, styles: styles)
    }
    
    func zz_setupSubViews(_ views: [UIView], styles: [ZZSnapMutipleViewSetup.Style]) {
        guard !views.isEmpty else {
            return
        }
        
        var showType: ZZSnapMutipleViewSetup.Style.LayoutType = .equalSize(1, nil)
        var horizontalSpace: CGFloat? = 0
        var verticalSpace: CGFloat? = 0
        var insets: ZZSnapMutipleViewSetup.Insets? = nil
        var alignments: [ZZSnapMutipleViewSetup.Style.Alignment] = []
        var height: CGFloat?
        var width: CGFloat?
        var keyPriority: ConstraintPriority = .required
        var alignmentPriority: ConstraintPriority = .required

        for style in styles {
            switch style {
            case .showType(let type):
                showType = type
            case .horizontalSpace(let space):
                horizontalSpace = space
            case .verticalSpace(let space):
                verticalSpace = space
            case .space(let space):
                horizontalSpace = space
                verticalSpace = space
            case .insets(let top, let left, let bottom, let right):
                insets = .init(top: top, left: left, bottom: bottom, right: right)
            case .insetsModel(let _insets):
                insets = _insets
            case .alignment(let alignment):
                alignments.append(alignment)
            case .alignments(let _alignments):
                alignments.append(contentsOf: _alignments)
            case .alignmentPriority(let _priority):
                alignmentPriority = _priority
            case .height(let _height):
                height = _height
            case .width(let _width):
                width = _width
            case .keyPriority(let _keyPriority):
                keyPriority = _keyPriority
            }
        }
        
        if let height = height {
            self.snp.makeConstraints { make in
                make.height.equalTo(height)
            }
        }
        if let width = width {
            self.snp.makeConstraints { make in
                make.width.equalTo(width)
            }
        }
        
        switch showType{
        case .equalSize(let countInLine, let itemHeight):
            zz_setupSubViews(views: views, countInLine: countInLine, itemHeight: itemHeight, horizontalSpace: horizontalSpace ?? 0, verticalSpace: verticalSpace ?? 0, insets: insets, lastBottomPriority: keyPriority)
            
        case .horizontal:
            zz_setupHorizontalSubViews(views: views, space: horizontalSpace, alignments: alignments, insets: insets, rightPriority: keyPriority, alignmentPriority: alignmentPriority)
            
        case .vertical:
            zz_setupVerticalSubViews(views: views, space: verticalSpace, alignments: alignments, insets: insets, bottomPriority: keyPriority, alignmentPriority: alignmentPriority)
        }
    }
    
    /// 使用snp批量设置子视图的约束，最后一个子视图的高度为自己的高度，子控件宽度相同
    /// - Parameters:
    ///   - subViews: 子视图列表
    ///   - countInLine: 每行个数，当每行数量为：1时，效果就是垂直布局
    ///   - horizontalSpace: 横向间距
    ///   - verticalSpace: 纵向间距
    ///   - insets: 内边距
    ///   - itemHeight: 每个高度，空表示自适应
    ///   - lastBottomPriority: 底部约束
    func zz_setupSubViews(
        views subViews: [UIView],
        countInLine: Int = 2,
        itemHeight: CGFloat? = nil,
        horizontalSpace: CGFloat = 0,
        verticalSpace: CGFloat = 0,
        insets: ZZSnapMutipleViewSetup.Insets? = .zero,
        lastBottomPriority: ConstraintPriority = .required
    ) {
        let view = self
        let paddingX = horizontalSpace
        let paddingY = verticalSpace
        
        var paddingX1 = paddingX
        var paddingY1 = paddingY
        
        var left = view.snp.left
        var width = view.snp.width
        var height = view.snp.height
        var top = view.snp.top
        
        let leftMargin: CGFloat = insets?.left ?? 0
        let topMargin: CGFloat = insets?.top ?? 0
        let rightMargin: CGFloat = insets?.right ?? 0
        let bottomMargin: CGFloat = insets?.bottom ?? 0
        
        for (index, subview) in subViews.enumerated() {
            subview.removeFromSuperview()
            view.addSubview(subview)
            
            /// 每行第一个
            if index % countInLine == 0{
                subview.snp.makeConstraints { (m) in
                    m.left.equalToSuperview().offset(leftMargin)
                    m.top.equalTo(top).offset((index == 0 ? topMargin : 0) + (index == 0 ? 0 : paddingY))
                    m.width.equalToSuperview()
                        .dividedBy(countInLine)
                        .offset(-(leftMargin + rightMargin + paddingX1 * CGFloat(countInLine - 1)) / CGFloat(countInLine) )
                }
                
                if let height = itemHeight {
                    subview.snp.makeConstraints { m in
                        m.height.equalTo(height)
                    }
                }
                
                width = subview.snp.width
                height = subview.snp.height
                left = subview.snp.right
                
                /// 每行一个时，换行
                if countInLine == 1 {
                    top = subview.snp.bottom
                    /// 最多一行时
                }else {
                    top = subview.snp.top
                }
                
                paddingY1 = 0
                
            }else {
                
                subview.snp.makeConstraints { (m) in
                    m.width.equalTo(width)
                    m.height.equalTo(height)
                    m.top.equalTo(top).offset(paddingY1)
                    m.left.equalTo(left).offset(paddingX1)
                }
                
                left = subview.snp.right
                
                /// 换行
                if (index + 1) % countInLine == 0{
                    top = subview.snp.bottom
                }else{
                    top = subview.snp.top
                }
                
                paddingY1 = 0
                paddingX1 = paddingX
            }
            
            if index == subViews.count - 1 {
                subview.snp.makeConstraints { (m) in
                    m.bottom.equalToSuperview().inset(bottomMargin).priority(lastBottomPriority)
                }
            }
        }
    }
    
    func getHorVerSpace(alignments: [ZZSnapMutipleViewSetup.Style.Alignment] = []) -> (CGFloat, CGFloat) {
        var horizontalSpace: CGFloat = 0
        var verticalSpace: CGFloat = 0
        
        for alignment in alignments {
            switch alignment{
            case .right(let right):
                horizontalSpace += right
            case .left(let left):
                horizontalSpace += left
            case .top(let top):
                verticalSpace += top
            case .bottom(let bottom):
                verticalSpace += bottom
            case .insets(let insets):
                if let top = insets.top {
                    verticalSpace += top
                }
                if let left = insets.left {
                    horizontalSpace += left
                }
                if let right = insets.right {
                    horizontalSpace += right
                }
                if let bottom = insets.bottom {
                    verticalSpace += bottom
                }
            default:
                break
            }
        }
        
        return (horizontalSpace, verticalSpace)
    }
    
    /// 使用snp批量设置垂直子视图，每个之间平均距离相同，并居中
    /// - Parameter subViews: 子视图列表
    /// - Parameter space: 垂直间距，不设为自适应
    /// - Parameter insets: 内边距
    /// - Parameter alignments: 对齐方式
    func zz_setupVerticalSubViews(
        views subViews: [UIView],
        space: CGFloat?,
        alignments: [ZZSnapMutipleViewSetup.Style.Alignment],
        insets: ZZSnapMutipleViewSetup.Insets?,
        bottomPriority: ConstraintPriority,
        alignmentPriority: ConstraintPriority
    ) {
        if subViews.count == 0 {
            return
        }
        
        var spaceViews: [UIView]? = nil
        if space == nil {
            spaceViews = (0..<subViews.count - 1).compactMap { (index) -> UIView in
                let view = UIView()
                view.tag = index
                self.addSubview(view)
                return view
            }
        }
        
        var top = self.snp.top
        var firstSpaceView : UIView?
        var lastFlexView: ZZSnapMutipleViewSetupFlex?
        
        for (index, subView) in subViews.enumerated() {
            subView.removeFromSuperview()
            addSubview(subView)
            
            let constraintView = (subView as? ZZSnapMutipleViewSetupConstraint)
            var topConstraint: Constraint?
            var bottomConstraint: Constraint?

            if let scrollView = subView as? UIScrollView {
                scrollView.snp.makeConstraints { make in
                    make.width.equalToSuperview().offset(0).priority(.high)
                }
            }
            zz_setupSubViewAlignments(subView, alignments: alignments, isVertical: true, insets: insets, lastFlexView: &lastFlexView, alignmentPriority: alignmentPriority)
            
            if index == 0 {
                subView.snp.makeConstraints { (m) in
                    topConstraint = m.top.equalToSuperview().offset(insets?.top ?? 0).constraint
                }
            }else {
                subView.snp.makeConstraints { (m) in
                    topConstraint = m.top.equalTo(top).offset(space ?? 0).constraint
                }
            }
            
            if index == subViews.count - 1{
                if let bottom = insets?.bottom {
                    subView.snp.makeConstraints { (m) in
                        bottomConstraint = m.bottom.equalToSuperview().offset(-bottom).priority(bottomPriority).constraint
                    }
                }else{
                    subView.snp.makeConstraints { (m) in
                        bottomConstraint = m.bottom.equalToSuperview().priority(bottomPriority).constraint
                    }
                }
                
                if let scrollView = self as? UIScrollView {
                    let (horSpace, verSpace) = getHorVerSpace(alignments: alignments)
                    
                    scrollView.snp.makeConstraints { make in
                        make.width.equalTo(subView).offset((insets?.left ?? 0) + (insets?.right ?? 0) + horSpace)
                        make.bottom.equalTo(subView).offset((insets?.bottom ?? 0) - verSpace)
                    }
                }
            }
            
            if let spaceView = spaceViews?[zz_safe: index]{
                if index == 0{
                    if let space = space {
                        spaceView.snp.makeConstraints { (m) in
                            m.height.equalTo(space)
                        }
                    }
                    firstSpaceView = spaceView
                }else if let firstSpaceView = firstSpaceView{
                    spaceView.snp.makeConstraints { (m) in
                        m.height.equalTo(firstSpaceView)
                    }
                }
                spaceView.snp.makeConstraints { (m) in
                    m.top.equalTo(subView.snp.bottom)
                    m.centerX.equalToSuperview()
                    m.left.equalToSuperview()
                }
                top = spaceView.snp.bottom
            }else{
                top = subView.snp.bottom
            }
            
            constraintView?.zz_topConstraint = topConstraint
            constraintView?.zz_bottomConstraint = bottomConstraint
        }
    }
    
    /// 使用snp批量设置水平子视图，每个之间平均距离相同，并居中
    /// - Parameter subViews: 子视图列表
    /// - Parameter space: 间距宽度，不设为自适应
    /// - Parameter insets: 内边距
    /// - Parameter alignments: 对齐方式
    func zz_setupHorizontalSubViews(
        views subViews: [UIView],
        space: CGFloat?,
        alignments: [ZZSnapMutipleViewSetup.Style.Alignment],
        insets: ZZSnapMutipleViewSetup.Insets?,
        rightPriority: ConstraintPriority,
        alignmentPriority: ConstraintPriority
    ) {
        if subViews.count == 0 {
            return
        }
        
        var spaceViews: [UIView]? = nil
        if space == nil {
            spaceViews = (0..<subViews.count - 1).compactMap { (index) -> UIView in
                let view = UIView()
                view.tag = index
                self.addSubview(view)
                return view
            }
        }
        
        var left = self.snp.left
        var firstSpaceView : UIView?
        var lastFlexView: ZZSnapMutipleViewSetupFlex?
        
        for (index, subView) in subViews.enumerated() {
            subView.removeFromSuperview()
            addSubview(subView)
            
            let constraintView = (subView as? ZZSnapMutipleViewSetupConstraint)
            var leftConstraint: Constraint?
            var rightConstraint: Constraint?

            if let scrollView = subView as? UIScrollView {
                scrollView.snp.makeConstraints { make in
                    make.height.equalToSuperview().offset(0).priority(.high)
                }
            }
            zz_setupSubViewAlignments(subView, alignments: alignments, isVertical: false, insets: insets, lastFlexView: &lastFlexView, alignmentPriority: alignmentPriority)
            
            if index == 0 {
                subView.snp.makeConstraints { (m) in
                    leftConstraint = m.left.equalToSuperview().offset((insets?.left ?? 0)).constraint
                }
            }else {
                subView.snp.makeConstraints { (m) in
                    leftConstraint = m.left.equalTo(left).offset(space ?? 0).constraint
                }
            }
            
            if index == subViews.count - 1{
                if let right = insets?.right {
                    subView.snp.makeConstraints { (m) in
                        rightConstraint = m.right.equalToSuperview().offset(-right).priority(rightPriority).constraint
                    }
                }else{
                    subView.snp.makeConstraints { (m) in
                        rightConstraint = m.right.equalToSuperview().priority(rightPriority).constraint
                    }
                }
                
                if let scrollView = self as? UIScrollView {
                    let (horSpace, verSpace) = getHorVerSpace(alignments: alignments)
                    scrollView.snp.makeConstraints { make in
                        make.height.equalTo(subView).offset((insets?.top ?? 0) + (insets?.bottom ?? 0) + horSpace)
                        make.right.equalTo(subView).offset((insets?.right ?? 0) + verSpace)
                    }
                }
            }
            
            if let spaceView = spaceViews?[zz_safe: index]{
                if index == 0{
                    if let space = space {
                        spaceView.snp.makeConstraints { (m) in
                            m.width.equalTo(space)
                        }
                    }
                    firstSpaceView = spaceView
                }else if let firstSpaceView = firstSpaceView{
                    spaceView.snp.makeConstraints { (m) in
                        m.width.equalTo(firstSpaceView)
                    }
                }
                spaceView.snp.makeConstraints { (m) in
                    m.left.equalTo(subView.snp.right)
                    m.centerY.equalToSuperview()
                    m.top.equalToSuperview()
                }
                left = spaceView.snp.right
            }else{
                left = subView.snp.right
            }
            
            constraintView?.zz_leftConstraint = leftConstraint
            constraintView?.zz_rightConstraint = rightConstraint
        }
    }
    
    
    func zz_setupSubViewAlignments(
        _ subView: UIView,
        alignments: [ZZSnapMutipleViewSetup.Style.Alignment],
        isVertical: Bool? = nil,
        insets: ZZSnapMutipleViewSetup.Insets? = .zero,
        isMustAlignment: Bool = false,
        lastFlexView: inout ZZSnapMutipleViewSetupFlex?,
        isRepeat: Bool = false,
        alignmentPriority: ConstraintPriority
    ) {
        
        if !isMustAlignment, specialConstraints(view: subView, isVertical: isVertical, lastFlexView: &lastFlexView, alignmentPriority: alignmentPriority){
            return
        }
        
        var topAlignment: ZZSnapMutipleViewSetup.Style.Alignment? = nil
        var bottomAlignment: ZZSnapMutipleViewSetup.Style.Alignment? = nil
        var rightAlignment: ZZSnapMutipleViewSetup.Style.Alignment? = nil
        var leftAlignment: ZZSnapMutipleViewSetup.Style.Alignment? = nil
        var centerAlignment: ZZSnapMutipleViewSetup.Style.Alignment? = nil
        
        var topPadding: CGFloat = insets?.top ?? .zero
        var bottomPadding: CGFloat = insets?.bottom ?? .zero
        var rightPadding: CGFloat = insets?.right ?? .zero
        var leftPadding: CGFloat = insets?.left ?? .zero
        
        
        let constraintView = (subView as? ZZSnapMutipleViewSetupConstraint)
        var leftConstraint: Constraint?
        var rightConstraint: Constraint?
        var topConstraint: Constraint?
        var bottomConstraint: Constraint?
        
        for alignment in alignments {
            switch alignment {
            case .insets(let insets):
                if let top = insets.top {
                    topPadding += top
                    zz_setupSubViewAlignments(subView, alignments: [.top(top)], isVertical: isVertical, insets: nil, isMustAlignment: isMustAlignment, lastFlexView: &lastFlexView, isRepeat: true, alignmentPriority: alignmentPriority)
                    topAlignment = .top(top)
                }
                if let left = insets.left {
                    leftPadding += left
                    zz_setupSubViewAlignments(subView, alignments: [.left(left)], isVertical: isVertical, insets: nil, isMustAlignment: isMustAlignment, lastFlexView: &lastFlexView, isRepeat: true, alignmentPriority: alignmentPriority)
                    leftAlignment = .left(left)
                }
                if let right = insets.right {
                    rightPadding = right
                    zz_setupSubViewAlignments(subView, alignments: [.right(right)], isVertical: isVertical, insets: nil, isMustAlignment: isMustAlignment, lastFlexView: &lastFlexView, isRepeat: true, alignmentPriority: alignmentPriority)
                    rightAlignment = .right(right)
                }
                if let bottom = insets.bottom {
                    bottomPadding = bottom
                    zz_setupSubViewAlignments(subView, alignments: [.bottom(bottom)], isVertical: isVertical, insets: nil, isMustAlignment: isMustAlignment, lastFlexView: &lastFlexView, isRepeat: true, alignmentPriority: alignmentPriority)
                    bottomAlignment = .bottom(bottom)
                }
            case .top(let padding):
                topAlignment = alignment
                if isVertical == true {
                    
                }else{
                    topPadding += padding
                    
                    subView.snp.makeConstraints { (m) in
                        topConstraint = m.top.equalToSuperview().offset(topPadding).priority(alignmentPriority).constraint
                    }
                    
                    if let scrollView = subView as? UIScrollView {
                        scrollView.contentSize.height += topPadding
                        scrollView.snp.updateConstraints { make in
                            make.height.equalToSuperview().offset(-scrollView.contentSize.height).priority(.high)
                        }
                    }
                    
                }
            case .bottom(let padding):
                bottomAlignment = alignment
                if isVertical == true {
                    
                }else{
                    bottomPadding += padding
                    
                    subView.snp.makeConstraints { (m) in
                        bottomConstraint = m.bottom.equalToSuperview().offset(-bottomPadding).priority(alignmentPriority).constraint
                    }
                    
                    if let scrollView = subView as? UIScrollView {
                        scrollView.contentSize.height += bottomPadding
                        scrollView.snp.updateConstraints { make in
                            make.height.equalToSuperview().offset(-scrollView.contentSize.height).priority(.high)
                        }
                    }
                }
            case .center(let padding):
                centerAlignment = alignment
                if let isVertical = isVertical {
                    if isVertical {
                        subView.snp.makeConstraints { (m) in
                            m.centerX.equalToSuperview().offset(padding).priority(alignmentPriority)
                        }
                    } else {
                        subView.snp.makeConstraints { (m) in
                            m.centerY.equalToSuperview().offset(padding).priority(alignmentPriority)
                        }
                    }
                }else{
                    subView.snp.makeConstraints { (m) in
                        m.center.equalToSuperview().offset(padding).priority(alignmentPriority)
                    }
                }
            case .left(let padding):
                leftAlignment = alignment
                if isVertical == false {
                    
                }else{
                    leftPadding += padding
                    subView.snp.makeConstraints { (m) in
                        leftConstraint = m.left.equalToSuperview().offset(leftPadding).priority(alignmentPriority).constraint
                    }
                    if let scrollView = subView as? UIScrollView {
                        scrollView.contentSize.width += leftPadding
                        scrollView.snp.updateConstraints { make in
                            make.width.equalToSuperview().offset(-scrollView.contentSize.width).priority(.high)
                        }
                    }
                }
            case .right(let padding):
                rightAlignment = alignment
                if isVertical == false {
                    
                }else{
                    rightPadding += padding
                    
                    subView.snp.makeConstraints { (m) in
                        rightConstraint = m.right.equalToSuperview().offset(-rightPadding).priority(alignmentPriority).constraint
                    }
                    
                    if let scrollView = subView as? UIScrollView {
                        scrollView.contentSize.width += rightPadding
                        scrollView.snp.updateConstraints { make in
                            make.width.equalToSuperview().offset(-scrollView.contentSize.width).priority(.high)
                        }
                    }
                }
            }
        }
        
        if isRepeat {
            return
        }
        
        if let isVertical = isVertical {
            if isVertical {
                if centerAlignment == nil {
                    if leftAlignment == nil, rightAlignment == nil {
                        subView.snp.makeConstraints { make in
                            leftConstraint = make.left.equalToSuperview().offset(leftPadding).priority(alignmentPriority).constraint
                            rightConstraint = make.right.equalToSuperview().offset(-rightPadding).priority(alignmentPriority).constraint
                        }
                    }
                }
            } else {
                if centerAlignment == nil {
                    if topAlignment == nil, bottomAlignment == nil {
                        subView.snp.makeConstraints { make in
                            bottomConstraint = make.bottom.equalToSuperview().offset(-bottomPadding).priority(alignmentPriority).constraint
                            topConstraint = make.top.equalToSuperview().offset(topPadding).priority(alignmentPriority).constraint
                        }
                    }
                }
            }
        }
        
        constraintView?.zz_topConstraint = topConstraint
        constraintView?.zz_rightConstraint = rightConstraint
        constraintView?.zz_bottomConstraint = bottomConstraint
        constraintView?.zz_leftConstraint = leftConstraint
    }
    
    
    fileprivate
    func specialConstraints(
        view subView: UIView,
        isVertical: Bool?,
        lastFlexView: inout ZZSnapMutipleViewSetupFlex?,
        alignmentPriority: ConstraintPriority
    ) -> Bool{
        var isBool = false
        
        if let containView = subView as? ZZSnapMutipleViewSetupContain{
            isBool = true
            containView.zz_setup()
        }
        
        if let alignmentView = subView as? ZZSnapMutipleViewSetupAlignment {
            if !alignmentView.zz_alignments.isEmpty {
                isBool = true
                zz_setupSubViewAlignments(alignmentView, alignments: alignmentView.zz_alignments, isVertical: isVertical, isMustAlignment: true,  lastFlexView: &lastFlexView, alignmentPriority: alignmentPriority)
            }
        }
        
        if let flexView = subView as? ZZSnapMutipleViewSetupFlex{
            isBool = true
            if let isVertical = isVertical {
                if isVertical {
                    flexView.snp.makeConstraints { (m) in
                        m.width.lessThanOrEqualToSuperview().priority(.high)
                    }
                    lastFlexView?.snp.makeConstraints({ make in
                        make.height.equalTo(flexView)
                    })
                }else{
                    flexView.snp.makeConstraints { (m) in
                        m.height.lessThanOrEqualToSuperview().priority(.high)
                    }
                    lastFlexView?.snp.makeConstraints({ make in
                        make.width.equalTo(flexView)
                    })
                }
            }else{
                flexView.snp.makeConstraints { make in
                    make.size.lessThanOrEqualToSuperview().priority(.high)
                }
            }
            
            lastFlexView = flexView
        }
        
        if let spaceView = subView as? ZZSnapMutipleViewSetupSpace{
            isBool = spaceView.zz_isIgnore
            if let zz_width = spaceView.zz_width {
                spaceView.snp.makeConstraints { make in
                    make.width.equalTo(zz_width)
                }
            }
            if let zz_height = spaceView.zz_height {
                spaceView.snp.makeConstraints { make in
                    make.height.equalTo(zz_height)
                }
            }
        }
        
        return isBool
    }
}
