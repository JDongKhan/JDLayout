//
//  UIView+JDAutoLayout.m
//  JDAutoLayout
//
//  Created by JD on 2017/12/21.
//  Copyright © 2017年 . All rights reserved.
//

#import "UIView+JDAutoLayout.h"
#import <objc/runtime.h>

#pragma mark ---------------JDRelation------------------------

//单个约束基本参数的模型
@interface JDRelation()

@property (nonatomic, weak)   UIView *firstItem;

@property (nonatomic, weak)   UIView *secondItem;

@property (nonatomic, assign) NSLayoutAttribute firstAttribute;

@property (nonatomic, assign) NSLayoutAttribute secondAttribute;

@property (nonatomic, assign) NSLayoutRelation relation;

@property (nonatomic, assign) CGFloat constant;

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
        return self.firstItem;
    };
}

- (JDViewFloatBlock)jd_lessThanOrEqual {
    return ^(CGFloat constant){
        self.relation = NSLayoutRelationLessThanOrEqual;
        self.constant = constant;
        return self.firstItem;
    };
}

- (JDViewFloatBlock)jd_greaterThanOrEqual {
    return ^(CGFloat constant){
        self.relation = NSLayoutRelationGreaterThanOrEqual;
        self.constant = constant;
        return self.firstItem;
    };
}

- (void)jd_installConstraint {
    if (_installed) {
        return;
    }
    [_installedView removeConstraint:_constraint];
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
                if (c.firstAttribute == self.firstAttribute && c.firstItem == self.firstItem) {
                    _constraint = c;
                    break;
                }
            }
        }
    }
    _constraint.priority = self.priority;
    _constraint.constant = self.constant;
    _installed = YES;
}

- (void)jd_clearConstraint {
    if (_constraint && _installedView) {
        [_installedView removeConstraint:_constraint];
    }
}

@end



@implementation JDRelation(JDAutoLayoutExtention)

#define JD_DEFINE_ATTR_METHOD(_return,_method,_paramsType) \
- (_return)jd_##_method { \
    return ^(_paramsType attr){ \
        return self.firstItem.jd_##_method(attr); \
    };\
} \

#define JD_DEFINE_ATTR_METHOD1(_return,_method) \
- (_return)jd_##_method { \
    return ^(void){ \
        return self.firstItem.jd_##_method(); \
    };\
} \

JD_DEFINE_ATTR_METHOD(JDRelationAttrBlock,left,id)
JD_DEFINE_ATTR_METHOD(JDRelationAttrBlock,top,id)
JD_DEFINE_ATTR_METHOD(JDRelationAttrBlock,right,id)
JD_DEFINE_ATTR_METHOD(JDRelationAttrBlock,bottom,id)
JD_DEFINE_ATTR_METHOD(JDRelationAttrBlock,centerX,id)
JD_DEFINE_ATTR_METHOD(JDRelationAttrBlock,centerY,id)
JD_DEFINE_ATTR_METHOD(JDRelationAttrBlock,width,id)
JD_DEFINE_ATTR_METHOD(JDRelationAttrBlock,height,id)
JD_DEFINE_ATTR_METHOD(JDViewFloatBlock,aspectRatio,CGFloat)
JD_DEFINE_ATTR_METHOD1(JDViewVoidBlock,and)
JD_DEFINE_ATTR_METHOD1(JDVoidBlock,layout)
JD_DEFINE_ATTR_METHOD1(JDVoidBlock,update)

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

- (void)jd_resetHorizontal {
    [self.left jd_clearConstraint];
    self.left = nil;
    [self.width jd_clearConstraint];
    self.width = nil;
    [self.centerX jd_clearConstraint];
    self.centerX = nil;
    [self.right jd_clearConstraint];
    self.right = nil;
}

- (void)jd_resetVertical {
    [self.top jd_clearConstraint];
    self.top = nil;
    [self.height jd_clearConstraint];
    self.height = nil;
    [self.centerY jd_clearConstraint];
    self.centerY = nil;
    [self.bottom jd_clearConstraint];
    self.bottom = nil;
}

- (void)jd_reset {
    [self jd_resetHorizontal];
    [self jd_resetVertical];
    [self.aspectRatio jd_clearConstraint];
    self.aspectRatio = nil;
}

