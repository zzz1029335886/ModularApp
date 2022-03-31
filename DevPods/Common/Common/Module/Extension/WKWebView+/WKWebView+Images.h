//
//  WKWebView+Images.h
//  Brainbank
//
//  Created by 姜文浩 on 2020/4/20.
//  Copyright © 2020 大脑银行. All rights reserved.
//

#import <WebKit/WebKit.h>
@interface WKWebView (Images)
- (NSArray *)getImageUrlByJS:(WKWebView *)wkWebView;

- (BOOL)showBigImage:(NSURLRequest *)request;

- (NSArray *)getImgUrlArray;
//图片适配
- (void)imgAdapterWkWebView:(WKWebView *)wkWebView;

@end

