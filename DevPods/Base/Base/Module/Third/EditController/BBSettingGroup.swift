//
//  BBSettingGroup.swift
//  qqncp
//
//  Created by zerry on 2018/9/12.
//  Copyright © 2018年 zerry. All rights reserved.
//

import UIKit
import Common

/**
 组，tableView里的section
 */
open class BBSettingGroup: NSObject {
    public var items: [BBSettingItem] = []
    public var spaceTop: CGFloat = 0.01
    public var spaceBottom: CGFloat = 10.0
    public init(items: [BBSettingItem]) {
        super.init()
        self.items = items
    }
    public override init() {
        super.init()
    }
}

/**
 标题的位置
 */
enum BBSettingItemTitlePosition {
    case top, center, bottom
}

/**
 基类
 */
open class BBSettingItem: NSObject {
    public weak var cell: BBSettingTableViewCell?
    /// cell高度
    public var height: CGFloat?
    /// 底部横线颜色
    public var separatorColor: UIColor? = rgba(0, 0, 0, 0.05)
    /// 底部横线内边距
    public var separatorInsets: UIEdgeInsets? = .zero
    /// 是否刷新
    public var isReload = false
    /// 是否可交互
    public var isUserInteractionEnabled: Bool = true
    /// 内容高度
    public var contentHeight : CGFloat?
    /// 背景颜色
    public var backgroundColor : UIColor?
    
    func reload(_ animation: UITableView.RowAnimation = .none) {
        guard let cell = self.cell else { return }
        guard let tableView = BBSettingItem.tableView(view: cell) else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        tableView.reloadRows(at: [indexPath], with: animation)
    }
    
    static func tableView(view: UIView) -> UITableView? {
        
        guard let superview = view.superview else { return nil }
        
        if superview is UITableView {
            return superview as? UITableView
        }
        
        return tableView(view: superview)
    }
}

public class BBSettingTitleItem: BBSettingItem {
    /// 标题
    public var title: String?
    /// 标题行数
    public var titleNumberOfLines = 1
    /// 标题 左间距
    public var titleLabelPadding = 16 as CGFloat
    /// 标题 上间距
    public var titleLabelPaddingY: CGFloat?
    /// 标题宽度
    public var titleLabelWidth = 120 as CGFloat
    /// 标题颜色
    public var titleTextColor : UIColor?
    /// 标题字体
    public var titleFont : UIFont?

    public var rightView: UIView?
    public var rightViewLeftPadding: CGFloat = 0

    public init(title: String) {
        super.init()
        self.title = title
    }
    
    public override init() {
        super.init()
    }
}

/// 文本
public class BBSettingTitleTextItem: BBSettingTitleItem {
    public var content: String?
    public var contentColor : UIColor?
    public var contentFont : UIFont?
    public var isBottom = false

}

/// 文本编辑
public class BBSettingTitleTextEditItem: BBSettingTitleTextItem {
    /// 占位文字
    public var placeholder: String?
    /// 最大数量
    public var contentLimitCount = 9999
    /// 键盘类型
    public var keyboardType: UIKeyboardType = .default
    /// 键盘右下角按钮类型
    public var returnKeyType: UIReturnKeyType = .default
    /// 是否可交互
    public var isTextUserInteractionEnabled = true
    /// 输入框背景颜色
    public var inputBackgroundColor: UIColor?
    
    public func becomeFirstResponder() {
        cell?.becomeFirstResponder()
    }
}

/**
 Button项，cell带右侧箭头
 */
public class BBSettingButtonItem: BBSettingTitleItem {
    /// 占位文字
    public var placeholder: String?
    /// 内容
    public var content: String?
    /// 对齐方式
    public var textAlignment: NSTextAlignment?
    /// 内容字体
    public var contentFont: UIFont?
    /// 内容颜色
    public var contentColor: UIColor?
    /// 是否可交互
    public var buttonIsUserInteractionEnabled: Bool = false
}

public class BBSettingCustomContentItem: BBSettingTitleItem {
    public var view : UIView?
    public var accessoryType: UITableViewCell.AccessoryType = .none
}

/**
 TextField项，单行编辑
 */
public final class BBSettingTextFieldItem: BBSettingTitleTextEditItem {
    public var textFieldPadding = 0.0 as CGFloat
    public var isSecureTextEntry: Bool = false
    public var textAlignment: NSTextAlignment?
    public var textField: UITextField?
    
    /// 显示的
    public var systemTextField: UITextField!
    
    public var validateType: QQValidate?
    public var validateState: Bool?
    public var validateError: String?
}

/**
 ImageView项，如用户头像
 */
public class BBSettingImageViewItem: BBSettingTitleItem {
    public var image: UIImage?
    public var imageUrl: String?
    public var imagePadding : CGFloat = 15
    public var isRound : Bool = true

}

/**
 提示项
 */
public class BBSettingTipItem: BBSettingTitleItem {
    public var titleAlignment : NSTextAlignment?
    
}

/**
 TextView项，多行编辑，自动伸缩高度
 */
public class BBSettingTextViewItem: BBSettingTitleTextEditItem {
    override public var content: String?{
        get{
            return content1?.count == 0 ? nil : content1
        }
        set{
            content1 = newValue
        }
    }
    fileprivate var content1: String?
    public var originalPoint = CGPoint.zero
    
    
    
}

/**
 上传图片，多张，自动伸缩高度
 */
public class BBSettingUploadImageViewItem: BBSettingTitleItem {
//    public var selectedAssets : [PHAsset]?
    
    /// 图片或URL
    public var imageUrls : [(UIImage?, String?)] = []
    
    /// 最大显示数量
    public var maxCount : Int = 9
    
    /// 是否可编辑
    public var isEdit = true
    
    /// 是否选择视频
    public var isSelectedVideo = false
    
    /// 是否多选
    public var isMultiple = false
    
    /// 是否显示在title下面，否表示显示在右侧
    public var isBottom = false
    
    /// 是否浏览模式，浏览模式下不可上传
    public var isBrowse = false
}

/**
 Switch项
 */
public class BBSettingSwitchItem: BBSettingTitleItem {
    public var isOn = false
    public var onTintColor: UIColor = .systemBlue
}

public protocol BBSettingSelectionItemDelegate: AnyObject{
    func settingSelectionItem(_ item: BBSettingSelectionItem, selected index: Int)
}

/**
 选择项
 */
public class BBSettingSelectionItem: BBSettingTitleItem {
    public var values : [String] = []
    /// 是否单选
    public var isSingle = false
    weak public var delegate : BBSettingSelectionItemDelegate?
    
}

/**
 Custom项，自定义
 */
public class BBSettingCustomViewItem: BBSettingItem {
    public var view : UIView?
    
}