@end

#pragma mark ---------------JDAutoLayout------------------------

@implementation UIView (JDAutoLayout)

- (JDRelationAttrBlock)jd_left {
    return ^(id attr){
        JDRelation *target = [self jd_tmpAttribute].left;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [self jd_tmpAttribute].left = target;
        }
        target.firstItem = self;
        target.firstAttribute = NSLayoutAttributeLeading;
        
        UIView *view = attr;
        NSLayoutAttribute secondAttribute = 0;
        if ([attr isKindOfClass:[JDViewAttribute class]]) {
            JDViewAttribute *secondRelation = attr;
            view = secondRelation.view;
            secondAttribute = secondRelation.attribute;
        }
        target.secondItem = view;
        if ([self isDescendantOfView:view]) {
            secondAttribute = NSLayoutAttributeLeading;
        } else if (secondAttribute == 0) {
            secondAttribute = NSLayoutAttributeTrailing;
        }
        target.secondAttribute = secondAttribute;
        
        target->_installed = NO;
        return target;
    };
}

- (JDRelationAttrBlock)jd_top {
    return ^(id attr){
        JDRelation *target = [self jd_tmpAttribute].top;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [self jd_tmpAttribute].top = target;
        }
        target.firstItem = self;
        target.firstAttribute = NSLayoutAttributeTop;
        
        UIView *view = attr;
        NSLayoutAttribute secondAttribute = 0;
        if ([attr isKindOfClass:[JDViewAttribute class]]) {
            JDViewAttribute *secondRelation = attr;
            view = secondRelation.view;
            secondAttribute = secondRelation.attribute;
        }
        target.secondItem = view;
        if ([self isDescendantOfView:view]) {
            secondAttribute = NSLayoutAttributeTop;
        } else if (secondAttribute == 0) {
            secondAttribute = NSLayoutAttributeBottom;
        }
        target.secondAttribute = secondAttribute;
        
        target->_installed = NO;
        return target;
    };
}

- (JDRelationAttrBlock)jd_right {
    return ^(id attr){
        JDRelation *target = [self jd_tmpAttribute].right;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [self jd_tmpAttribute].right = target;
        }
        target.firstItem = self;
        target.firstAttribute = NSLayoutAttributeTrailing;
        
        UIView *view = attr;
        NSLayoutAttribute secondAttribute = 0;
        if ([attr isKindOfClass:[JDViewAttribute class]]) {
            JDViewAttribute *secondRelation = attr;
            view = secondRelation.view;
            secondAttribute = secondRelation.attribute;
        }
        target.secondItem = view;
        if ([self isDescendantOfView:view]) {
            secondAttribute = NSLayoutAttributeTrailing;
        } else if (secondAttribute == 0) {
            secondAttribute = NSLayoutAttributeLeading;
        }
        target.secondAttribute = secondAttribute;
        
        target->_installed = NO;
        return target;
    };
}

- (JDRelationAttrBlock)jd_bottom {
    return ^(id attr){
        JDRelation *target = [self jd_tmpAttribute].bottom;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [self jd_tmpAttribute].bottom = target;
        }
        target.firstItem = self;
        target.firstAttribute = NSLayoutAttributeBottom;
        
        UIView *view = attr;
        NSLayoutAttribute secondAttribute = 0;
        if ([attr isKindOfClass:[JDViewAttribute class]]) {
            JDViewAttribute *secondRelation = attr;
            view = secondRelation.view;
            secondAttribute = secondRelation.attribute;
        }
        target.secondItem = view;
        if ([self isDescendantOfView:view]) {
            secondAttribute = NSLayoutAttributeBottom;
        } else if (secondAttribute == 0) {
            secondAttribute = NSLayoutAttributeTop;
        }
        target.secondAttribute = secondAttribute;
        
        target->_installed = NO;
        return target;
    };
}

- (JDRelationAttrBlock)jd_centerX {
    return ^(id attr){
        JDRelation *target = [self jd_tmpAttribute].centerX;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [self jd_tmpAttribute].centerX = target;
        }
        target.firstItem = self;
        target.firstAttribute = NSLayoutAttributeCenterX;
        
        UIView *view = attr;
        NSLayoutAttribute secondAttribute = NSLayoutAttributeCenterX;
        if ([attr isKindOfClass:[JDViewAttribute class]]) {
            JDViewAttribute *secondRelation = attr;
            view = secondRelation.view;
            secondAttribute = secondRelation.attribute;
        }
        target.secondItem = view;
        target.secondAttribute = secondAttribute;
        target->_installed = NO;
        return target;
    };
}

