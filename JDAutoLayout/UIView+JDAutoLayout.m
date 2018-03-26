//
//  UIView+AutoLayout.m
//  AutoLayout
//
//  Created by JD on 2017/12/21.
//  Copyright © 2017年 . All rights reserved.
//

#import "UIView+JDAutoLayout.h"
#import <objc/runtime.h>

#pragma mark ---------------JDRelation------------------------

//单个约束基本参数的模型
@interface JDRelation()
@property (nonatomic, weak) UIView *firstItem;
@property (nonatomic, weak) UIView *secondItem;
@property (nonatomic, assign) NSLayoutAttribute firstAttribute;
@property (nonatomic, assign) NSLayoutAttribute secondAttribute;
@property (nonatomic, assign) NSLayoutRelation relation;
@property (nonatomic, assign) CGFloat constant;
@property (nonatomic, assign) CGFloat multiplier;
@end

@implementation JDRelation {
    @public
    BOOL _installed;
    @private
    UIView *_installedView;
    NSLayoutConstraint *_constraint;
}

- (instancetype)init {
    if (self = [super init]) {
        _multiplier = 1;
        _installed = NO;
    }
    return self;
}

- (JDRelationFloatBlock)jd_multiplier {
    __weak JDRelation *weaskSelf = self;
    return ^(CGFloat multiplier){
        __strong JDRelation *strongSelf = weaskSelf;
        strongSelf.multiplier = multiplier;
        return strongSelf;
    };
}

- (JDViewFloatBlock)jd_equal {
    __weak JDRelation *weaskSelf = self;
    return ^(CGFloat constant){
        __strong JDRelation *strongSelf = weaskSelf;
        strongSelf.relation = NSLayoutRelationEqual;
        strongSelf.constant = constant;
        return strongSelf.firstItem;
    };
}

- (JDViewFloatBlock)jd_lessThanOrEqual {
    __weak JDRelation *weaskSelf = self;
    return ^(CGFloat constant){
        __strong JDRelation *strongSelf = weaskSelf;
        strongSelf.relation = NSLayoutRelationLessThanOrEqual;
        strongSelf.constant = constant;
        return strongSelf.firstItem;
    };
}

- (JDViewFloatBlock)jd_greaterThanOrEqual {
    __weak JDRelation *weaskSelf = self;
    return ^(CGFloat constant){
        __strong JDRelation *strongSelf = weaskSelf;
        strongSelf.relation = NSLayoutRelationGreaterThanOrEqual;
        strongSelf.constant = constant;
        return strongSelf.firstItem;
    };
}

- (JDViewVoidBlock)jd_and {
    __weak JDRelation *weaskSelf = self;
    return ^(void){
        __strong JDRelation *strongSelf = weaskSelf;
        return strongSelf.firstItem;
    };
}

- (JDVoidBlock)jd_layout {
    __weak JDRelation *weaskSelf = self;
    return ^(void){
        __strong JDRelation *strongSelf = weaskSelf;
        return strongSelf.firstItem.jd_layout();
    };
}

