//
//  IGListAdapter+BB.m
//  BrainBank
//
//  Created by zerry on 2021/10/11.
//  Copyright © 2021 yoao. All rights reserved.
//

#import "IGListAdapter+BB.h"

@implementation IGListAdapter (BB)

- (void)bb_scrollToObject: (id)object
       supplementaryKinds: (NSArray<NSString *> *)supplementaryKinds
          scrollDirection: (UICollectionViewScrollDirection)scrollDirection
           scrollPosition: (UICollectionViewScrollPosition)scrollPosition
                  offsetY: (CGFloat)offsetY
                 animated: (BOOL)animated {
    IGAssertMainThread();
    IGParameterAssert(object != nil);
    
    const NSInteger section = [self sectionForObject:object];
    if (section == NSNotFound) {
        return;
    }
    
    UICollectionView *collectionView = self.collectionView;
    const BOOL avoidLayout = IGListExperimentEnabled(self.experiments, IGListExperimentAvoidLayoutOnScrollToObject);
    
    // Experiment with skipping the forced layout to avoid creating off-screen cells.
    // Calling [collectionView layoutIfNeeded] creates the current visible cells that will no longer be visible after the scroll.
    // We can avoid that by asking the UICollectionView (not the layout object) for the attributes. So if the attributes are not
    // ready, the UICollectionView will call -prepareLayout, return the attributes, but doesn't generate the cells just yet.
    if (!avoidLayout) {
        [collectionView setNeedsLayout];
        [collectionView layoutIfNeeded];
    }
    
    NSIndexPath *indexPathFirstElement = [NSIndexPath indexPathForItem:0 inSection:section];
    
    // collect the layout attributes for the cell and supplementary views for the first index
    // this will break if there are supplementary views beyond item 0
    NSMutableArray<UICollectionViewLayoutAttributes *> *attributes = nil;
    
    const NSInteger numberOfItems = [collectionView numberOfItemsInSection:section];
    if (numberOfItems > 0) {
        attributes = [self _layoutAttributesForItemAndSupplementaryViewAtIndexPath:indexPathFirstElement
                                                                supplementaryKinds:supplementaryKinds].mutableCopy;
        
        if (numberOfItems > 1) {
            NSIndexPath *indexPathLastElement = [NSIndexPath indexPathForItem:(numberOfItems - 1) inSection:section];
            UICollectionViewLayoutAttributes *lastElementattributes = [self _layoutAttributesForItemAndSupplementaryViewAtIndexPath:indexPathLastElement
                                                                                                                 supplementaryKinds:supplementaryKinds].firstObject;
            if (lastElementattributes != nil) {
                [attributes addObject:lastElementattributes];
            }
        }
    } else {
        NSMutableArray *supplementaryAttributes = [NSMutableArray new];
        for (NSString* supplementaryKind in supplementaryKinds) {
            UICollectionViewLayoutAttributes *supplementaryAttribute = [self _layoutAttributesForSupplementaryViewOfKind:supplementaryKind atIndexPath:indexPathFirstElement];
            if (supplementaryAttribute != nil) {
                [supplementaryAttributes addObject: supplementaryAttribute];
            }
        }
        attributes = supplementaryAttributes;
    }
    
    CGFloat offsetMin = 0.0;
    CGFloat offsetMax = 0.0;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        const CGRect frame = attribute.frame;
        CGFloat originMin;
        CGFloat endMax;
        switch (scrollDirection) {
            case UICollectionViewScrollDirectionHorizontal:
                originMin = CGRectGetMinX(frame);
                endMax = CGRectGetMaxX(frame);
                break;
            case UICollectionViewScrollDirectionVertical:
                originMin = CGRectGetMinY(frame);
                endMax = CGRectGetMaxY(frame);
                break;
        }
        
        // find the minimum origin value of all the layout attributes
        if (attribute == attributes.firstObject || originMin < offsetMin) {
            offsetMin = originMin;
        }
        // find the maximum end value of all the layout attributes
        if (attribute == attributes.firstObject || endMax > offsetMax) {
            offsetMax = endMax;
        }
    }
    
    const CGFloat offsetMid = (offsetMin + offsetMax) / 2.0;
    const CGFloat collectionViewWidth = collectionView.bounds.size.width;
    const CGFloat collectionViewHeight = collectionView.bounds.size.height;
    const UIEdgeInsets contentInset = [self bb_contentInset:collectionView];
    CGPoint contentOffset = collectionView.contentOffset;
    switch (scrollDirection) {
        case UICollectionViewScrollDirectionHorizontal: {
            switch (scrollPosition) {
                case UICollectionViewScrollPositionRight:
                    contentOffset.x = offsetMax - collectionViewWidth + contentInset.right;
                    break;
                case UICollectionViewScrollPositionCenteredHorizontally: {
                    const CGFloat insets = (contentInset.left - contentInset.right) / 2.0;
                    contentOffset.x = offsetMid - collectionViewWidth / 2.0 - insets;
                    break;
                }
                case UICollectionViewScrollPositionLeft:
                case UICollectionViewScrollPositionNone:
                case UICollectionViewScrollPositionTop:
                case UICollectionViewScrollPositionBottom:
                case UICollectionViewScrollPositionCenteredVertically:
                    contentOffset.x = offsetMin - contentInset.left;
                    break;
            }
            const CGFloat maxOffsetX = collectionView.contentSize.width - collectionView.frame.size.width + contentInset.right;
            const CGFloat minOffsetX = -contentInset.left;
            contentOffset.x = MIN(contentOffset.x, maxOffsetX);
            contentOffset.x = MAX(contentOffset.x, minOffsetX);
            break;
        }
        case UICollectionViewScrollDirectionVertical: {
            switch (scrollPosition) {
                case UICollectionViewScrollPositionBottom:
                    contentOffset.y = offsetMax - collectionViewHeight + contentInset.bottom;
                    break;
                case UICollectionViewScrollPositionCenteredVertically: {
                    const CGFloat insets = (contentInset.top - contentInset.bottom) / 2.0;
                    contentOffset.y = offsetMid - collectionViewHeight / 2.0 - insets;
                    break;
                }
                case UICollectionViewScrollPositionTop:
                case UICollectionViewScrollPositionNone:
                case UICollectionViewScrollPositionLeft:
                case UICollectionViewScrollPositionRight:
                case UICollectionViewScrollPositionCenteredHorizontally:
                    contentOffset.y = offsetMin - contentInset.top;
                    break;
            }
            CGFloat maxHeight;
            if (avoidLayout) {
                // If we don't call [collectionView layoutIfNeeded], the collectionView.contentSize does not get updated.
                // So lets use the layout object, since it should have been updated by now.
                maxHeight = collectionView.collectionViewLayout.collectionViewContentSize.height;
            } else {
                maxHeight = collectionView.contentSize.height;
            }
            const CGFloat maxOffsetY = maxHeight - collectionView.frame.size.height + contentInset.bottom;
            const CGFloat minOffsetY = -contentInset.top;
            contentOffset.y = MIN(contentOffset.y, maxOffsetY);
            contentOffset.y = MAX(contentOffset.y, minOffsetY);
            break;
        }
    }
    contentOffset.y += offsetY;
    
    [collectionView setContentOffset:contentOffset animated:animated];
}


