//
//  BBComponentViewController.swift
//  Component
//
//  Created by zerry on 2022/4/8.
//

import UIKit
import IGListKit
import IGListDiffKit
import Base
import CHTCollectionViewWaterfallLayout

open
class BBComponentViewController: BBBaseViewController {
    
    var adapter: ListAdapter!
    let updater = ListAdapterUpdater()
    
    var models: [BBComponentListModel] = []
    
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: flowLayout)
        
        self.view.addSubview(collectionView)
        
        adapter = ListAdapter.init(updater: updater, viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        return collectionView
    }()
    
    lazy var flowLayout: CHTCollectionViewWaterfallLayout = {
        let flowLayout = CHTCollectionViewWaterfallLayout.init()
        return flowLayout
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = flowLayout
        collectionView.delegate = self
        self.view.addSubview(collectionView)
        
        let model0 = BBComponentListModel.init()
        let model1 = BBComponentListModel.init()
        let model2 = BBComponentListModel.init()
        
        models = [
            model0, model1, model2
        ]
        
        adapter.reloadData()
    }
    
}

extension BBComponentViewController: ListAdapterDataSource, UIScrollViewDelegate{
    public func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return models
    }
    
    public func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController: BBComponentSectionController
        
        sectionController = BBComponentNormalSectionController.init()
        
        sectionController.adapter = self.adapter
        return sectionController
    }
    
    public func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}