- (JDVoidBlock)jd_update {
    __weak JDRelation *weaskSelf = self;
    return ^(void){
        __strong JDRelation *strongSelf = weaskSelf;
        return strongSelf.firstItem.jd_update();
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
    _constraint.constant = self.constant;
    _installed = YES;
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

- (void)jd_clear {
    self.left = nil;
    self.top = nil;
    self.right = nil;
    self.bottom = nil;
    self.width = nil;
    self.height = nil;
    self.centerX = nil;
    self.centerY = nil;
    self.aspectRatio = nil;
}

@end

#pragma mark ---------------JDAutoLayout------------------------

@implementation UIView (JDAutoLayout)

- (JDRelationAttrBlock)jd_left {
    __weak UIView *weaskSelf = self;
    return ^(id attr){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf jd_tmpAttribute].left;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf jd_tmpAttribute].left = target;
        }
        target.firstItem = strongSelf;
        target.firstAttribute = NSLayoutAttributeLeading;
        
        UIView *view = attr;
        NSLayoutAttribute secondAttribute = 0;
        if ([attr isKindOfClass:[JDViewAttribute class]]) {
            JDViewAttribute *secondRelation = attr;
            view = secondRelation.view;
            secondAttribute = secondRelation.attribute;
        }
        target.secondItem = view;
        if ([strongSelf isDescendantOfView:view]) {
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
    __weak UIView *weaskSelf = self;
    return ^(id attr){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf jd_tmpAttribute].top;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf jd_tmpAttribute].top = target;
        }
        target.firstItem = strongSelf;
        target.firstAttribute = NSLayoutAttributeTop;
        
        UIView *view = attr;
        NSLayoutAttribute secondAttribute = 0;
        if ([attr isKindOfClass:[JDViewAttribute class]]) {
            JDViewAttribute *secondRelation = attr;
            view = secondRelation.view;
            secondAttribute = secondRelation.attribute;
        }
        target.secondItem = view;
        if ([strongSelf isDescendantOfView:view]) {
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
    __weak UIView *weaskSelf = self;
    return ^(id attr){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf jd_tmpAttribute].right;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf jd_tmpAttribute].right = target;
        }
        target.firstItem = strongSelf;
        target.firstAttribute = NSLayoutAttributeTrailing;
        
        UIView *view = attr;
        NSLayoutAttribute secondAttribute = 0;
        if ([attr isKindOfClass:[JDViewAttribute class]]) {
            JDViewAttribute *secondRelation = attr;
            view = secondRelation.view;
            secondAttribute = secondRelation.attribute;
        }
        target.secondItem = view;
        if ([strongSelf isDescendantOfView:view]) {
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
    __weak UIView *weaskSelf = self;
    return ^(id attr){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf jd_tmpAttribute].bottom;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf jd_tmpAttribute].bottom = target;
        }
        target.firstItem = strongSelf;
        target.firstAttribute = NSLayoutAttributeBottom;
        
        UIView *view = attr;
        NSLayoutAttribute secondAttribute = 0;
        if ([attr isKindOfClass:[JDViewAttribute class]]) {
            JDViewAttribute *secondRelation = attr;
            view = secondRelation.view;
            secondAttribute = secondRelation.attribute;
        }
        target.secondItem = view;
        if ([strongSelf isDescendantOfView:view]) {
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
    __weak UIView *weaskSelf = self;
    return ^(id attr){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf jd_tmpAttribute].centerX;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf jd_tmpAttribute].centerX = target;
        }
        target.firstItem = strongSelf;
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
    __weak UIView *weaskSelf = self;
    return ^(id attr){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf jd_tmpAttribute].centerY;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf jd_tmpAttribute].centerY = target;
        }
        target.firstItem = strongSelf;
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
    __weak UIView *weaskSelf = self;
    return ^(id attr){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf jd_tmpAttribute].width;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf jd_tmpAttribute].width = target;
        }
        target.firstItem = strongSelf;
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
    __weak UIView *weaskSelf = self;
    return ^(id attr){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf jd_tmpAttribute].height;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf jd_tmpAttribute].height = target;
        }
        target.firstItem = strongSelf;
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
    __weak UIView *weaskSelf = self;
    return ^(CGFloat ratio){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf jd_tmpAttribute].aspectRatio;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf jd_tmpAttribute].aspectRatio = target;
        }
        target.firstItem = strongSelf;
        target.firstAttribute = NSLayoutAttributeWidth;
        target.secondItem = strongSelf;
        target.secondAttribute = NSLayoutAttributeHeight;
        target.multiplier = ratio;
        target->_installed = NO;
        return strongSelf;
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
    __weak UIView *weaskSelf = self;
    return ^(void){
        __strong UIView *strongSelf = weaskSelf;
        return strongSelf;
    };
}

- (JDViewVoidBlock)jd_reset {
    __weak UIView *weaskSelf = self;
    return ^(void){
        __strong UIView *strongSelf = weaskSelf;
        JDAttribute *attribute = [strongSelf jd_tmpAttribute];
        [attribute jd_clear];
        return strongSelf;
    };
}


- (JDVoidBlock)jd_layout {
    __weak UIView *weaskSelf = self;
    return ^(void){
        __strong UIView *strongSelf = weaskSelf;
        if (strongSelf.superview == nil) {
            return;
        }
        strongSelf.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *allAttributes = [[strongSelf jd_tmpAttribute] jd_allAttributes];
        //开始约束布局
        for (JDRelation *relation in allAttributes) {
            [relation jd_installConstraint];
        }
    };
}

- (JDVoidBlock)jd_update {
    __weak UIView *weaskSelf = self;
    return ^(void){
        __strong UIView *strongSelf = weaskSelf;
        NSArray *allAttributes = [[strongSelf jd_tmpAttribute] jd_allAttributes];
        //开始更新约束布局
        for (JDRelation *relation in allAttributes) {
            [relation jd_updateConstraint];
        }
    };
}
    
