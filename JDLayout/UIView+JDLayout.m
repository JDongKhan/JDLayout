//
//  UIView+JDLayout.m
//  JDLayout
//
//  Created by JD on 2017/12/21.
//  Copyright © 2017年 . All rights reserved.
//

#import "UIView+JDLayout.h"
#import <objc/runtime.h>

#pragma mark ---------------JDRelation------------------------

//单个约束基本参数的模型
@interface JDRelation()
@property (nonatomic, weak)   UIView *firstItem;
@property (nonatomic, weak)   UIView *secondItem;
@property (nonatomic, weak)   id secondItemLayoutGuide;
@property (nonatomic, assign) NSLayoutAttribute firstAttribute;
@property (nonatomic, assign) NSLayoutAttribute secondAttribute;
@property (nonatomic, assign) NSLayoutRelation relation;
@property (nonatomic, assign) CGFloat constant;
@property (nonatomic, assign) CGFloat offset; /**constant的偏移量*/
@property (nonatomic, assign) CGFloat multiplier;
@property (nonatomic, assign) UILayoutPriority priority;
@end

@implementation JDRelation {
    @public
    BOOL _installed;
    
    @private
    __weak UIView *_installedView;
    NSLayoutConstraint *_constraint;
}

- (instancetype)init {
    if (self = [super init]) {
        _multiplier = 1;
        _installed = NO;
        _priority = JDLayoutPriorityRequired;
    }
    return self;
}

- (JDRelationFloatBlock)jd_multiplier {
    return ^(CGFloat multiplier){
        self.multiplier = multiplier;
        return self;
    };
}

- (JDViewFloatBlock)jd_offset {
    return ^(CGFloat offset){
        self.offset = offset;
        return self.firstItem;
    };
}

-  (JDRelationPriorityBlock)jd_priority {
    return ^(JDLayoutPriority priority){
        self.priority = priority;
        return self;
    };
}

- (JDViewFloatBlock)jd_equal {
    return ^(CGFloat constant){
        self.relation = NSLayoutRelationEqual;
        self.constant = constant;
        self.offset = 0;
        return self.firstItem;
    };
}

- (JDViewFloatBlock)jd_lessThanOrEqual {
    return ^(CGFloat constant){
        self.relation = NSLayoutRelationLessThanOrEqual;
        self.constant = constant;
        self.offset = 0;
        return self.firstItem;
    };
}

- (JDViewFloatBlock)jd_greaterThanOrEqual {
    return ^(CGFloat constant){
        self.relation = NSLayoutRelationGreaterThanOrEqual;
        self.constant = constant;
        self.offset = 0;
        return self.firstItem;
    };
}

- (void)jd_installConstraint {
    if (_installed) {
        return;
    }
    [_installedView removeConstraint:_constraint];
    id toItem = self.secondItem;
    if (self.secondItemLayoutGuide) {
        toItem = self.secondItemLayoutGuide;
    } else {
        NSArray *constraints = _installedView.constraints;
        if (self.secondItem == nil && self.constant == JDAutoLayoutValueAutomatic) {
            //判断secondItem == nil 基本上都是设置宽和高，宽高不能为负数
            return;
        }
    }
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.firstItem attribute:self.firstAttribute relatedBy:self.relation toItem:self.secondItem attribute:self.secondAttribute multiplier:self.multiplier constant:self.constant];
    if (self.secondItem) {
        UIView *closestCommonSuperview = [self.firstItem jd_closestCommonSuperview:self.secondItem];
        NSAssert(closestCommonSuperview,
                 @"couldn't find a common superview for %@ and %@",
                 self.firstItem, self.secondItem);
        _installedView = closestCommonSuperview;
    } else {
        _installedView = self.firstItem;
    }
    _constraint = constraint;
    _constraint.priority = self.priority;
    [_installedView addConstraint:_constraint];
    _installed = YES;
}

