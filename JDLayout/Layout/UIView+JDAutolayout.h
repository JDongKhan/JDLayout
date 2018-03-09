//
//  UIView+Autolayout.h
//  AutoLayout
//
//  Created by JD on 2017/12/21.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDRelation;

@interface UIView (JDAutolayout)

/**
 约束基本设置
 */
- (JDRelation *(^)(UIView *view))jd_left;
- (JDRelation *(^)(UIView *view))jd_top;
- (JDRelation *(^)(UIView *view))jd_right;
- (JDRelation *(^)(UIView *view))jd_bottom;
- (JDRelation *(^)(UIView *view))jd_centerX;
- (JDRelation *(^)(UIView *view))jd_centerY;
- (JDRelation *(^)(void))jd_width;
- (JDRelation *(^)(void))jd_height;

/**
 对width和height的封装
 */
- (UIView *(^)(CGSize size))jd_size;
- (UIView *(^)(CGRect frame))jd_frame;
- (UIView *(^)(UIEdgeInsets insets))jd_insets;

/**
 等宽、等高
 */
- (UIView *(^)(UIView *view))jd_equalWidth;
- (UIView *(^)(UIView *view))jd_equalHeight;

/**
 连接方法，用于逻辑上连接下一个语句
 */
- (UIView *(^)(void))jd_and;

/**
 重置约束
 */
- (UIView *(^)(void))jd_reset;

/**
 约束布局
 */
- (void(^)(void))jd_layout;
- (void(^)(void))jd_update;

@end

@interface UIView (JDAutolayoutExtention)

/**
 子view等宽、等高
 */
- (void(^)(NSArray *subViews))jd_equalWidthSubViews;
- (void(^)(NSArray *subViews))jd_equalHeightSubViews;

- (instancetype)jd_closestCommonSuperview:(UIView *)view;

@end


@interface JDRelation : NSObject

//对齐
- (JDRelation *(^)(void))jd_align;

/**
 倍数
 */
- (JDRelation *(^)(CGFloat multiplier))jd_multiplier;

/**
 约束关系
 */
- (UIView *(^)(CGFloat constant))jd_equal;
- (UIView *(^)(CGFloat constant))jd_lessThanOrEqual;
- (UIView *(^)(CGFloat constant))jd_greaterThanOrEqual;

/**
 连接方法，用于逻辑上连接下一个语句
 */
- (UIView *(^)(void))jd_and;

/**
 约束布局
 */
- (void(^)(void))jd_layout;
- (void(^)(void))jd_reload;

@end

