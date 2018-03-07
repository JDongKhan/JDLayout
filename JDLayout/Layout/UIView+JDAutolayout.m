//
//  UIView+Autolayout.m
//  AutoLayout
//
//  Created by JD on 2017/12/21.
//  Copyright © 2017年 . All rights reserved.
//

#import "UIView+JDAutolayout.h"
#import <objc/runtime.h>

#pragma mark ---------------JDAttribute------------------------
@interface JDAttribute : NSObject
@property (nonatomic, strong) JDRelation *left;
@property (nonatomic, strong) JDRelation *top;
@property (nonatomic, strong) JDRelation *right;
@property (nonatomic, strong) JDRelation *bottom;
@property (nonatomic, strong) JDRelation *width;
@property (nonatomic, strong) JDRelation *height;
@property (nonatomic, strong) JDRelation *centerX;
@property (nonatomic, strong) JDRelation *centerY;
@end
@implementation JDAttribute
- (void)clear {
    self.left = nil;
    self.top = nil;
    self.right = nil;
    self.bottom = nil;
    self.width = nil;
    self.height = nil;
    self.centerX = nil;
    self.centerY = nil;
}
@end
#pragma mark ---------------JDRelation------------------------
@interface JDRelation()
@property (nonatomic, weak) UIView *firstItem;
@property (nonatomic, weak) UIView *secondItem;
@property (nonatomic, assign) NSLayoutAttribute firstAttribute;
@property (nonatomic, assign) NSLayoutAttribute secondAttribute;
@property (nonatomic, assign) NSLayoutRelation relation;
@property (nonatomic, assign) CGFloat constant;
@end
@implementation JDRelation

- (JDRelation *(^)(void))function(align) {
    __weak JDRelation *weaskSelf = self;
    return ^(void){
        __strong JDRelation *strongSelf = weaskSelf;
        strongSelf.secondAttribute = strongSelf.firstAttribute;
        return strongSelf;
    };
}

- (UIView *(^)(CGFloat constant))function(equal) {
    __weak JDRelation *weaskSelf = self;
    return ^(CGFloat constant){
         __strong JDRelation *strongSelf = weaskSelf;
        strongSelf.relation = NSLayoutRelationEqual;
        strongSelf.constant = constant;
        return strongSelf.firstItem;
    };
}
- (UIView *(^)(CGFloat constant))function(lessThanOrEqual) {
    __weak JDRelation *weaskSelf = self;
    return ^(CGFloat constant){
        __strong JDRelation *strongSelf = weaskSelf;
        strongSelf.relation = NSLayoutRelationLessThanOrEqual;
        strongSelf.constant = constant;
        return strongSelf.firstItem;
    };
}
- (UIView *(^)(CGFloat constant))function(greaterThanOrEqual) {
    __weak JDRelation *weaskSelf = self;
    return ^(CGFloat constant){
        __strong JDRelation *strongSelf = weaskSelf;
        strongSelf.relation = NSLayoutRelationGreaterThanOrEqual;
        strongSelf.constant = constant;
        return strongSelf.firstItem;
    };
}
@end

#pragma mark ---------------JDAutolayout------------------------