- (void)jd_updateConstraint {
    if (_installed) {
        return;
    }
    if (_constraint == nil) {
        if (self.secondItem) {
            UIView *closestCommonSuperview = [self.firstItem jd_closestCommonSuperview:self.secondItem];
            NSAssert(closestCommonSuperview,
                     @"couldn't find a common superview for %@ and %@",
                     self.firstItem, self.secondItem);
            _installedView = closestCommonSuperview;
        } else if (self.firstItem) {
            _installedView = self.firstItem;
        }
        NSArray *constraints = _installedView.constraints;
        for (NSLayoutConstraint *c in constraints) {
            if ([c isMemberOfClass:[NSLayoutConstraint class]]) {
                if ((c.firstAttribute == self.firstAttribute && c.firstItem == self.firstItem) || (c.secondAttribute == self.firstAttribute && c.secondItem == self.firstItem)) {
                    _constraint = c;
                    break;
                }
            }
        }
    }
    if (_constraint != nil) {
        if (self.offset != 0 ) {
            _constraint.constant += self.offset;
        } else {
            //update不支持修改priority，因为iOS8.1下修改priority会奔溃
            //_constraint.priority = self.priority;
            _constraint.constant = self.constant;
        }
        _installed = YES;
        return;
    }
    //没找到就安装一个
    [self jd_installConstraint];
}

- (void)jd_removeConstraint {
    if (_constraint && _installedView) {
        [_installedView removeConstraint:_constraint];
    }
}

- (id)copyWithZone:(NSZone *)zone {
    JDRelation *r = [[[self class] allocWithZone:zone] init];
    r.firstItem = self.firstItem;
    r.secondItemLayoutGuide = self.secondItemLayoutGuide;
    r.secondItem = self.secondItem;
    r.firstAttribute = self.firstAttribute;
    r.secondAttribute = self.secondAttribute;
    r.relation = self.relation;
    r.constant = self.constant;
    r.offset = self.offset;
    r.multiplier = self.multiplier;
    r.priority = self.priority;
    r->_installed = self->_installed;
    r->_installedView = self->_installedView;
    r->_constraint = self->_constraint;
    return r;
}

@end

#pragma mark ---------------JDAttribute------------------------

//一个控件布局基本参数的模型
@interface JDAttribute : NSObject

@property (nonatomic, strong) JDRelation *left;
@property (nonatomic, strong) JDRelation *top;
@property (nonatomic, strong) JDRelation *right;
@property (nonatomic, strong) JDRelation *bottom;
@property (nonatomic, strong) JDRelation *width;
@property (nonatomic, strong) JDRelation *height;
@property (nonatomic, strong) JDRelation *aspectRatio;
@property (nonatomic, strong) JDRelation *centerX;
@property (nonatomic, strong) JDRelation *centerY;

- (NSArray *)jd_allAttributes;

@end

@implementation JDAttribute

- (NSArray *)jd_allAttributes {
    //将多个方向的参数放入数组，统一配置
    NSMutableArray *allAttributes = [NSMutableArray array];
    if (self.left) {
        [allAttributes addObject:self.left];
    }
    if (self.top) {
        [allAttributes addObject:self.top];
    }
    if (self.right) {
        [allAttributes addObject:self.right];
    }
    if (self.bottom) {
        [allAttributes addObject:self.bottom];
    }
    if (self.centerX) {
        [allAttributes addObject:self.centerX];
    }
    if (self.centerY) {
        [allAttributes addObject:self.centerY];
    }
    if (self.width) {
        [allAttributes addObject:self.width];
    }
    if (self.height) {
        [allAttributes addObject:self.height];
    }
    if (self.aspectRatio) {
        [allAttributes addObject:self.aspectRatio];
    }
    return allAttributes;
}

#define JD_DEFINE_REMOVE_METHOD(_method,_attr) \
- (void)jd_remove##_method { \
    [self._attr jd_removeConstraint]; \
    self._attr = nil;\
}

JD_DEFINE_REMOVE_METHOD(Left,left)
JD_DEFINE_REMOVE_METHOD(Top,top)
JD_DEFINE_REMOVE_METHOD(Right,right)
JD_DEFINE_REMOVE_METHOD(Bottom,bottom)
JD_DEFINE_REMOVE_METHOD(Width,width)
JD_DEFINE_REMOVE_METHOD(Height,height)
JD_DEFINE_REMOVE_METHOD(CenterX,centerX)
JD_DEFINE_REMOVE_METHOD(CenterY,centerY)
JD_DEFINE_REMOVE_METHOD(AspectRatio,aspectRatio)

- (void)jd_remove {
    [self jd_removeLeft];
    [self jd_removeTop];
    [self jd_removeRight];
    [self jd_removeBottom];
    [self jd_removeWidth];
    [self jd_removeHeight];
    [self jd_removeCenterX];
    [self jd_removeCenterY];
    [self jd_removeAspectRatio];
}


