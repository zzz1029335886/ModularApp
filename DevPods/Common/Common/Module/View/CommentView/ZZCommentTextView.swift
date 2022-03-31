//
//  ZZCommentTextView1.swift
//  CommentTextView
//
//  Created by zerry on 2018/8/1.
//  Copyright © 2018年 zerry. All rights reserved.
//

import UIKit


protocol ZZCommentTextViewDelegate: AnyObject {
    
    func commentTextView(_ textView: ZZCommentTextView, heightDidChanged height: CGFloat)
    func commentTextViewReturnDidClick(_ textView: ZZCommentTextView) -> Bool
    func commentTextViewTextChanged(_ textView: ZZCommentTextView)
    func commentTextViewShouldBeginEditing(_ textView: ZZCommentTextView) -> Bool
    func commentTextViewShouldEndEditing(_ textView: ZZCommentTextView) -> Bool
}

extension ZZCommentTextViewDelegate{
    func commentTextViewTextChanged(_ textView: ZZCommentTextView){}
    func commentTextViewShouldBeginEditing(_ textView: ZZCommentTextView) -> Bool{ return true }
    func commentTextViewShouldEndEditing(_ textView: ZZCommentTextView) -> Bool { return true }
}

class ZZCommentTextView: UITextView {
    
    weak var kDelegate: ZZCommentTextViewDelegate?
    
    var canScroll = false{
        didSet{
            //            self.isScrollEnabled = canScroll
        }
    }
    
    override var text: String!{
        didSet{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.textViewDidChange(self)
            }
        }
    }
    
    var content: String{
        get{
            return plainString
        }
        set{
            text = newValue
        }
    }
    
    private
    var _font: UIFont?
    override var font: UIFont?{
        didSet{
            _font = font
        }
    }
    
    lazy var placeholdLabel = UILabel()
    lazy var countLabel = UILabel()
    var _typingAttributes: [NSAttributedString.Key: Any]?
    
    var placeholderOrigin: CGPoint = .zero{
        didSet{
            self.placeholdLabel.frame.origin = placeholderOrigin
        }
    }
    
    /// 提示文字
    var placeholderString: String?{
        didSet{
            self.checkShowHiddenPlaceholder()
            placeholdLabel.sizeToFit()
        }
    }
    
    var placeholderColor: UIColor?{
        didSet{
            placeholdLabel.textColor = placeholderColor
        }
    }
    
    /// 是否显示计算个数的Label
    var isShowCountLabel: Bool = false {
        didSet{
            countLabel.isHidden = !isShowCountLabel
        }
    }
    /// 限制输入个数   默认为999999，不限制输入
    var limitWords: UInt = 999999
    
    /// 最小高度
    var minHeight: CGFloat = 24{
        didSet{
            self.textContentHeight = max(self.contentSize.height, self.minHeight)
        }
    }
    
    /// 最大高度
    var maxHeight: CGFloat = 125
    
    /// PlaceholerTextView 唯一初始化方法
    convenience init(frame: CGRect,
                     placeholder: String?,
                     placeholderColor: UIColor?
    ) {
        self.init(frame: frame)
        setup(placeholder: placeholder, placeholderColor: placeholderColor)
        self.placeholderString = placeholder
        self.placeholderColor = placeholderColor
    }
    
    private override init(frame: CGRect,
                          textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self._typingAttributes = self.typingAttributes
    }
    
    //XIB 调用
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(placeholder: nil, placeholderColor: nil)
    }
    
    fileprivate var textContentHeight: CGFloat = 25.0
    
}

