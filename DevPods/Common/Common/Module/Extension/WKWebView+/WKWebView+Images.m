//
//  WKWebView+Images.m
//  Brainbank
//
//  Created by 姜文浩 on 2020/4/20.
//  Copyright © 2020 大脑银行. All rights reserved.
//

#import "WKWebView+Images.h"
#import <objc/runtime.h>

static char imgUrlArrayKey;
@implementation WKWebView (Images)

- (void)setMethod:(NSArray *)imgUrlArray
{
    objc_setAssociatedObject(self, &imgUrlArrayKey, imgUrlArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)getImgUrlArray
{
    return objc_getAssociatedObject(self, &imgUrlArrayKey);
}


//图片适配
- (void)imgAdapterWkWebView:(WKWebView *)wkWebView{
    NSString * js = @"function imgAutoFit() { \
       var imgs = document.getElementsByTagName('img'); \
       for (var i = 0; i < imgs.length; ++i) {\
          var img = imgs[i];   \
          img.style.maxWidth = %f;   \
       } \
    }";
    js = [NSString stringWithFormat:js, UIScreen.mainScreen.bounds.size.width -30];
    [wkWebView evaluateJavaScript:js completionHandler:nil];
    [wkWebView evaluateJavaScript:@"imgAutoFit()" completionHandler:nil];
}


/*
 *通过js获取htlm中图片url
 */
-(NSArray *)getImageUrlByJS:(WKWebView *)wkWebView {
    NSString * jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    \
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return imgScr;\
    };";
    
    //用js获取全部图片
    [wkWebView evaluateJavaScript:jsGetImages completionHandler:nil];
    
    __block NSMutableArray *array= [NSMutableArray array];
    [wkWebView evaluateJavaScript:@"getImages()" completionHandler:^(id Result, NSError * error) {
        NSString *resurlt=[NSString stringWithFormat:@"%@",Result];
        array=[NSMutableArray arrayWithArray:[resurlt componentsSeparatedByString:@"+"]];
        [wkWebView setMethod:[array copy]];
    }];
    
    return [array copy];
}

//显示大图
- (BOOL)showBigImage:(NSURLRequest *)request
{
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"])
    {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        
        NSArray *imgUrlArr=[self getImgUrlArray];
        NSInteger index=0;
        for (NSInteger i=0; i<[imgUrlArr count]; i++) {
            if([imageUrl isEqualToString:imgUrlArr[i]])
            {
                index=i;
                break;
            }
        }
        return NO;
    }
    return YES;
}
@end