- (id)copyWithZone:(NSZone *)zone {
    JDAttribute *r = [[[self class] allocWithZone:zone] init];
    r.left = [self.left copy];
    r.top = [self.top copy];
    r.right = [self.right copy];
    r.bottom = [self.bottom copy];
    r.width = [self.width copy];
    r.height = [self.height copy];
    r.aspectRatio = [self.aspectRatio copy];
    r.centerX = [self.centerX copy];
    r.centerY = [self.centerY copy];
    return r;
}


@end

#pragma mark ---------------JDLayout------------------------

@implementation UIView (JDLayout)

//获取属性
#define JD_DEFINE_GETATTR_METHOD(_attr) ({\
    JDRelation *target = [self jd_tmpAttribute]._attr;\
    if (target == nil) {\
        target = [[JDRelation alloc] init];\
        [self jd_tmpAttribute]._attr = target;\
    }\
    (target);\
})


//定义size属性方法
#define JD_DEFINE_AUTOLAYOUT_METHOD(_attr,_firstAttribute) \
- (JDRelationAttrBlock)jd_##_attr {\
    return ^(id attr){\
        JDRelation *target = JD_DEFINE_GETATTR_METHOD(_attr);\
        target.firstItem = self;\
        target.firstAttribute = _firstAttribute;\
        UIView *secondView = nil;\
        NSLayoutAttribute secondAttribute = NSLayoutAttributeNotAnAttribute;\
        if ([attr isKindOfClass:[UIView class]]) {\
            secondView = attr;\
            secondAttribute = _firstAttribute;\
        } else if ([attr isKindOfClass:[NSNumber class]]) {\
            target.constant = [attr floatValue];\
        } else if ([attr isKindOfClass:[JDViewAttribute class]]) {\
            JDViewAttribute *secondRelation = attr;\
            secondView = secondRelation.view;\
            secondAttribute = secondRelation.attribute;\
            target.secondItemLayoutGuide = secondRelation.item;\
        }\
        target.secondItem = secondView;\
        target.secondAttribute = secondAttribute;\
        target->_installed = NO;\
        return target;\
    };\
}

JD_DEFINE_AUTOLAYOUT_METHOD(left,NSLayoutAttributeLeading)
JD_DEFINE_AUTOLAYOUT_METHOD(top,NSLayoutAttributeTop)
JD_DEFINE_AUTOLAYOUT_METHOD(right,NSLayoutAttributeTrailing)
JD_DEFINE_AUTOLAYOUT_METHOD(bottom,NSLayoutAttributeBottom)
JD_DEFINE_AUTOLAYOUT_METHOD(width,NSLayoutAttributeWidth)
JD_DEFINE_AUTOLAYOUT_METHOD(height,NSLayoutAttributeHeight)
JD_DEFINE_AUTOLAYOUT_METHOD(centerX,NSLayoutAttributeCenterX)
JD_DEFINE_AUTOLAYOUT_METHOD(centerY,NSLayoutAttributeCenterY)

- (JDViewPriorityBlock)jd_contentHuggingPriorityForHorizontal {
    return ^(JDLayoutPriority value){
        [self setContentHuggingPriority:value forAxis:UILayoutConstraintAxisHorizontal];
        return self;
    };
}

- (JDViewPriorityBlock)jd_contentHuggingPriorityForVertical {
    return ^(JDLayoutPriority value){
        [self setContentHuggingPriority:value forAxis:UILayoutConstraintAxisVertical];
        return self;
    };
}

- (JDViewPriorityBlock)jd_contentCompressionPriorityForHorizontal {
    return ^(JDLayoutPriority value){
        [self setContentCompressionResistancePriority:value forAxis:UILayoutConstraintAxisHorizontal];
        return self;
    };
}

- (JDViewPriorityBlock)jd_contentCompressionPriorityForVertical {
    return ^(JDLayoutPriority value){
        [self setContentCompressionResistancePriority:value forAxis:UILayoutConstraintAxisVertical];
        return self;
    };
}

- (JDViewFloatBlock)jd_aspectRatio {
    return ^(CGFloat ratio){
        JDRelation *target = JD_DEFINE_GETATTR_METHOD(aspectRatio);
        target.firstItem = self;
        target.firstAttribute = NSLayoutAttributeWidth;
        target.secondItem = self;
        target.secondAttribute = NSLayoutAttributeHeight;
        target.multiplier = ratio;
        target->_installed = NO;
        return self;
    };
}
    
/////////////////////////////////////////////////////

