//
//  BBListSectionController.swift
//  BrainBank
//
//  Created by zerry on 2021/9/29.
//  Copyright © 2021 yoao. All rights reserved.
//

import UIKit
import IGListKit
import IGListDiffKit
import CHTCollectionViewWaterfallLayout
import Common

class BBListSectionController: ListSectionController, BBAutoSizeCollectionViewCellLayoutDelegate {
    private var indexCellSize: [Int: CGSize] = [:]
    static let defaultHeight = 0
    
    /// 上次缓存的高度，用于解决刷新时size为zero画面闪烁
    var lastIndexCellSize: [Int: CGSize] = [:]
    
    weak var adapter: ListAdapter?
    var collectionView: UICollectionView?{
        return adapter?.collectionView
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let size: CGSize
        if let _size = indexCellSize[index] {
            size = _size
        }else if let lastSize = lastIndexCellSize[index]{
            size = lastSize
        }else{
            size = .init(width: UIScreen.main.bounds.width, height: CGFloat(BBListSectionController.defaultHeight))
        }
                
        return size
    }
    
    func dequeueAutoSizeReusableCell<Cell: UICollectionViewCell>(
        cacheCell: Cell? = nil,
        of: Cell.Type,
        withReuseIdentifier identifier: String?,
        at: Int
    ) -> Cell{
        let cell = cacheCell ?? dequeueReusableCell(of: of, withReuseIdentifier: identifier, at: at)
        if let autoCell = cell as? BBAutoSizeCollectionViewCell {
            autoCell.layoutDelegate = self
            autoCell.tag = at
            
            let nowHeight = Int(indexCellSize[at]?.height ?? 0)
            let lastHeight = Int(lastIndexCellSize[at]?.height ?? 0)
            
            if nowHeight == lastHeight {
                autoCell.defaultHeight = BBListSectionController.defaultHeight
            }else{
                autoCell.defaultHeight = lastHeight
            }
            
        }
        return cell
    }
    
    func dequeueAutoSizeReusableCell<Cell: UICollectionViewCell>(of: Cell.Type, at: Int) -> Cell{
        let cell = dequeueReusableCell(of: of, at: at)
        if let autoCell = cell as? BBAutoSizeCollectionViewCell {
            autoCell.layoutDelegate = self
            autoCell.tag = at
        }
        return cell
    }
    
    func autoSizeCollectionViewCellReload(_ cell: BBAutoSizeCollectionViewCell) {
        let index = cell.tag
        let lastSize = self.indexCellSize[index]
        self.indexCellSize[index] = nil
        self.lastIndexCellSize[index] = lastSize
        self.reloadIndex(index, isLayout: false, isAnimated: false)
    }
    
    func autoSizeCollectionViewCell(_ cell: BBAutoSizeCollectionViewCell, layout size: CGSize) {
        guard let adapter = adapter else { return }
        let index = cell.tag
        
        if let exitSize = self.indexCellSize[index], exitSize.equalTo(size) {
            return
        }
        
        self.indexCellSize[index] = size
        
        self.reloadIndex(index, isLayout: true, isAnimated: false)
        cell.frame.size = size
        self.displayDelegate?.listAdapter(adapter, willDisplay: self, cell: cell, at: index)
    }
    
    func reload(isLayout: Bool = false) {
        guard let adapter = adapter else {
            
            return
        }
        
        if !isLayout {
            self.indexCellSize.removeAll()
        }
        
        UIView.performWithoutAnimation {
            self.reloadSelf(adapter: adapter)
        }
    }
    
    func reloadIndex(_ index: Int, isLayout: Bool = false, isAnimated: Bool = true){
        guard let adapter = adapter else { return }
        
        if isLayout {
            adapter.updater.reloadData {
                return self.collectionView
            } reloadUpdate: {
                self.reloadSelf(adapter: adapter, index: index)
            } completion: { isCompletion in
                
            }
        }else{
            UIView.performWithoutAnimation {
                self.indexCellSize[index] = nil
                self.reloadSelf(adapter: adapter, index: index)
            }
        }
    }
}

extension ListSectionController{
    func dequeueReusableCell<Cell: UICollectionViewCell>(of: Cell.Type, at: Int) -> Cell {
        let cell = collectionContext?.dequeueReusableCell(of: of, for: self, at: at) as? Cell
        return cell ?? Cell.init()
    }
    
    func dequeueReusableCell<Cell: UICollectionViewCell>(of: Cell.Type, withReuseIdentifier: String?, at: Int) -> Cell {
        let cell = collectionContext?.dequeueReusableCell(of: of, withReuseIdentifier: withReuseIdentifier, for: self, at: at) as? Cell
        return cell ?? Cell.init()
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind: String, class aClass: T.Type, at: Int) -> T {
        let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: ofKind, for: self, class: aClass, at: at) as? T
        return view ?? T.init()
    }
    
    func reloadSelf(adapter: ListAdapter) {
        guard let collectionView = adapter.collectionView else { return }
        let index = adapter.section(for: self)
        if index > 9999 {
            collectionContext?.performBatch(animated: true, updates: { context in
                context.reload(self)
            }, completion: nil)
        } else {
            adapter.updater.reload(collectionView, sections: .init(integer: index))
        }
    }
    
    func reloadSelf(adapter: ListAdapter, index: Int) {
        guard let collectionView = adapter.collectionView else { return }
        let _index = adapter.section(for: self)
        if _index > 9999 {
            collectionContext?.performBatch(animated: true, updates: { context in
                context.reload(self)
            }, completion: nil)
        } else {
            adapter.updater.reloadItem(in: collectionView, from: .init(row: index, section: _index), to: .init(row: index, section: _index))
        }
    }
    
    func scrollToSelf(adapter: ListAdapter?, listModel: ListDiffable) {
        adapter?.bb_scroll(to: listModel, supplementaryKinds: [UICollectionView.elementKindSectionHeader], scrollDirection: .vertical, scrollPosition: .top, offsetY: 0, animated: true)
    }
    
}