@implementation UIView (JDAutolayout)
- (UIView *(^)(void))function(reset) {
    __weak UIView *weaskSelf = self;
    return ^(void){
        __strong UIView *strongSelf = weaskSelf;
        JDAttribute *attribute = [strongSelf tmpAttribute];
        [attribute clear];
        return strongSelf;
    };
}
- (JDRelation *(^)(UIView *view))function(left) {
    __weak UIView *weaskSelf = self;
    return ^(UIView *view){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf tmpAttribute].left;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf tmpAttribute].left = target;
        }
        target.firstItem = strongSelf;
        target.secondItem = view;
        if (view == strongSelf.superview) {
            target.firstAttribute = NSLayoutAttributeLeading;
            target.secondAttribute = NSLayoutAttributeLeading;
        } else {
            target.firstAttribute = NSLayoutAttributeLeading;
            target.secondAttribute = NSLayoutAttributeTrailing;
        }
        return target;
    };
}
- (JDRelation *(^)(UIView *view))function(top) {
    __weak UIView *weaskSelf = self;
    return ^(UIView *view){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf tmpAttribute].top;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf tmpAttribute].top = target;
        }
        target.firstItem = strongSelf;
        target.secondItem = view;
        if (view == strongSelf.superview) {
            target.firstAttribute = NSLayoutAttributeTop;
            target.secondAttribute = NSLayoutAttributeTop;
        } else {
            target.firstAttribute = NSLayoutAttributeTop;
            target.secondAttribute = NSLayoutAttributeBottom;
        }
        return target;
    };
}
- (JDRelation *(^)(UIView *view))function(right) {
    __weak UIView *weaskSelf = self;
    return ^(UIView *view){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf tmpAttribute].right;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf tmpAttribute].right = target;
        }
        target.firstItem = strongSelf;
        target.secondItem = view;
        if (view == strongSelf.superview) {
            target.firstAttribute = NSLayoutAttributeTrailing;
            target.secondAttribute = NSLayoutAttributeTrailing;
        } else {
            target.firstAttribute = NSLayoutAttributeTrailing;
            target.secondAttribute = NSLayoutAttributeLeading;
        }
        return target;
    };
}
- (JDRelation *(^)(UIView *view))function(bottom) {
    __weak UIView *weaskSelf = self;
    return ^(UIView *view){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf tmpAttribute].bottom;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf tmpAttribute].bottom = target;
        }
        target.firstItem = strongSelf;
        target.secondItem = view;
        if (view == strongSelf.superview) {
            target.firstAttribute = NSLayoutAttributeBottom;
            target.secondAttribute = NSLayoutAttributeBottom;
        } else {
            target.firstAttribute = NSLayoutAttributeBottom;
            target.secondAttribute = NSLayoutAttributeTop;
        }
        return target;
    };
}
- (JDRelation *(^)(UIView *view))function(centerX) {
    __weak UIView *weaskSelf = self;
    return ^(UIView *view){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf tmpAttribute].centerX;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf tmpAttribute].centerX = target;
        }
        target.firstItem = strongSelf;
        target.secondItem = view;
        target.firstAttribute = NSLayoutAttributeCenterX;
        target.secondAttribute = NSLayoutAttributeCenterX;
        return target;
    };
}
- (JDRelation *(^)(UIView *view))function(centerY) {
    __weak UIView *weaskSelf = self;
    return ^(UIView *view){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf tmpAttribute].centerY;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf tmpAttribute].centerY = target;
        }
        target.firstItem = strongSelf;
        target.secondItem = view;
        target.firstAttribute = NSLayoutAttributeCenterY;
        target.secondAttribute = NSLayoutAttributeCenterY;
        return target;
    };
}
- (JDRelation *(^)(void))function(width){
    __weak UIView *weaskSelf = self;
    return ^(){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf tmpAttribute].width;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf tmpAttribute].width = target;
        }
        target.firstItem = strongSelf;
        target.firstAttribute = NSLayoutAttributeWidth;
        target.secondAttribute = NSLayoutAttributeNotAnAttribute;
        return target;
    };
}
- (JDRelation *(^)(void))function(height) {
    __weak UIView *weaskSelf = self;
    return ^(){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf tmpAttribute].height;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf tmpAttribute].height = target;
        }
        target.firstItem = strongSelf;
        target.firstAttribute = NSLayoutAttributeHeight;
        target.secondAttribute = NSLayoutAttributeNotAnAttribute;
        return target;
    };
}

- (UIView *(^)(UIView *view))function(equalWidth) {
    __weak UIView *weaskSelf = self;
    return ^(UIView *view){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf tmpAttribute].width;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf tmpAttribute].width = target;
        }
        target.firstItem = strongSelf;
        target.secondItem = view;
        target.relation = NSLayoutRelationEqual;
        target.firstAttribute = NSLayoutAttributeWidth;
        target.secondAttribute = NSLayoutAttributeWidth;
        return strongSelf;
    };
}
- (UIView *(^)(UIView *view))function(equalHeight) {
    __weak UIView *weaskSelf = self;
    return ^(UIView *view){
        __strong UIView *strongSelf = weaskSelf;
        JDRelation *target = [strongSelf tmpAttribute].height;
        if (target == nil) {
            target = [[JDRelation alloc] init];
            [strongSelf tmpAttribute].height = target;
        }
        target.firstItem = strongSelf;
        target.secondItem = view;
        target.relation = NSLayoutRelationEqual;
        target.firstAttribute = NSLayoutAttributeHeight;
        target.secondAttribute = NSLayoutAttributeHeight;
        return strongSelf;
    };
}