- (JDAttribute *)jd_tmpAttribute {
    JDAttribute *tmpAttribute = objc_getAssociatedObject(self, _cmd);
    if (tmpAttribute == nil) {
        tmpAttribute = [[JDAttribute alloc] init];
        objc_setAssociatedObject(self, _cmd, tmpAttribute, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tmpAttribute;
}

- (JDViewVoidBlock)jd_and {
    return ^(void){
        return self;
    };
}

- (JDVoidBlock)jd_layout {
    return ^(void){
        NSAssert(self.superview, @"未添加到父视图");
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *allAttributes = [[self jd_tmpAttribute] jd_allAttributes];
        //开始约束布局
        for (JDRelation *relation in allAttributes) {
            [relation jd_installConstraint];
        }
    };
}

- (JDVoidBlock)jd_update {
    return ^(void){
        NSAssert(self.superview, @"未添加到父视图");
        NSArray *allAttributes = [[self jd_tmpAttribute] jd_allAttributes];
        //开始更新约束布局
        for (JDRelation *relation in allAttributes) {
            [relation jd_updateConstraint];
        }
    };
}

- (void)setJd_hidden:(BOOL)jd_hidden {
    objc_setAssociatedObject(self, @selector(jd_hidden),@(jd_hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.hidden = jd_hidden;
    if (jd_hidden) {
        NSArray *allAttributes = [[self jd_tmpAttribute] jd_allAttributes];//当前属性
        NSArray *copyAttributes = self.jd_copyTmpAttribute;//拷贝的属性
        //开始更新约束
        for (JDRelation *relation in allAttributes) {
            //先移除当前的约束
            [relation jd_removeConstraint];
        }
        for (JDRelation *copyR in copyAttributes) {
            //再更新使用copy归来的约束
            copyR.constant = 0;
            copyR->_installed = NO;
            [copyR jd_installConstraint];
        }
        
    } else {
        NSArray *allAttributes = [[self jd_tmpAttribute] jd_allAttributes];//当前属性
        NSArray *copyAttributes = self.jd_copyTmpAttribute;//拷贝的属性
        for (JDRelation *copyR in copyAttributes) {
            [copyR jd_removeConstraint];
        }
        //开始更新约束
        for (JDRelation *relation in allAttributes) {
            relation->_installed = NO;
            [relation jd_installConstraint];
        }
    }
}

- (BOOL)jd_hidden {
    return objc_getAssociatedObject(self, @selector(jd_hidden));
}

- (JDAttribute *)jd_copyTmpAttribute {
    JDAttribute *tmpAttribute = objc_getAssociatedObject(self, _cmd);
    if (tmpAttribute == nil) {
        tmpAttribute = [[[self jd_tmpAttribute] copy] jd_allAttributes];
        objc_setAssociatedObject(self, _cmd, tmpAttribute, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tmpAttribute;
}

    
@end

/****************************************************/
/********************** 重置约束 *********************/
/****************************************************/
@implementation UIView(JDLayoutRemoveConstraint)

- (JDViewVoidBlock)jd_remove {
    return ^(void){
        JDAttribute *attribute = [self jd_tmpAttribute];
        [attribute jd_remove];
        return self;
    };
}

#define JD_DEFINE_REMOVE2_METHOD(_method) \
- (JDViewVoidBlock)jd_remove##_method {\
    return ^(void){\
        JDAttribute *attribute = [self jd_tmpAttribute];\
        [attribute jd_remove##_method];\
        return self;\
    };\
}

JD_DEFINE_REMOVE2_METHOD(Left)
JD_DEFINE_REMOVE2_METHOD(Top)
JD_DEFINE_REMOVE2_METHOD(Right)
JD_DEFINE_REMOVE2_METHOD(Bottom)
JD_DEFINE_REMOVE2_METHOD(Width)
JD_DEFINE_REMOVE2_METHOD(Height)
JD_DEFINE_REMOVE2_METHOD(CenterX)
JD_DEFINE_REMOVE2_METHOD(CenterY)
JD_DEFINE_REMOVE2_METHOD(AspectRatio)

@end

/****************************************************/
/*********************拓展方法************************/
/****************************************************/
@implementation UIView(JDLayoutExtention)

- (JDViewSizeBlock)jd_size {
    return ^(CGSize size){
        return self
        .jd_width(nil).jd_equal(size.width)
        .jd_height(nil).jd_equal(size.height);
    };
}
    
- (JDViewRectBlock)jd_frame {
    return ^(CGRect frame){
        return self
        .jd_left(self.superview).jd_equal(frame.origin.x)
        .jd_top(self.superview).jd_equal(frame.origin.y)
        .jd_size(frame.size);
    };
}
    
- (JDViewInsetsBlock)jd_insets; {
    return ^(UIEdgeInsets insets){
        return self
        .jd_left(self.superview).jd_equal(insets.left)
        .jd_top(self.superview).jd_equal(insets.top)
        .jd_right(self.superview).jd_equal(insets.right)
        .jd_bottom(self.superview).jd_equal(insets.bottom);
    };
}

- (JDVoidArrayBlock)jd_equalWidthSubViews {
    return ^(NSArray *subViews){
        UIView *lastView = nil;
        for (UIView *view in subViews) {
            if (lastView == nil) {
                view
                .jd_left(self).jd_equal(0)
                .jd_centerY(self).jd_equal(0)
                .jd_layout();
            } else {
                view
                .jd_left(lastView.jd_rightAttribute).jd_equal(0)
                .jd_centerY(lastView).jd_equal(0)
                .jd_width(lastView).jd_equal(0)
                .jd_layout();
            }
            lastView = view;
        }
        lastView
        .jd_right(self).jd_equal(0)
        .jd_layout();
    };
}
    
- (JDVoidArrayBlock)jd_equalHeightSubViews {
    return ^(NSArray *subViews){
        UIView *lastView = nil;
        for (UIView *view in subViews) {
            if (lastView == nil) {
                view
                .jd_top(self).jd_equal(0)
                .jd_centerX(self).jd_equal(0)
                .jd_layout();
            } else {
                view
                .jd_top(lastView.jd_bottomAttribute).jd_equal(0)
                .jd_centerX(lastView).jd_equal(0)
                .jd_height(lastView).jd_equal(0)
                .jd_layout();
            }
            lastView = view;
        }
        lastView
        .jd_bottom(self).jd_equal(0)
        .jd_layout();
    };
}
    
- (instancetype)jd_closestCommonSuperview:(UIView *)view {
    UIView *closestCommonSuperview = nil;
    UIView *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        UIView *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}
    
@end


@implementation JDViewAttribute

- (instancetype)initWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute {
    if (self = [super init]) {
        _view = view;
        _attribute = attribute;
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view item:(id)item attribute:(NSLayoutAttribute)attribute {
    if (self = [super init]) {
        _view = view;
        _item = item;
        _attribute = attribute;
    }
    return self;
}

@end

@implementation UIView(JDViewAttribute)

- (JDViewAttribute *(^)(NSLayoutAttribute))jd_attribute {
    return ^(NSLayoutAttribute attr){
        return [[JDViewAttribute alloc] initWithView:self attribute:attr];
    };
}

#pragma mark ---------- 获取属性 -------------
- (JDViewAttribute *)jd_leftAttribute {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeLeading];
}

- (JDViewAttribute *)jd_topAttribute {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeTop];
}

- (JDViewAttribute *)jd_rightAttribute {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeTrailing];
}

- (JDViewAttribute *)jd_bottomAttribute {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeBottom];
}

- (JDViewAttribute *)jd_widthAttribute {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeWidth];
}

- (JDViewAttribute *)jd_heightAttribute {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeHeight];
}

- (JDViewAttribute *)jd_centerXAttribute {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeCenterX];
}

- (JDViewAttribute *)jd_centerYAttribute {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeCenterY];
}

