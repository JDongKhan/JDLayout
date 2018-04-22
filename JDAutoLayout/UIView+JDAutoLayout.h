//
//  UIView+JDAutoLayout.h
//  JDAutoLayout
//
//  Created by JD on 2017/12/21.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDRelation;
@class JDViewAttribute;

typedef float JDLayoutPriority NS_TYPED_EXTENSIBLE_ENUM;
static const JDLayoutPriority JDLayoutPriorityRequired = 1000; // A required constraint.  Do not exceed this.
static const JDLayoutPriority JDLayoutPriorityDefaultHigh = 750; // This is the priority level with which a button resists compressing its content.
static const JDLayoutPriority JDLayoutPriorityDefaultLow = 250; // This is the priority level at which a button hugs its contents horizontally.
static const JDLayoutPriority JDLayoutPriorityFittingSizeLevel = 50; // When you send -[UIView s

NS_ASSUME_NONNULL_BEGIN

typedef void                  (^JDVoidBlock)(void);
typedef void                  (^JDVoidArrayBlock)(NSArray *subViews);
typedef UIView     * _Nonnull (^JDViewVoidBlock)(void);
typedef UIView     * _Nonnull (^JDViewFloatBlock)(CGFloat value);
typedef UIView     * _Nonnull (^JDViewRectBlock)(CGRect rect);
typedef UIView     * _Nonnull (^JDViewSizeBlock)(CGSize size);
typedef UIView     * _Nonnull (^JDViewInsetsBlock)(UIEdgeInsets insets);
typedef JDRelation * _Nonnull (^JDRelationAttrBlock)(id attr);
typedef JDRelation * _Nonnull (^JDRelationNullableAttrBlock)(_Nullable id attr);
typedef JDRelation * _Nonnull (^JDRelationFloatBlock)(CGFloat value);
typedef JDRelation * _Nonnull (^JDRelationPriorityBlock)(JDLayoutPriority value);


@interface UIView (JDAutoLayout)

/**
 约束基本设置
 */
@property (nonatomic, copy, readonly) JDRelationAttrBlock jd_left;
@property (nonatomic, copy, readonly) JDRelationAttrBlock jd_top;
@property (nonatomic, copy, readonly) JDRelationAttrBlock jd_right;
@property (nonatomic, copy, readonly) JDRelationAttrBlock jd_bottom;
@property (nonatomic, copy, readonly) JDRelationAttrBlock jd_centerX;
@property (nonatomic, copy, readonly) JDRelationAttrBlock jd_centerY;
@property (nonatomic, copy, readonly) JDRelationNullableAttrBlock jd_width;
@property (nonatomic, copy, readonly) JDRelationNullableAttrBlock jd_height;

/**
 宽高比
 */
@property (nonatomic, copy, readonly) JDViewFloatBlock jd_aspectRatio;
    
/**
 连接方法，用于逻辑上连接下一个语句
 */
@property (nonatomic, copy, readonly) JDViewVoidBlock jd_and;

/**
 重置约束
 */
@property (nonatomic, copy, readonly) JDViewVoidBlock jd_reset;

/**
 约束布局
 */
@property (nonatomic, copy, readonly) JDVoidBlock jd_layout;
@property (nonatomic, copy, readonly) JDVoidBlock jd_update;

@end

@interface UIView (JDAutoLayoutExtention)

/**
 对width和height的封装
 */
@property (nonatomic, copy, readonly) JDViewSizeBlock jd_size;
@property (nonatomic, copy, readonly) JDViewRectBlock jd_frame;
@property (nonatomic, copy, readonly) JDViewInsetsBlock jd_insets;

/**
 子view等宽、等高
 */
@property (nonatomic, copy, readonly) JDVoidArrayBlock jd_equalWidthSubViews;
@property (nonatomic, copy, readonly) JDVoidArrayBlock jd_equalHeightSubViews;

- (instancetype)jd_closestCommonSuperview:(UIView *)view;

@end


@interface JDRelation : NSObject
    
/**
 倍数
 */
@property (nonatomic, copy, readonly) JDRelationFloatBlock jd_multiplier;
@property (nonatomic, copy, readonly) JDRelationPriorityBlock jd_priority;

/**
 约束关系
 */
@property (nonatomic, copy, readonly) JDViewFloatBlock jd_equal;
@property (nonatomic, copy, readonly) JDViewFloatBlock jd_lessThanOrEqual;
@property (nonatomic, copy, readonly) JDViewFloatBlock jd_greaterThanOrEqual;

@end

//为了保证语义的连贯而额外增加的方法
@interface JDRelation (JDAutoLayoutExtention)

@property (nonatomic, copy, readonly) JDRelationAttrBlock jd_left;
@property (nonatomic, copy, readonly) JDRelationAttrBlock jd_top;
@property (nonatomic, copy, readonly) JDRelationAttrBlock jd_right;
@property (nonatomic, copy, readonly) JDRelationAttrBlock jd_bottom;
@property (nonatomic, copy, readonly) JDRelationAttrBlock jd_centerX;
@property (nonatomic, copy, readonly) JDRelationAttrBlock jd_centerY;
@property (nonatomic, copy, readonly) JDRelationNullableAttrBlock jd_width;
@property (nonatomic, copy, readonly) JDRelationNullableAttrBlock jd_height;
@property (nonatomic, copy, readonly) JDViewFloatBlock jd_aspectRatio;
@property (nonatomic, copy, readonly) JDViewVoidBlock jd_and;
@property (nonatomic, copy, readonly) JDVoidBlock jd_layout;
@property (nonatomic, copy, readonly) JDVoidBlock jd_update;

@end

//////////////////////////////////////////////////
//获取view的属性
@interface UIView (JDViewAttribute)

@property (nonatomic, strong, readonly) JDViewAttribute *jd_leftAttribute;
@property (nonatomic, strong, readonly) JDViewAttribute *jd_topAttribute;
@property (nonatomic, strong, readonly) JDViewAttribute *jd_rightAttribute;
@property (nonatomic, strong, readonly) JDViewAttribute *jd_bottomAttribute;
@property (nonatomic, strong, readonly) JDViewAttribute *jd_widthAttribute;
@property (nonatomic, strong, readonly) JDViewAttribute *jd_heightAttribute;
@property (nonatomic, strong, readonly) JDViewAttribute *jd_centerXAttribute;
@property (nonatomic, strong, readonly) JDViewAttribute *jd_centerYAttribute;
@property (nonatomic, strong, readonly) JDViewAttribute *jd_baselineAttribute;

@end


@interface JDViewAttribute : NSObject

@property (nonatomic, weak,   readonly) UIView *view;
@property (nonatomic, assign, readonly) NSLayoutAttribute attribute;

@end

NS_ASSUME_NONNULL_END