- (JDRelationAttrBlock)jd_centerY {
    return ^(id attr){
        JDRelation *target = [self jd_tmpAttribute].centerY;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [self jd_tmpAttribute].centerY = target;
        }
        target.firstItem = self;
        target.firstAttribute = NSLayoutAttributeCenterY;
        
        UIView *view = attr;
        NSLayoutAttribute secondAttribute = NSLayoutAttributeCenterY;
        if ([attr isKindOfClass:[JDViewAttribute class]]) {
            JDViewAttribute *secondRelation = attr;
            view = secondRelation.view;
            secondAttribute = secondRelation.attribute;
        }
        target.secondItem = view;
        target.secondAttribute = secondAttribute;
        target->_installed = NO;
        return target;
    };
}

- (JDRelationAttrBlock)jd_width {
    return ^(id attr){
        JDRelation *target = [self jd_tmpAttribute].width;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [self jd_tmpAttribute].width = target;
        }
        target.firstItem = self;
        target.firstAttribute = NSLayoutAttributeWidth;
        
        UIView *view = nil;
        NSLayoutAttribute secondAttribute = NSLayoutAttributeNotAnAttribute;
        if ([attr isKindOfClass:[JDViewAttribute class]]) {
            JDViewAttribute *secondRelation = attr;
            view = secondRelation.view;
            secondAttribute = secondRelation.attribute;
        } else if ([attr isKindOfClass:[UIView class]]) {
            view = attr;
            secondAttribute = NSLayoutAttributeWidth;
        } else if ([attr isKindOfClass:[NSNumber class]]) {
            target.constant = [attr floatValue];
        }
        target.secondItem = view;
        target.secondAttribute = secondAttribute;
        target->_installed = NO;
        return target;
    };
}

- (JDRelationAttrBlock)jd_height {
    return ^(id attr){
        JDRelation *target = [self jd_tmpAttribute].height;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [self jd_tmpAttribute].height = target;
        }
        target.firstItem = self;
        target.firstAttribute = NSLayoutAttributeHeight;
        
        UIView *view = nil;
        NSLayoutAttribute secondAttribute = NSLayoutAttributeNotAnAttribute;
        if ([attr isKindOfClass:[JDViewAttribute class]]) {
            JDViewAttribute *secondRelation = attr;
            view = secondRelation.view;
            secondAttribute = secondRelation.attribute;
        } else if ([attr isKindOfClass:[UIView class]]) {
            view = attr;
            secondAttribute = NSLayoutAttributeHeight;
        } else if ([attr isKindOfClass:[NSNumber class]]) {
            target.constant = [attr floatValue];
        }
        target.secondItem = view;
        target.secondAttribute = secondAttribute;
        target->_installed = NO;
        return target;
    };
}
    
- (JDViewFloatBlock)jd_aspectRatio {
    return ^(CGFloat ratio){
        JDRelation *target = [self jd_tmpAttribute].aspectRatio;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [self jd_tmpAttribute].aspectRatio = target;
        }
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

- (JDViewVoidBlock)jd_reset {
    return ^(void){
        JDAttribute *attribute = [self jd_tmpAttribute];
        [attribute jd_reset];
        return self;
    };
}

- (JDViewVoidBlock)jd_resetHorizontal {
    return ^(void){
        JDAttribute *attribute = [self jd_tmpAttribute];
        [attribute jd_resetHorizontal];
        return self;
    };
}

- (JDViewVoidBlock)jd_resetVertical {
    return ^(void){
        JDAttribute *attribute = [self jd_tmpAttribute];
        [attribute jd_resetVertical];
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
    
@end
#pragma mark ------一 些简写的功能 ----------
@implementation UIView(JDAutoLayoutExtention)

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
                .jd_left(lastView).jd_equal(0)
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
                .jd_top(lastView).jd_equal(0)
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

@end

@implementation UIView(JDViewAttribute)

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

@end


