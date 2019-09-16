//
//  NSLayoutConstraint+JDLayoutDebug.h
//  JDLayout
//
//  Created by JD on 2018/5/3.
//

#import "NSLayoutConstraint+JDLayoutDebug.h"
#import <objc/runtime.h>

@implementation NSLayoutConstraint (JDLayoutDebug)

#pragma mark - description maps

+ (NSDictionary *)sn_layoutRelationDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
        descriptionMap = @{
            @(NSLayoutRelationEqual)                : @"==",
            @(NSLayoutRelationGreaterThanOrEqual)   : @">=",
            @(NSLayoutRelationLessThanOrEqual)      : @"<=",
        };
    });
    return descriptionMap;
}

+ (NSDictionary *)sn_layoutAttributeDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
        descriptionMap = @{
            @(NSLayoutAttributeTop)      : @"top",
            @(NSLayoutAttributeLeft)     : @"left",
            @(NSLayoutAttributeBottom)   : @"bottom",
            @(NSLayoutAttributeRight)    : @"right",
            @(NSLayoutAttributeLeading)  : @"leading",
            @(NSLayoutAttributeTrailing) : @"trailing",
            @(NSLayoutAttributeWidth)    : @"width",
            @(NSLayoutAttributeHeight)   : @"height",
            @(NSLayoutAttributeCenterX)  : @"centerX",
            @(NSLayoutAttributeCenterY)  : @"centerY",
            @(NSLayoutAttributeBaseline) : @"baseline",
            @(NSLayoutAttributeFirstBaseline) : @"firstBaseline",
            @(NSLayoutAttributeLastBaseline) : @"lastBaseline",
        };
    
    });
    return descriptionMap;
}


+ (NSDictionary *)sn_layoutPriorityDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
        descriptionMap = @{
            @(UILayoutPriorityDefaultHigh)      : @"high",
            @(UILayoutPriorityDefaultLow)       : @"low",
            @(UILayoutPriorityRequired)         : @"required",
            @(UILayoutPriorityFittingSizeLevel) : @"fitting size",
        };
    });
    return descriptionMap;
}


- (NSString *)sn_description {
    NSMutableString *description = [[NSMutableString alloc] init];
    [description appendFormat:@" %@", [self.class jd_descriptionForObject:self.firstItem]];
    if (self.firstAttribute != NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@".%@", self.class.sn_layoutAttributeDescriptionsByValue[@(self.firstAttribute)]];
    }

    [description appendFormat:@" %@", self.class.sn_layoutRelationDescriptionsByValue[@(self.relation)]];

    if (self.secondItem) {
        [description appendFormat:@" %@", [self.class jd_descriptionForObject:self.secondItem]];
    }
    if (self.secondAttribute != NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@".%@", self.class.sn_layoutAttributeDescriptionsByValue[@(self.secondAttribute)]];
    }
    
    if (self.multiplier != 1) {
        [description appendFormat:@" * %g", self.multiplier];
    }
    
    if (self.secondAttribute == NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@" %g", self.constant];
    } else {
        if (self.constant) {
            [description appendFormat:@" %@ %g", (self.constant < 0 ? @"-" : @"+"), ABS(self.constant)];
        }
    }

    if (self.priority != UILayoutPriorityRequired) {
        [description appendFormat:@" ^%@", self.class.sn_layoutPriorityDescriptionsByValue[@(self.priority)] ?: [NSNumber numberWithDouble:self.priority]];
    }

    return description;
}

@end

@implementation NSObject (SNAutoLayoutDebug)


+ (NSString *)jd_descriptionForObject:(id)obj {
    return [NSString stringWithFormat:@"%@(%p)", [obj class], obj];
}


@end
