//
//  StringExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/1/19.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

extension String{
    /// 删除最后的换行
    var removeLastReturn: String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    //使用正则表达式替换
    func pregReplace(pattern: String,
                     with: String,
                     options: NSRegularExpression.Options = .allowCommentsAndWhitespace)
    -> String {
        do{
            let regex = try NSRegularExpression.init(pattern: pattern, options: options)
            return regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: with)
        }catch{
            return ""
        }
    }
    
    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
    
    var floatValue: CGFloat {
        return CGFloat.init((self as NSString).floatValue)
    }
    
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
    var integerValue: Int {
        return (self as NSString).integerValue
    }
    
    func splitString(_ separator: Character) -> [String] {
        return self.split(separator: separator)
            .compactMap {
                (substring) -> String in
                return String.init(substring)
            }
    }
    
    func contain(subStr: String) -> Bool {
        return (self as NSString).range(of: subStr).length > 0
    }
    
    var isVideoUrl: Bool {
        let str = self.lowercased()
        return str.hasSuffix(".mp4") || str.hasSuffix(".avi") || str.hasSuffix(".mov") || str.hasSuffix(".rmvb") || str.hasSuffix(".flv") || str.hasSuffix("mkv")
    }
    
    var isBlank: Bool {
        let trimmedStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedStr.isEmpty
    }
    
    ///html适配
    func stringToHTML() -> String {
        return self
        //        let headerStr = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>\(self)"
        //        return headerStr
    }
    
    /// 截取字符串
    func substringWithRange(range: NSRange) -> String? {
        if let range0 = self.toRange(range) {
            return String.init(self[range0])
        }else{
            return nil
        }
    }
    
    ///日期字符串转Date
    func getConversionDateTime(dateFormat: String = "yyyy-MM-dd HH:mm:ss")-> Date{
        let formatter = DateFormatter.init()
        formatter.dateFormat = dateFormat
        return formatter.date(from: self) ?? Date()
    }
    
    ///获取关闭的时间
    func getDownTime(_ startTime:Int) -> String {
        let date = Date.init()
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeZone = TimeZone.init(identifier: "Asia/Beijing")
        formatter.timeZone = timeZone
        let time = startTime * 60
        let lastWeek = date.addingTimeInterval(TimeInterval(time))
        let dateTime = formatter.string(from:lastWeek)
        return dateTime
    }
    
    ///对比时间
    func getCompareTime(_ oneDay:String,_ anotherDay:String) -> Int{
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let dateA = formatter.date(from: oneDay),let dateB = formatter.date(from: anotherDay){
            let result = dateA.compare(dateB)
            if result == .orderedDescending {//说明当前时间大于指定时间
                return 1
            }else if result == .orderedAscending {//说明当前时间小于指定时间
                return -1
            }else {
                return 0
            }
        }else{
            return 0
        }
    }
    
    
    ///获取当前时间
    func getCurrentTime(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = dateFormat
        let timeZone = TimeZone.init(identifier: "Asia/Beijing")
        formatter.timeZone = timeZone
        let dateTime = formatter.string(from: Date.init())
        return dateTime
    }
    
    /// 类方法 时间戳转化为时间date
    static func stringConvertDate(timeStamp: String) -> Date {
        return timeStamp.dateValue
    }
    
    
    /// 时间戳转化为时间date
    var dateValue: Date {
        var timeSta: TimeInterval
        if self.count >= 11 {
            timeSta = self.doubleValue / 1000
        }else{
            timeSta = self.doubleValue
        }
        let date = Date(timeIntervalSince1970: timeSta)
        return date
    }
    
    
    /// 时间戳转化为时间字符串
    static func getDateFormatString(timeStamp: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String{
        return timeStamp.dateFormatString(dateFormat: dateFormat)
    }
    
    /// 时间戳转化为时间字符串
    func dateFormatString(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String{
        let timeSta: TimeInterval = self.doubleValue.realTime
        return timeSta.dateFormatString(dateFormat: dateFormat)
    }
    
    /// 时间转化为时间戳
    func toTimeStamp(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String? {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = dateFormat
        guard let date = dfmatter.date(from: self) else { return nil }
        let dateStamp : TimeInterval = date.timeIntervalSince1970
        let dateSt: Int = Int(dateStamp * 1000)
        return String(dateSt)
    }
    
    /// 时间转化为时间戳
    static func stringToTimeStamp(stringTime: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String? {
        return stringTime.toTimeStamp(dateFormat: dateFormat)
    }
    
    // MARK: - 把秒数转换成天时分秒（00天00时00分00秒）格式
    ///
    /// - Parameter time: time(Float格式)
    static func transToDayHourMinSec(time: Int) -> String
    {
        let allTime = time
        var leftTime = 0
        
        var days = 0
        var hours = 0
        var minutes = 0
        var seconds = 0
        
        days = Int(allTime / 3600 / 24)
        leftTime = allTime  - days * 24 * 3600
        
        hours = Int(leftTime / 3600)
        leftTime = leftTime - hours * 3600
        
        minutes = Int(leftTime / 60)
        leftTime = leftTime - minutes * 60
        
        seconds = leftTime
        
        let result = String(format: "%02d天%02d时%02d分%02d秒", days, hours, minutes,seconds)
        return result
    }
    
    /// 根据出生日期返回年龄的方法
    static func dateToOld(bornDate: Date) -> Int{
        return bornDate.toOld()
    }
    
    /// 根据身份证号获取年龄
    func calculateAge() -> Int? {
        let dateStr = self.subsIdDateString()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let birthDate = formatter.date(from: dateStr)
        return birthDate?.toOld()
    }
    
    /// 根据身份证号获取年龄
    static func calculateAgeStr(str: String) -> Int {
        return str.calculateAge() ?? 0
    }
    
    /// 截取身份证的出生年月日
    func subsIdDateString() -> String {
        let result = NSMutableString.init(capacity: 0)
        let dateStr = self.substringWithRange(range: NSMakeRange(6, 8))
        let year = dateStr?.substringWithRange(range:NSMakeRange(0, 4))
        let month = dateStr?.substringWithRange(range:NSMakeRange(4, 2))
        let day = dateStr?.substringWithRange(range:NSMakeRange(6, 2))
        result.append(year ?? "")
        result.append("-")
        result.append(month ?? "")
        result.append("-")
        result.append(day ?? "")
        return result as String
    }
    
    /// 截取身份证的出生日期并转换为日期格式
    static func subsIDStrToDate(str: String) -> String {
        return str.subsIdDateString()
    }
    
    
    func checkIdentityCardNumber(_ number: String) -> Bool {
        //判断位数
        if number.count != 15 && number.count != 18 {
            return false
        }
        var carid = number
        
        var lSumQT = 0
        
        //加权因子
        let R = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
        
        //校验码
        let sChecker: [Int8] = [49,48,88, 57, 56, 55, 54, 53, 52, 51, 50]
        
        //将15位身份证号转换成18位
        let mString = NSMutableString.init(string: number)
        
        if number.count == 15 {
            mString.insert("19", at: 6)
            var p = 0
            let pid = mString.utf8String
            for i in 0...16 {
                let t = Int(pid![i])
                p += (t - 48) * R[i]
            }
            let o = p % 11
            let stringContent = NSString(format: "%c", sChecker[o])
            mString.insert(stringContent as String, at: mString.length)
            carid = mString as String
        }
        
        let cStartIndex = carid.startIndex
        let _ = carid.endIndex
        let index = carid.index(cStartIndex, offsetBy: 2)
        //判断地区码
        let sProvince = String(carid[cStartIndex..<index])
        if (!self.areaCodeAt(sProvince)) {
            return false
        }
        
        //判断年月日是否有效
        //年份
        let yStartIndex = carid.index(cStartIndex, offsetBy: 6)
        let yEndIndex = carid.index(yStartIndex, offsetBy: 4)
        let strYear = Int(carid[yStartIndex..<yEndIndex])
        
        //月份
        let mStartIndex = carid.index(yEndIndex, offsetBy: 0)
        let mEndIndex = carid.index(mStartIndex, offsetBy: 2)
        let strMonth = Int(carid[mStartIndex..<mEndIndex])
        
        //日
        let dStartIndex = carid.index(mEndIndex, offsetBy: 0)
        let dEndIndex = carid.index(dStartIndex, offsetBy: 2)
        let strDay = Int(carid[dStartIndex..<dEndIndex])
        
        let localZone = NSTimeZone.local
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = localZone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = dateFormatter.date(from: "\(String(format: "%02d",strYear!))-\(String(format: "%02d",strMonth!))-\(String(format: "%02d",strDay!)) 12:01:01")
        
        if date == nil {
            return false
        }
        let paperId = carid.utf8CString
        //检验长度
        if 18 != carid.count {
            return false
        }
        //校验数字
        func isDigit(c: Int) -> Bool {
            return 0 <= c && c <= 9
        }
        for i in 0...18 {
            let id = Int(paperId[i])
            if isDigit(c: id) && !(88 == id || 120 == id) && 17 == i {
                return false
            }
        }
        //验证最末的校验码
        for i in 0...16 {
            let v = Int(paperId[i])
            lSumQT += (v - 48) * R[i]
        }
        if sChecker[lSumQT%11] != paperId[17] {
            return false
        }
        return true
    }
    func areaCodeAt(_ code: String) -> Bool {
        var dic: [String: String] = [:]
        dic["11"] = "北京"
        dic["12"] = "天津"
        dic["13"] = "河北"
        dic["14"] = "山西"
        dic["15"] = "内蒙古"
        dic["21"] = "辽宁"
        dic["22"] = "吉林"
        dic["23"] = "黑龙江"
        dic["31"] = "上海"
        dic["32"] = "江苏"
        dic["33"] = "浙江"
        dic["34"] = "安徽"
        dic["35"] = "福建"
        dic["36"] = "江西"
        dic["37"] = "山东"
        dic["41"] = "河南"
        dic["42"] = "湖北"
        dic["43"] = "湖南"
        dic["44"] = "广东"
        dic["45"] = "广西"
        dic["46"] = "海南"
        dic["50"] = "重庆"
        dic["51"] = "四川"
        dic["52"] = "贵州"
        dic["53"] = "云南"
        dic["54"] = "西藏"
        dic["61"] = "陕西"
        dic["62"] = "甘肃"
        dic["63"] = "青海"
        dic["64"] = "宁夏"
        dic["65"] = "新疆"
        dic["71"] = "台湾"
        dic["81"] = "香港"
        dic["82"] = "澳门"
        dic["91"] = "国外"
        if (dic[code] == nil) {
            return false;
        }
        return true;
    }
    
    /// json字符串转字典
    func ext2Dictionary() -> [String: Any]? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        guard let dic = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else {
            return nil
        }
        return dic
    }
    
    /// 计算文本高度
    /// - Parameters:
    ///   - lineWidth: 宽度
    ///   - font: 字号
    ///   - numberOfLines: 行数 0 不限制
    /// - Returns: 高度
    func calculateTextHeight(_ lineWidth: CGFloat,
                             font: UIFont,
                             numberOfLines: Int) -> CGFloat {
        let attributes: [NSAttributedString.Key : Any] = [.font: font]
        let attr = NSAttributedString.init(string: self, attributes: attributes)
        let placeAttr = NSAttributedString.init(string: " ", attributes: attributes)
        return attr.calculateTextHeight(lineWidth, numberOfLines: numberOfLines, placeHolder: placeAttr)
    }
    
    /// 计算文本大小
    func calculateTextSize(fontSize: CGFloat, height: CGFloat) -> CGSize {
        return self.boundingRect(with:CGSize(width:CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [.font:UIFont.systemFont(ofSize: fontSize)], context:nil).size
    }
    
    
    
    /// 计算文本行数
    func calculateTextNumberOfLines(_ lineWidth: CGFloat, font: UIFont) -> Int {
        let content = self as NSString
        if content.length > 0 {
            let textSize = content.boundingRect(with: CGSize.init(width: lineWidth,
                                                                  height: CGFloat.greatestFiniteMagnitude),
                                                options:[.usesLineFragmentOrigin, .usesFontLeading],
                                                attributes: [.font: font],
                                                context: nil)
            let placeHolder: NSString = "占位"
            let rowH = placeHolder.size(withAttributes: [.font: font]).height
            let totalLines: NSInteger = NSInteger(textSize.height / rowH)
            return totalLines
        }else{
            return 0
        }
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    /// 获取url参数
    var urlParams: [String: String?]?{
        if contains("?") {
            let arr = self.splitString("?")
            return arr[safe: 1]?.urlParams
        } else {
            let arr1 = splitString("&")
            var params : [String: String?] = [:]
            for param in arr1 {
                let arr2 = param.splitString("=")
                if let key = arr2[safe: 0]{
                    let value = arr2[safe: 1]
                    params[key] = value
                }
            }
            return params
        }
    }
    
    /*
     *去掉所有空格
     */
    func removeAllSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    //MARK: - 只能输入数字和一个小数点
    func isValidDecimal(maximumFractionDigits:Int)->Bool{
        
        // Depends on you if you consider empty string as valid number
        guard self.isEmpty == false else {
            return true
        }
        
        // Check if valid decimal
        if let _ = String.decimalFormatter.number(from: self),self.count <= 7{
            // Get fraction digits part using separator
            let numberComponents = self.components(separatedBy: decimalSeparator)
            let fractionDigits = numberComponents.count == 2 ? numberComponents.last ?? "" : ""
            return fractionDigits.count <= maximumFractionDigits
        }
        return false
    }
    
    private static let decimalFormatter:NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        return formatter
    }()
    
    private var decimalSeparator:String{
        return String.decimalFormatter.decimalSeparator ?? "."
    }
    
    ///去除字符串里面的特殊字符
    func deleteSpecialCharacters() -> String {
        let pattern: String = "[^a-zA-Z0-9\u{4e00}-\u{9fa5}]"
        let express = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return express.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: "")
    }
    
    func maxCount(_ count: Int, with string: String) -> String {
        if self.count <= count {
            return self
        }
        
        return (self.substringWithRange(range: .init(location: 0, length: count)) ?? self) + string
    }
    
    /// 字符串加星
    /// - Returns: 替换后的值
    func encryptionReplace(_ findex: Int = 3, with string: String = "****") -> String {
        if isIncludeChinese {
            let nsRange = NSRange.init(location: findex, length: string.count)
            if let range = self.toRange(nsRange){
                return self.replacingCharacters(in: range, with: string)
            }
        }
        
        guard self.count >= (findex + string.count) else { return self }
        let start = self.index(self.startIndex, offsetBy: findex)
        let end = self.index(self.startIndex, offsetBy: self.count - findex)
        let range = Range(uncheckedBounds: (lower: start, upper: end))
        return self.replacingCharacters(in: range, with: string)
    }
    
    var isIncludeChinese: Bool{
        for value in self {
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }
    
    
    ///将原始的url编码为合法的url
    func urlEncoded() -> String {
        var charSet = CharacterSet.urlQueryAllowed
        charSet.insert(charactersIn: "?!@#$^&%*+,:;='\"`<>()[]{}/\\| ")
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
                                                            charSet)
        return encodeUrlString ?? ""
    }
    
    ///将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    func openUrl() {
        if let url = URL(string: self), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
//    var md5String: String{
//        var string = self as NSString
//        string = string.replacingOccurrences(of: "\\/", with: "/") as NSString
//        let cStrl = string.cString(using: String.Encoding.utf8.rawValue)
//        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16);
//        CC_MD5(cStrl, CC_LONG(strlen(cStrl!)), buffer);
//        
//        var md5String = ""
//        
//        for idx in 0...15 {
//            let obcStrl = String.init(format: "%02x", buffer[idx]);
//            md5String.append(obcStrl)
//        }
//        
//        free(buffer);
//        return md5String
//    }
    
    ///json字符串转数组
    func getArray() -> NSArray {
        let jsonData: Data = self.data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as! NSArray
        }
        return array as! NSArray
    }
    
    func validateEmail() -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    func validateMobile() -> Bool {
        let phoneRegex: String = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    func numberRMM() -> String {
        guard let num = Double(self) else {
            return ""
        }
        let format = NumberFormatter()
        format.locale = Locale(identifier: "zh_CN")
        format.numberStyle = .spellOut
        format.minimumIntegerDigits = 1
        format.minimumFractionDigits = 0
        format.maximumFractionDigits = 2
        return format.string(from: NSNumber(value: num)) ?? ""
    }
    
    func parameterValid(with data: Any?) -> (result: Bool, data: [String: Any]) {
        if let dic = data as? NSDictionary {
            if let params = dic as? [String: Any] {
                return (true, params)
            }
        }
        return (false, [:])
    }
}
