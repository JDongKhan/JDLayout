//
//  NSLayoutConstraint+JDLayoutDebug.h
//  JDLayout
//
//  Created by JD on 2018/5/3.
//


#import <Foundation/Foundation.h>

@interface NSLayoutConstraint (JDLayoutDebug)

- (NSString *)jd_description;

@end

@interface NSObject (JDLayoutDebug)


+ (NSString *)jd_descriptionForObject:(id)obj;

@end