- (NSArray<UICollectionViewLayoutAttributes *> *)_layoutAttributesForItemAndSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath
                                                                                      supplementaryKinds:(NSArray<NSString *> *)supplementaryKinds {
    NSMutableArray<UICollectionViewLayoutAttributes *> *attributes = [NSMutableArray new];
    
    UICollectionViewLayoutAttributes *cellAttributes = [self _layoutAttributesForItemAtIndexPath:indexPath];
    if (cellAttributes) {
        [attributes addObject:cellAttributes];
    }
    
    for (NSString *kind in supplementaryKinds) {
        UICollectionViewLayoutAttributes *supplementaryAttributes = [self _layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
        if (supplementaryAttributes) {
            [attributes addObject:supplementaryAttributes];
        }
    }
    
    return attributes;
}

- (nullable UICollectionViewLayoutAttributes *)_layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (IGListExperimentEnabled(self.experiments, IGListExperimentAvoidLayoutOnScrollToObject)) {
        return [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    } else {
        return [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    }
}


- (nullable UICollectionViewLayoutAttributes *)_layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                                                               atIndexPath:(NSIndexPath *)indexPath {
    if (IGListExperimentEnabled(self.experiments, IGListExperimentAvoidLayoutOnScrollToObject)) {
        return [self.collectionView layoutAttributesForSupplementaryElementOfKind:elementKind atIndexPath:indexPath];
    } else {
        return [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    }
}

- (UIEdgeInsets)bb_contentInset:(UICollectionView *)collectionView{
    if (@available(iOS 11.0, tvOS 11.0, *)) {
        return collectionView.adjustedContentInset;
    } else {
        return collectionView.contentInset;
    }
}

@end
