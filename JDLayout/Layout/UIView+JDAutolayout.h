//
//  UIView+Autolayout.h
//  AutoLayout
//
//  Created by JD on 2017/12/21.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDRelation;
@class JDViewAttribute;
@interface UIView (JDAutolayout)

/**
 约束基本设置
 */
- (JDRelation *(^)(id attr))jd_left;
- (JDRelation *(^)(id attr))jd_top;
- (JDRelation *(^)(id attr))jd_right;
- (JDRelation *(^)(id attr))jd_bottom;
- (JDRelation *(^)(id attr))jd_centerX;
- (JDRelation *(^)(id attr))jd_centerY;
- (JDRelation *(^)(id attr))jd_width;
- (JDRelation *(^)(id attr))jd_height;

/**
 宽高比
 */
- (UIView *(^)(CGFloat ratio))jd_aspectRatio;
    
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
 对width和height的封装
 */
- (UIView *(^)(CGSize size))jd_size;
- (UIView *(^)(CGRect frame))jd_frame;
- (UIView *(^)(UIEdgeInsets insets))jd_insets;

/**
 子view等宽、等高
 */
- (void(^)(NSArray *subViews))jd_equalWidthSubViews;
- (void(^)(NSArray *subViews))jd_equalHeightSubViews;

- (instancetype)jd_closestCommonSuperview:(UIView *)view;

@end


@interface JDRelation : NSObject
    
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
- (void(^)(void))jd_update;

@end

//获取view的属性
@interface UIView (JDViewAttribute)
@property (nonatomic, strong) JDViewAttribute *jd_leftAttribute;
@property (nonatomic, strong) JDViewAttribute *jd_topAttribute;
@property (nonatomic, strong) JDViewAttribute *jd_rightAttribute;
@property (nonatomic, strong) JDViewAttribute *jd_bottomAttribute;
@property (nonatomic, strong) JDViewAttribute *jd_widthAttribute;
@property (nonatomic, strong) JDViewAttribute *jd_heightAttribute;
@property (nonatomic, strong) JDViewAttribute *jd_centerXAttribute;
@property (nonatomic, strong) JDViewAttribute *jd_centerYAttribute;
@property (nonatomic, strong) JDViewAttribute *jd_baselineAttribute;
@end


@interface JDViewAttribute : NSObject
@property (nonatomic, weak)   UIView *view;
@property (nonatomic, assign) NSLayoutAttribute attribute;
@end

