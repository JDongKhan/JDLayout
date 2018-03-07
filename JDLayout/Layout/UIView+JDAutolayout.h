//
//  UIView+Autolayout.h
//  AutoLayout
//
//  Created by JD on 2017/12/21.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>

#define function(func) jd_##func

@class JDRelation;

@interface UIView (JDAutolayout)
- (UIView *(^)(void))function(reset);
- (JDRelation *(^)(UIView *view))function(left);
- (JDRelation *(^)(UIView *view))function(top);
- (JDRelation *(^)(UIView *view))function(right);
- (JDRelation *(^)(UIView *view))function(bottom);
- (JDRelation *(^)(UIView *view))function(centerX);
- (JDRelation *(^)(UIView *view))function(centerY);
- (JDRelation *(^)(void))function(width);
- (JDRelation *(^)(void))function(height);
- (void(^)(void))function(layout);
- (void(^)(void))function(reload);

- (UIView *(^)(UIView *view))function(equalWidth);
- (UIView *(^)(UIView *view))function(equalHeight);

@end

@interface UIView (JDAutolayoutExtention)

- (void(^)(NSArray *subViews))function(equalWidthSubViews);
- (void(^)(NSArray *subViews))function(equalHeightSubViews);

@end

@interface JDRelation : NSObject
//对齐
- (JDRelation *(^)(void))function(align);

- (UIView *(^)(CGFloat constant))function(equal);
- (UIView *(^)(CGFloat constant))function(lessThanOrEqual);
- (UIView *(^)(CGFloat constant))function(greaterThanOrEqual);
@end

