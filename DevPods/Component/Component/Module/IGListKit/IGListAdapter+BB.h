//
//  IGListAdapter+BB.h
//  BrainBank
//
//  Created by zerry on 2021/10/11.
//  Copyright © 2021 yoao. All rights reserved.
//

#import <IGListKit/IGListKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IGListAdapter (BB)
- (void)bb_scrollToObject: (id)object
       supplementaryKinds: (NSArray<NSString *> *)supplementaryKinds
          scrollDirection: (UICollectionViewScrollDirection)scrollDirection
           scrollPosition: (UICollectionViewScrollPosition)scrollPosition
                  offsetY: (CGFloat)offsetY
                 animated: (BOOL)animated;
@end

NS_ASSUME_NONNULL_END