//MARK: - 自定义UI
extension ZZCommentTextView{
    /// placeholder Label Setup
    fileprivate func setup(placeholder: String?, placeholderColor: UIColor?){
        delegate = self
        
        if font == nil {
            font = UIFont.systemFont(ofSize: 14)
        }
        
        showsHorizontalScrollIndicator = false
        self.textContentHeight = max(self.contentSize.height, self.minHeight)
        
        placeholdLabel.textColor = placeholderColor
        placeholdLabel.textAlignment = .left
        placeholdLabel.font = font
        placeholdLabel.text = placeholder
        placeholdLabel.sizeToFit()
        placeholdLabel.frame.origin = placeholderOrigin
        addSubview(placeholdLabel)
        
        countLabel.font = font
        countLabel.isHidden = isShowCountLabel
        addSubview(countLabel)
        
    }
    
}


//MARK: - UITextViewDelegate代理方法
extension ZZCommentTextView: UITextViewDelegate, UIScrollViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return self.kDelegate?.commentTextViewShouldBeginEditing(self) ?? true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return self.kDelegate?.commentTextViewShouldEndEditing(self) ?? true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkShowHiddenPlaceholder()
        self.resetTextStyle()
        self.kDelegate?.commentTextViewTextChanged(self)
                
        if textView.contentSize.height >= self.maxHeight{
            self.canScroll = true
        }else if textView.contentSize.height < self.minHeight {
            self.canScroll = true
        }else{
            self.canScroll = false
            
            if textView.contentSize.height != self.textContentHeight {
                let height = textView.contentSize.height - self.textContentHeight
                self.kDelegate?.commentTextView(self, heightDidChanged: height)
                self.textContentHeight = max(textView.contentSize.height, self.minHeight)
            }
        }
        
        guard isShowCountLabel else { return }
        
        if self.hasText {
            countLabel.isHidden = true
            return
        }else{
            countLabel.isHidden = false
        }
        
        countLabel.text = "\(textView.text.count)/\(limitWords)"
        countLabel.sizeToFit()
        countLabel.frame.origin = CGPoint(x: frame.width - countLabel.frame.width - 10,
                                          y: frame.height - countLabel.frame.height - 5)
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        self._typingAttributes = self.typingAttributes
        //        for char in text {
        //            if char.isEmoji{
        //                MBProgressHUD.showText("暂不支持输入表情")
        //                return false
        //            }
        //        }
        
        var bool = true
        if text == "\n"{
            if let kDelegate = self.kDelegate{
                bool = kDelegate.commentTextViewReturnDidClick(self)
            }
            
            if !bool{
                return bool
            }
        }
        
        /// 大于等于限制字数，而且不是删除键的时候不可以输入。
        if range.location + range.length >= limitWords && !(text as NSString).isEqual(to: ""){
            bool = false
        }
        
        return bool
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !canScroll {
            scrollView.contentOffset = .zero
        }
    }
    
    
}

//MARK: - 工具方法
extension ZZCommentTextView {
    /// 根据textView是否有内容显示placeholder
    fileprivate
    func checkShowHiddenPlaceholder(){
        if self.hasText {
            placeholdLabel.text = nil
        }else{
            placeholdLabel.text = placeholderString
        }
    }
    
}

extension NSAttributedString{
    var plainString: String{
        let plainString = NSMutableString.init(string: self.string)
        var base = 0
        enumerateAttribute(.attachment, in: .init(location: 0, length: self.length), options: .init(rawValue: 0)) {
            (value, range, stop) in
            if let value = value,
               let att = value as? EmojiTextAttachment {
                plainString.replaceCharacters(in: .init(location: range.location + base, length: range.length), with: att.emojiText)
                base += att.emojiText.count - 1
            }
        }
        return String.init(plainString)
    }
}
extension ZZCommentTextView{
    func removeEmotion() {
        if plainString.isEmpty {
            return
        }
        
        let range = selectedRange
        let location = range.location
        let head = NSString.init(string: text).substring(to: location) as NSString
        
        if range.length == 0 {
            
        }else{
            text = ""
        }
        
        if location > 0 {
            textStorage.deleteCharacters(in: self.lastRange(str: head))
            selectedRange = .init(location: self.lastRange(str: head).location, length: 0)
        } else {
            selectedRange = .init(location: 0, length: 0)
        }
        self.checkShowHiddenPlaceholder()
        self.textViewDidChange(self)
    }
    
