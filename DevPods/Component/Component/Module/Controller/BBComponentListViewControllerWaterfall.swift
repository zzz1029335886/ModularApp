//
//  BBComponentListViewControllerWaterfall.swift
//  Component
//
//  Created by zerry on 2022/4/8.
//

import UIKit
import CHTCollectionViewWaterfallLayout

extension BBComponentViewController: CHTCollectionViewDelegateWaterfallLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionController = adapter.sectionController(forSection: indexPath.section)
        let size = sectionController?.sizeForItem(at: indexPath.row) ?? .zero
        print(size)
        return size
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               heightForHeaderIn section: Int) -> CGFloat{
        let sectionController = adapter.sectionController(forSection: section)
        return sectionController?.supplementaryViewSource?.sizeForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: section).height ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               heightForFooterIn section: Int) -> CGFloat{
        let sectionController = adapter.sectionController(forSection: section)
        return sectionController?.supplementaryViewSource?.sizeForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: section).height ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetsFor section: Int) -> UIEdgeInsets{
        let sectionController = adapter.sectionController(forSection: section)
        return sectionController?.inset ?? .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingFor section: Int) -> CGFloat{
        let sectionController = adapter.sectionController(forSection: section)
        return sectionController?.minimumLineSpacing ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               columnCountFor section: Int) -> Int{
        let sectionController = adapter.sectionController(forSection: section) as? BBComponentSectionController
        return sectionController?.columnCountForSection ?? 1
    }
}
