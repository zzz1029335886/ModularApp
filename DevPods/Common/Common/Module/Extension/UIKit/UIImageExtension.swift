//
//  UIImageExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/3/11.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit
import Kingfisher
import ImageIO
import MobileCoreServices

public typealias CompletionHandler = ((Result<RetrieveImageResult, KingfisherError>) -> Void)

public
extension UIImageView{
    /**
     设置网络图片
     - parameter urlStr : 图片的网络地址
     - parameter placeholder : 占位图片
     */
    func dn_setImage( _ urlStr: String, placeholder: UIImage? = UIImage.init(named: "placeholder_strip"), completionHandler: CompletionHandler? = nil){
        let urlStr = urlStr
        
        guard let url = URL.init(string: urlStr) else {
            self.image = placeholder
            return
        }
        let resource = ImageResource.init(downloadURL: url)
        self.kf.setImage(with: resource, placeholder: placeholder, options: nil, progressBlock: nil, completionHandler: completionHandler)
    }
    
    func bb_setHeadImage(_ headUrlStr: String?, placeholderImage: UIImage? = UIImage.init(named: "placeholder_head")) {
        
        guard let headUrlStr = headUrlStr else {
            self.image = placeholderImage
            return
        }
        
        if headUrlStr.hasPrefix("http") == false {
            self.image = placeholderImage
            return
        }
        
        guard let headUrl = URL.init(string: headUrlStr) else {
            self.image = placeholderImage
            return
        }
        let resource = ImageResource.init(downloadURL: headUrl)
        self.kf.setImage(with: resource, placeholder: placeholderImage, options: nil, progressBlock: nil, completionHandler: nil)
    }
}

extension UIImage{
    