- (JDViewAttribute *)jd_baselineAttribute {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeBaseline];
}


- (JDViewAttribute *)jd_firstBaselineAttribute {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeFirstBaseline];
}

- (JDViewAttribute *)jd_lastBaselineAttribute {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeLastBaseline];
}

/************************* safeArea  *************************/
- (JDViewAttribute *)jd_safeAreaLayoutGuide {
    id item = nil;
    if (@available(iOS 11.0, *)) {
        item = self.safeAreaLayoutGuide;
    }
    return [[JDViewAttribute alloc] initWithView:self item:item attribute:NSLayoutAttributeNotAnAttribute];
}

- (JDViewAttribute *)jd_safeAreaLayoutGuideLeft {
    id item = nil;
    if (@available(iOS 11.0, *)) {
        item = self.safeAreaLayoutGuide;
    }
    return [[JDViewAttribute alloc] initWithView:self item:item attribute:NSLayoutAttributeLeading];
}

- (JDViewAttribute *)jd_safeAreaLayoutGuideTop {
    id item = nil;
    if (@available(iOS 11.0, *)) {
        item = self.safeAreaLayoutGuide;
    }
    return [[JDViewAttribute alloc] initWithView:self item:item attribute:NSLayoutAttributeTop];
}

- (JDViewAttribute *)jd_safeAreaLayoutGuideRight {
    id item = nil;
    if (@available(iOS 11.0, *)) {
        item = self.safeAreaLayoutGuide;
    }
    return [[JDViewAttribute alloc] initWithView:self item:item attribute:NSLayoutAttributeTrailing];
}