    private
    func lastRange(str: NSString) -> NSRange{
        return str.rangeOfComposedCharacterSequence(at: str.length - 1)
    }
    
//    func addEmotion(_ emotion: BBEmotion, size: CGSize = .init(width: 18, height: 18)) {
//        let emojiTextAttachment = EmojiTextAttachment.init()
//        emojiTextAttachment.emojiText = emotion.chs
//        emojiTextAttachment.image = .init(named: emotion.png)
//        emojiTextAttachment.emojiSize = size
//        let str = NSAttributedString(attachment: emojiTextAttachment)
//        let selectedRange = self.selectedRange
//        if selectedRange.length > 0{
//            textStorage.deleteCharacters(in: selectedRange)
//        }
//        textStorage.insert(str, at: self.selectedRange.location)
//        self.selectedRange = .init(location: selectedRange.location + 1, length: 0)
//        resetTextStyle()
//        checkShowHiddenPlaceholder()
//    }
    
    func resetTextStyle() {
        let wholeRange = NSRange.init(location: 0, length: textStorage.length)
//        textStorage.removeAttribute(.font, range: wholeRange)
        let font = _font ?? .systemFont(ofSize: 17)
        textStorage.addAttribute(.font, value: font, range: wholeRange)
    }
    
    var plainString: String{
        if let attributedText = attributedText {
            return attributedText.plainString
        }
        return self.text
    }
}
//extension ZZCommentTextView{
//
//    static var emojiTextPttern = "\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]"
//    static var regExpress: NSRegularExpression?
//
//
//    func getEmojiText(_ content: String) -> NSMutableAttributedString{
//        let attributedString = NSMutableAttributedString.init(string: content, attributes: self._typingAttributes)
//
//        if ZZCommentTextView.regExpress == nil {
//            ZZCommentTextView.regExpress = try? .init(pattern: ZZCommentTextView.emojiTextPttern, options: .allowCommentsAndWhitespace)
//        }
//
//        let matches = ZZCommentTextView.regExpress?.matches(in: content, options: .init(rawValue: 0), range: .init(location: 0, length: content.count))
//        if let matches = matches, !matches.isEmpty {
//            for res in matches.reversed() {
//                if let emojiText = content.substringWithRange(range: res.range),
//                   let attachment = createEmojiAttachment(emojiText){
//                    let rep = NSAttributedString.init(attachment: attachment)
//                    attributedString.replaceCharacters(in: res.range, with: rep)
//                }
//            }
//        }
//
//        return attributedString
//    }
//
//    func createEmojiAttachment(_ emojiText: String) -> NSTextAttachment? {
//        if emojiText.isEmpty {
//            return nil
//        }
//        guard let font = font else { return nil }
//        guard let imageName = BBEmotion.dict[emojiText] else { return nil }
//        guard let image = UIImage.init(named: imageName) else { return nil }
//        let emojiWHScale = image.size.width / image.size.height
//        let emojiSize = CGSize.init(width: font.lineHeight * emojiWHScale, height: font.lineHeight)
//        let imageView = UIImageView(image: image)
//        imageView.frame.size = emojiSize
//        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, UIScreen.main.scale)
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//        imageView.layer.render(in: context)
//        guard let emojiImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
//        UIGraphicsEndImageContext()
//        let attachment = EmojiTextAttachment.init()
//        attachment.emojiText = emojiText
//        attachment.image = emojiImage
//        attachment.bounds = .init(x: 0, y: -3, width: emojiImage.size.width, height: emojiImage.size.height)
//        return attachment
//    }
//}

class EmojiTextAttachment: NSTextAttachment {
    var emojiText: String = ""
    var emojiSize: CGSize = .zero
    
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        return .init(x: 0, y: 0, width: emojiSize.width, height: emojiSize.height)
    }
}