    /// 改变图片
    /// - Parameters:
    ///   - color: 颜色
    ///   - dimension: 尺寸
    /// - Returns: 新图片
    func rechange(color: UIColor? = nil,
                  dimension: CGFloat? = nil)
    -> UIImage
    {
        var drawRect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        var newImage: UIImage
        
        if let dimension = dimension {
            var width: CGFloat
            var height: CGFloat
            let aspectRatio = size.width / size.height
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }
            drawRect = .init(x: 0, y: 0, width: width, height: height)
        }else if color == nil{
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(drawRect.size, false, scale)
        if let color = color {
            color.setFill()
            UIRectFill(drawRect)
            draw(in: drawRect, blendMode: .destinationIn, alpha: 1)
            
        }else{
            draw(in: drawRect)
        }
        
        newImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// 图片旋转
    /// - Parameter radians: 旋转角度
    /// - Returns: 新图片
    func rotate(_ radians: CGFloat) -> UIImage {
        //        let size = CGSize.init(width: self.size.width * self.scale, height: self.size.height * self.scale)
        
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        guard  let context = UIGraphicsGetCurrentContext() else { return self }
        
        let origin = CGPoint(x: rotatedSize.width / 2.0,
                             y: rotatedSize.height / 2.0)
        context.translateBy(x: origin.x, y: origin.y)
        context.rotate(by: radians)
        draw(in: CGRect(x: -origin.y,
                        y: -origin.x,
                        width: size.width,
                        height: size.height))
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage ?? self
    }
    
    class func initFromColor(_ color: UIColor,
                             size: CGSize = CGSize(width: 1, height: 1))
    -> UIImage? {
        return color.toImage(size: size)
    }
    
    ///图片压缩方法
    func resetImgSize(maxImageLenght : CGFloat,
                      maxSizeKB : CGFloat)
    -> Data? {
        
        let sourceImage = self
        var maxSize = maxSizeKB
        var maxImageSize = maxImageLenght
        if (maxSize <= 0.0) {
            maxSize = 1024.0
        }
        
        if (maxImageSize <= 0.0)  {
            maxImageSize = 1024.0
        }
        
        //先调整分辨率
        var newSize = CGSize.init(width: sourceImage.size.width, height: sourceImage.size.height)
        let tempHeight = newSize.height / maxImageSize
        let tempWidth = newSize.width / maxImageSize
        if (tempWidth > 1.0 && tempWidth > tempHeight) {
            newSize = CGSize.init(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
        } else if (tempHeight > 1.0 && tempWidth < tempHeight){
            newSize = CGSize.init(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
        }
        
        UIGraphicsBeginImageContext(newSize)
        
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImageC = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        guard let newImage = newImageC else { return nil }
        guard var imageData = newImage.jpegData(compressionQuality: 1) else { return nil }
        
        var sizeOriginKB : CGFloat = CGFloat(imageData.count) / 1024.0
        
        //调整大小
        var resizeRate = 0.9 as CGFloat
        while (sizeOriginKB > maxSize && resizeRate > 0.1) {
            if let data = newImage.jpegData(compressionQuality: resizeRate){
                imageData = data
            }else{
                break
            }
            sizeOriginKB = CGFloat(imageData.count) / 1024.0
            resizeRate -= 0.1
        }
        
        return imageData
    }
}

// MARK: - 创建图像的自定义方法
extension UIImage {
    
    /// 创建圆角图像
    ///
    /// - Parameters:
    ///   - size: 尺寸
    ///   - backColor: 背景色(默认`white`)
    ///   - lineColor: 线的颜色(默认`lightGray`)
    /// - Returns: 裁切后的图像
    func hq_avatarImage(size: CGSize?,
                        backColor: UIColor = UIColor.white,
                        lineColor: UIColor? = nil) -> UIImage? {
        
        var size = size
        
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        // 1.图像的上下文-内存中开辟一个地址,跟屏幕无关
        /**
         * 1.绘图的尺寸
         * 2.不透明:false(透明) / true(不透明)
         * 3.scale:屏幕分辨率,默认情况下生成的图像使用'1.0'的分辨率,图像质量不好
         *         可以指定'0',会选择当前设备的屏幕分辨率
         */
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        // 背景填充(在裁切之前做填充)
        backColor.setFill()
        UIRectFill(rect)
        
        // 1> 实例化一个圆形的路径
        let path = UIBezierPath(ovalIn: rect)
        // 2> 进行路径裁切 - 后续的绘图,都会出现在圆形路径内部,外部的全部干掉
        path.addClip()
        draw(in: rect)
        
        // 3.绘制内切的圆形
        if let lineColor = lineColor {
            lineColor.setStroke()
            path.lineWidth = 1      // 默认是'1'
        }else{
            
        }
        
        
        path.stroke()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    /// 创建矩形图像
    ///
    /// - Parameters:
    ///   - size: 尺寸
    ///   - backColor: 背景色(默认`white`)
    ///   - lineColor: 线的颜色(默认`lightGray`)
    /// - Returns: 裁切后的图像
    func hq_rectImage(size: CGSize?,
                      backColor: UIColor? = UIColor.white,
                      lineColor: UIColor? = UIColor.lightGray) -> UIImage? {
        
        var size = size
        
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        // 1.图像的上下文-内存中开辟一个地址,跟屏幕无关
        /**
         * 1.绘图的尺寸
         * 2.不透明:false(透明) / true(不透明)
         * 3.scale:屏幕分辨率,默认情况下生成的图像使用'1.0'的分辨率,图像质量不好
         *         可以指定'0',会选择当前设备的屏幕分辨率
         */
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        // 2.绘图'drawInRect'就是在指定区域内拉伸屏幕
        draw(in: rect)
        
        // 3.取得结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 4.关闭上下文
        UIGraphicsEndImageContext()
        
        // 5.返回结果
        return result
    }
    
    // 给定指定宽度，返回结果图像
    func scaleImageTo(width: CGFloat?, height: CGFloat?) -> UIImage {
        
        var width0 : CGFloat = 0
        var height0 : CGFloat = 0
        
        // 1. 计算等比例缩放的高度
        if let width = width, let height = height{
            width0 = width
            height0 = height
        } else if let width = width {
            width0 = width
            height0 = width * size.height / size.width
        } else if let height = height {
            height0 = height
            width0 = height * size.width / size.height
        }
        
        // 2. 图像的上下文
        let s = CGSize(width: width0, height: height0)
        
        var newImage: UIImage
        
        // 5. 获取绘制结果
        UIGraphicsBeginImageContextWithOptions(s, false, scale)
        newImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        // 7. 返回结果
        return newImage
    }
    
    // 给定指定宽度，返回结果图像
    class func imageWithColor(_ color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    //切割圆角
    func clip(
        radius cornerRadius: CGFloat,
        backgroundColor: UIColor? = nil
    ) -> UIImage?{
        
        let size: CGSize = .init(width: self.size.width, height: self.size.height)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

        if let backgroundColor = backgroundColor {
            backgroundColor.setFill()
        }else{
            UIColor.clear.setFill()
        }
        
        UIRectFill(rect)
        let path = UIBezierPath.init(roundedRect: rect, cornerRadius: cornerRadius)
        path.addClip()
        self.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class
    func imageWith(_ any: Any?) -> UIImage? {
        guard let any = any else {
            return nil
        }

        let image: UIImage?
        if let _image = any as? UIImage {
            image = _image
        }else if let string = any as? String{
            if let _image = UIImage.init(named: string){
                image = _image
            }else if FileManager.default.fileExists(atPath: string){
                image = UIImage.init(contentsOfFile: string)
            }else{
                image = nil
            }
        }else if let data = any as? Data{
            image = UIImage.init(data: data)
        }else{
            image = nil
        }
        return image
    }
    
//    - (UIImage *)getImageWithImage:(id)image{
//        UIImage *icon;
//        if ([image isKindOfClass:UIImage.class]) {
//            icon = (UIImage *)image;
//        }else if ([image isKindOfClass:NSString.class]){
//            icon = [UIImage imageNamed:(NSString *)image];
//            if (!icon) {
//                if ([[NSFileManager defaultManager] fileExistsAtPath:(NSString *)image]) {
//                    icon = [UIImage imageWithContentsOfFile:(NSString *)image];
//                }
//            }
//        }else if ([image isKindOfClass:NSData.class]){
//            icon = [UIImage imageWithData:image];
//        }
//        return icon;
//    }
}

