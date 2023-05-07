//
//  IGListAdapterReloadTask.swift
//  BrainBank
//
//  Created by zerry on 2022/5/10.
//  Copyright © 2022 yoao. All rights reserved.
//

import UIKit
import IGListKit

class IGListAdapterReloadTask: NSObject {
    let queue = DispatchQueue(label: "test.concurrent.queue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .workItem)
    
    func reload(
        collectionView: UICollectionView,
        adapter: ListAdapter,
        section controller: ListSectionController,
        index: Int
    ) {
        queue.async(qos: queue.qos, flags: .barrier) {
            self.execute(collectionView: collectionView, adapter: adapter, section: controller, index: index)
        }
    }
    
    func execute(
        collectionView: UICollectionView,
        adapter: ListAdapter,
        section controller: ListSectionController,
        index: Int
    ) {
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.main.async(execute: {
            adapter.updater.reloadData {
                return collectionView
            } reloadUpdate: {
                controller.reloadSelf(adapter: adapter, index: index)
            } completion: { _ in
                semaphore.signal()
            }
        })
        
        semaphore.wait()
    }
    
}

extension ListAdapter{
    /// 结构体静态key
    private struct ListAdapterKey {
        static var reloadTask = "reloadTask"
    }
    
    /// 事件列表
    var reloadTask: IGListAdapterReloadTask {
        get {
            return objc_getAssociatedObject(self, &ListAdapterKey.reloadTask) as? IGListAdapterReloadTask ?? .init()
        }
        set {
            objc_setAssociatedObject(self, &ListAdapterKey.reloadTask, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func reload(collectionView: UICollectionView, section controller: ListSectionController, index: Int) {
        self.reloadTask.reload(collectionView: collectionView, adapter: self, section: controller, index: index)
    }
}