@end
#pragma mark ------一 些简写的功能 ----------
@implementation UIView(JDAutolayoutExtention)

- (JDViewSizeBlock)jd_size {
    __weak UIView *weaskSelf = self;
    return ^(CGSize size){
        __strong UIView *strongSelf = weaskSelf;
        return strongSelf
        .jd_width(nil).jd_equal(size.width)
        .jd_height(nil).jd_equal(size.height);
    };
}
    
- (JDViewRectBlock)jd_frame {
    __weak UIView *weaskSelf = self;
    return ^(CGRect frame){
        __strong UIView *strongSelf = weaskSelf;
        return strongSelf
        .jd_left(strongSelf.superview).jd_equal(frame.origin.x)
        .jd_top(strongSelf.superview).jd_equal(frame.origin.y)
        .jd_size(frame.size);
    };
}
    
- (JDViewInsetsBlock)jd_insets; {
    __weak UIView *weaskSelf = self;
    return ^(UIEdgeInsets insets){
        __strong UIView *strongSelf = weaskSelf;
        return strongSelf
        .jd_left(strongSelf.superview).jd_equal(insets.left)
        .jd_top(strongSelf.superview).jd_equal(insets.top)
        .jd_right(strongSelf.superview).jd_equal(insets.right)
        .jd_bottom(strongSelf.superview).jd_equal(insets.bottom);
    };
}

- (JDVoidArrayBlock)jd_equalWidthSubViews {
    __weak UIView *weaskSelf = self;
    return ^(NSArray *subViews){
        __strong UIView *strongSelf = weaskSelf;
        UIView *lastView = nil;
        for (UIView *view in subViews) {
            if (lastView == nil) {
                view
                .jd_left(strongSelf).jd_equal(0)
                .jd_centerY(strongSelf).jd_equal(0)
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
        .jd_right(strongSelf).jd_equal(0)
        .jd_layout();
    };
}
    
- (JDVoidArrayBlock)jd_equalHeightSubViews {
    __weak UIView *weaskSelf = self;
    return ^(NSArray *subViews){
        __strong UIView *strongSelf = weaskSelf;
        UIView *lastView = nil;
        for (UIView *view in subViews) {
            if (lastView == nil) {
                view
                .jd_top(strongSelf).jd_equal(0)
                .jd_centerX(strongSelf).jd_equal(0)
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
        .jd_bottom(strongSelf).jd_equal(0)
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
+ (instancetype)initWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute {
    JDViewAttribute *instance = [[JDViewAttribute alloc] init];
    instance.view = view;
    instance.attribute = attribute;
    return instance;
}
@end

@implementation UIView(JDViewAttribute)
@dynamic jd_leftAttribute;
@dynamic jd_topAttribute;
@dynamic jd_rightAttribute;
@dynamic jd_bottomAttribute;
@dynamic jd_centerXAttribute;
@dynamic jd_centerYAttribute;
@dynamic jd_baselineAttribute;
@dynamic jd_widthAttribute;
@dynamic jd_heightAttribute;
    
#pragma mark ---------- 获取属性 -------------
- (JDViewAttribute *)jd_leftAttribute {
    return [JDViewAttribute initWithView:self attribute:NSLayoutAttributeLeading];
}
- (JDViewAttribute *)jd_topAttribute {
    return [JDViewAttribute initWithView:self attribute:NSLayoutAttributeTop];
}
- (JDViewAttribute *)jd_rightAttribute {
    return [JDViewAttribute initWithView:self attribute:NSLayoutAttributeTrailing];
}
- (JDViewAttribute *)jd_bottomAttribute {
    return [JDViewAttribute initWithView:self attribute:NSLayoutAttributeBottom];
}
- (JDViewAttribute *)jd_widthAttribute {
    return [JDViewAttribute initWithView:self attribute:NSLayoutAttributeWidth];
}
- (JDViewAttribute *)jd_heightAttribute {
    return [JDViewAttribute initWithView:self attribute:NSLayoutAttributeHeight];
}
- (JDViewAttribute *)jd_centerXAttribute {
    return [JDViewAttribute initWithView:self attribute:NSLayoutAttributeCenterX];
}
- (JDViewAttribute *)jd_centerYAttribute {
    return [JDViewAttribute initWithView:self attribute:NSLayoutAttributeCenterY];
}
- (JDViewAttribute *)jd_baselineAttribute {
    return [JDViewAttribute initWithView:self attribute:NSLayoutAttributeBaseline];
}
@end


