//
//  ArrayExtension.swift
//  BrainBank
//
//  Created by zerry on 2021/1/20.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit

public
extension Array {
    /// 添加数组下标越界处理的扩展方法
    subscript (safe index: Int) -> Element? {
        return (0 ..< count).contains(index) ? self[index] : nil
    }
    
    /// 根据 数组 截取 指定个数返回 多个数组的集合
    func splitArray(withSubSize subSize: Int) -> [[Element]] {
        let array = self
        // 数组将被拆分成指定长度数组的个数
        let count = array.count % subSize == 0 ? (array.count / subSize) : (array.count / subSize + 1)
        // 用来保存指定长度数组的可变数组对象
        var arr: [[Element]] = []
        
        // 利用总个数进行循环，将指定长度的元素加入数组
        for i in 0..<count {
            //数组下标
            let index: Int = i * subSize
            //保存拆分的固定长度的数组元素的可变数组
            var arr1: [Element] = []
            //移除子数组的所有元素
            arr1.removeAll()
            
            var j: Int = index
            //将数组下标乘以1、2、3，得到拆分时数组的最大下标值，但最大不能超过数组的总大小
            while j < subSize * (i + 1) && j < array.count  {
                arr1.append(array[j])
                j += 1
            }
            //将子数组添加到保存子数组的数组中
            arr.append(arr1)
        }
        
        return arr
    }
    
    // 去重
    // 返回值 新数组 及 第一个重复位置
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E)
    -> (newArray: [Element], exitIndex: Int) {
        var result = [Element]()
        var int = -1
        for (index,value) in self.enumerated() {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }else{
                int = index
            }
        }
        return (result,int)
    }
    
    ///转换成NSMutableArray
    func arrayTurnNSMutableArray(_ array: [Any]? = nil) -> NSMutableArray {
        return (array ?? self).mutableArray
    }
    
    var mutableArray : NSMutableArray{
        return NSMutableArray.init(array: self)
    }
    
    /// 倒数第二个
    var preLast: Element?{
        return self[safe: self.count - 2]
    }
    
    /// 整数分割
    /// [1,2,3,4,5,6,7,8,9]
    /// - Parameter subSize: subSize = 4,subSize = 5
    /// - Returns: [1,2,3,4,5,6,7,8],[1,2,3,4,5]
    func splitRemoveLast(_ subSize: Int, maxCount: Int? = nil) -> [Element]{
        if subSize == 0 {
            return self
        }
        
        let rest = self.count % subSize
        if rest == 0 {
            return self
        }
        
        var index = self.count - rest
        if let maxCount = maxCount {
            index = Swift.min(maxCount, index)
        }
        
        return Array((self[0..<index]))
    }
}

extension Array where Element: Equatable {
    mutating func removes(_ objects: [Element]) {
        for value in objects {
            self.remove(value)
        }
    }
    
    mutating func remove(_ object: Element) {
        for (index,value) in self.enumerated() {
            if value == object {
                remove(at: index)
            }
        }
//        if let index = firstIndex(of: object) {
//            remove(at: index)
//        }
//
//        if let index = lastIndex(of: object) {
//            remove(at: index)
//        }
    }
}

extension Array where Element: UIView {
    
    mutating func createOrRemove(_ count: Int, inView: UIView){
        if count < self.count{
            for index in count..<self.count {
                self[index].removeFromSuperview()
            }
            self = Array(self[0..<count])
        }else{
            var array = self
            for _ in self.count..<count {
                let view = Element.init()
                inView.addSubview(view)
                array.append(view)
            }
            self = array
        }
    }
}

extension Array where Element : Hashable {
    /// 去重
    var removalDuplicate: [Element] {
        var uniq = Set<Element>()
        uniq.reserveCapacity(self.count)
        return self.filter {
            return uniq.insert($0).inserted
        }
    }
}