/////////////////////////////////////////////////////
- (JDAttribute *)tmpAttribute {
    JDAttribute *tmpAttribute = objc_getAssociatedObject(self, _cmd);
    if (tmpAttribute == nil) {
        tmpAttribute = [[JDAttribute alloc] init];
        objc_setAssociatedObject(self, _cmd, tmpAttribute, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tmpAttribute;
}

- (void(^)(void))function(layout) {
    __weak UIView *weaskSelf = self;
    return ^(void){
        __strong UIView *strongSelf = weaskSelf;
        if (strongSelf.superview == nil) {
            return;
        }
        strongSelf.translatesAutoresizingMaskIntoConstraints = NO;
        JDAttribute *attribute = [strongSelf tmpAttribute];
        NSMutableArray *allAttributes = [NSMutableArray array];
        if (attribute.left) {
            [allAttributes addObject:attribute.left];
        }
        if (attribute.top) {
            [allAttributes addObject:attribute.top];
        }
        if (attribute.right) {
            [allAttributes addObject:attribute.right];
        }
        if (attribute.bottom) {
            [allAttributes addObject:attribute.bottom];
        }
        if (attribute.centerX) {
            [allAttributes addObject:attribute.centerX];
        }
        if (attribute.centerY) {
            [allAttributes addObject:attribute.centerY];
        }
        NSArray *constrains = strongSelf.constraints;
        //清理约束
        for (NSLayoutConstraint *constraint in constrains) {
            if ([constraint isMemberOfClass:[NSLayoutConstraint class]]){
                [strongSelf removeConstraint:constraint];
            }
        }
        constrains = strongSelf.superview.constraints;
        for (NSLayoutConstraint *constraint in constrains) {
            if ([constraint isMemberOfClass:[NSLayoutConstraint class]]) {
                if (constraint.firstItem == strongSelf) {
                    [strongSelf removeConstraint:constraint];
                }
            }
        }
        //开始约束布局
        for (JDRelation *relation in allAttributes) {
            [strongSelf.superview addConstraint:[NSLayoutConstraint constraintWithItem:relation.firstItem attribute:relation.firstAttribute relatedBy:relation.relation toItem:relation.secondItem attribute:relation.secondAttribute multiplier:1 constant:relation.constant]];
        }
        if (attribute.width) {
            NSLayoutConstraint *widthConstrant = [NSLayoutConstraint constraintWithItem:attribute.width.firstItem attribute:attribute.width.firstAttribute relatedBy:attribute.width.relation toItem:attribute.width.secondItem attribute:attribute.width.secondAttribute multiplier:1.0 constant:attribute.width.constant];
            if (attribute.width.secondItem != nil) {
                [strongSelf.superview addConstraint:widthConstrant];
            } else {
                [strongSelf addConstraint:widthConstrant];
            }
        }
        if (attribute.height) {
            NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:attribute.height.firstItem attribute:attribute.height.firstAttribute relatedBy:attribute.height.relation toItem:attribute.height.secondItem attribute:attribute.height.secondAttribute multiplier:1.0 constant:attribute.height.constant];
            if (attribute.height.secondItem != nil) {
                [strongSelf.superview addConstraint:heightConstraint];
            } else {
                [strongSelf addConstraint:heightConstraint];
            }
        }
    };
}

- (void(^)(void))function(reload) {
    __weak UIView *weaskSelf = self;
    return ^(void){
        __strong UIView *strongSelf = weaskSelf;
        JDAttribute *attribute = [strongSelf tmpAttribute];
        NSArray *constrains = strongSelf.constraints;
        //更新自身的约束
        for (NSLayoutConstraint *constraint in constrains) {
            if ([constraint isMemberOfClass:[NSLayoutConstraint class]]){
                if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                    constraint.constant = attribute.width.constant;
                } else if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                    constraint.constant = attribute.height.constant;
                }
            }
        }
        constrains = strongSelf.superview.constraints;
        //更新父view中有关自己的view
        //只能处理由当前view建立的约束，即firstItem是当前view
        for (NSLayoutConstraint *constraint in constrains) {
            if ([constraint isMemberOfClass:[NSLayoutConstraint class]]) {
                if (constraint.firstAttribute == NSLayoutAttributeLeading && constraint.firstItem == strongSelf) {
                    constraint.constant = attribute.left.constant;
                } else if (constraint.firstAttribute == NSLayoutAttributeTop && constraint.firstItem == strongSelf) {
                    constraint.constant = attribute.top.constant;
                } else if (constraint.firstAttribute == NSLayoutAttributeTrailing && constraint.firstItem == strongSelf) {
                    constraint.constant = attribute.right.constant;
                } else if (constraint.firstAttribute == NSLayoutAttributeBottom && constraint.firstItem == strongSelf) {
                    constraint.constant = attribute.bottom.constant;
                } else if (constraint.firstAttribute == NSLayoutAttributeCenterX && constraint.firstItem == strongSelf) {
                    constraint.constant = attribute.centerX.constant;
                } else if (constraint.firstAttribute == NSLayoutAttributeCenterY && constraint.firstItem == strongSelf) {
                    constraint.constant = attribute.centerY.constant;
                }
            }
        }
    };
}


@end

@implementation UIView(JDAutolayoutExtention)

- (void(^)(NSArray *subViews))function(equalWidthSubViews) {
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
                .jd_equalWidth(lastView)
                .jd_layout();
            }
            lastView = view;
        }
        lastView
        .jd_right(strongSelf).jd_equal(0)
        .jd_layout();
    };
}

- (void(^)(NSArray *subViews))function(equalHeightSubViews) {
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
                .jd_equalHeight(lastView)
                .jd_layout();
            }
            lastView = view;
        }
        lastView
        .jd_bottom(strongSelf).jd_equal(0)
        .jd_layout();
    };
}

@end