- (JDViewAttribute *)jd_safeAreaLayoutGuideBottom {
    id item = nil;
    if (@available(iOS 11.0, *)) {
        item = self.safeAreaLayoutGuide;
    }
    return [[JDViewAttribute alloc] initWithView:self item:item attribute:NSLayoutAttributeBottom];
}

- (JDViewAttribute *)jd_safeAreaLayoutGuideWidth {
    id item = nil;
    if (@available(iOS 11.0, *)) {
        item = self.safeAreaLayoutGuide;
    }
    return [[JDViewAttribute alloc] initWithView:self item:item attribute:NSLayoutAttributeWidth];
}

- (JDViewAttribute *)jd_safeAreaLayoutGuideHeight {
    id item = nil;
    if (@available(iOS 11.0, *)) {
        item = self.safeAreaLayoutGuide;
    }
    return [[JDViewAttribute alloc] initWithView:self item:item attribute:NSLayoutAttributeHeight];
}

- (JDViewAttribute *)jd_safeAreaLayoutGuideCenterX {
    id item = nil;
    if (@available(iOS 11.0, *)) {
        item = self.safeAreaLayoutGuide;
    }
    return [[JDViewAttribute alloc] initWithView:self item:item attribute:NSLayoutAttributeCenterX];
}

- (JDViewAttribute *)jd_safeAreaLayoutGuideCenterY {
    id item = nil;
    if (@available(iOS 11.0, *)) {
        item = self.safeAreaLayoutGuide;
    }
    return [[JDViewAttribute alloc] initWithView:self item:item attribute:NSLayoutAttributeCenterY];
}


- (JDViewAttribute *)jd_leftMargin {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeLeadingMargin];
}

- (JDViewAttribute *)jd_rightMargin {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeTrailingMargin];
}

- (JDViewAttribute *)jd_topMargin {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeTopMargin];
}

- (JDViewAttribute *)jd_bottomMargin {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeBottomMargin];
}

- (JDViewAttribute *)jd_centerXWithinMargin {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeCenterXWithinMargins];
}

- (JDViewAttribute *)jd_centerYWithinMargin {
    return [[JDViewAttribute alloc] initWithView:self attribute:NSLayoutAttributeCenterYWithinMargins];
}

@end


@implementation JDRelation(JDLayoutExtention)

#define JD_DEFINE_ATTR_METHOD(_return,_method,_paramsType) \
- (_return)jd_##_method { \
    return ^(_paramsType attr){ \
        return self.firstItem.jd_##_method(attr); \
    };\
}

JD_DEFINE_ATTR_METHOD(JDRelationAttrBlock,left,id)
JD_DEFINE_ATTR_METHOD(JDRelationAttrBlock,top,id)
JD_DEFINE_ATTR_METHOD(JDRelationAttrBlock,right,id)
JD_DEFINE_ATTR_METHOD(JDRelationAttrBlock,bottom,id)
JD_DEFINE_ATTR_METHOD(JDRelationAttrBlock,centerX,id)
JD_DEFINE_ATTR_METHOD(JDRelationAttrBlock,centerY,id)
JD_DEFINE_ATTR_METHOD(JDRelationNullAttrBlock,width,id)
JD_DEFINE_ATTR_METHOD(JDRelationNullAttrBlock,height,id)
JD_DEFINE_ATTR_METHOD(JDViewFloatBlock,aspectRatio,CGFloat)

#define JD_DEFINE_ATTR_METHOD1(_return,_method) \
- (_return)jd_##_method { \
    return ^(void){ \
        return self.firstItem.jd_##_method(); \
    };\
}

JD_DEFINE_ATTR_METHOD1(JDViewVoidBlock,and)
JD_DEFINE_ATTR_METHOD1(JDVoidBlock,layout)
JD_DEFINE_ATTR_METHOD1(JDVoidBlock,update)

@end

