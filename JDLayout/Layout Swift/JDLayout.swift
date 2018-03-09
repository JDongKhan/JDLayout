//
//  JDLayout.swift
//  JDLayout
//
//  Created by JD on 2018/3/9.
//  Copyright © 2018年 Suning. All rights reserved.
//

import Foundation

extension UIView {
    public func swift_left(_ view:UIView)->JDSwiftRelation {
        return JDSwiftRelation(self.jd_left()(view)!)
    }
    public func swift_top(_ view:UIView)->JDSwiftRelation {
        return JDSwiftRelation(self.jd_top()(view)!)
    }
    public func swift_right(_ view:UIView)->JDSwiftRelation {
        return JDSwiftRelation(self.jd_right()(view)!)
    }
    public func swift_bottom(_ view:UIView)->JDSwiftRelation {
        return JDSwiftRelation(self.jd_bottom()(view)!)
    }
    public func swift_centerX(_ view:UIView)->JDSwiftRelation {
        return JDSwiftRelation(self.jd_centerX()(view)!)
    }
    public func swift_centerY(_ view:UIView)->JDSwiftRelation {
        return JDSwiftRelation(self.jd_centerY()(view)!)
    }
    public func swift_width()->JDSwiftRelation {
        return JDSwiftRelation(self.jd_width()()!)
    }
    public func swift_height()->JDSwiftRelation {
        return JDSwiftRelation(self.jd_height()()!)
    }
    
    public func swift_size(_ size:CGSize)->UIView {
        return self.jd_size()(size)!
    }
    
    public func swift_frame(_ frame:CGRect)->UIView {
        return self.jd_frame()(frame)!
    }
    
    public func swift_insets(_ insets:UIEdgeInsets)->UIView {
        return self.jd_insets()(insets)!
    }
    
    public func swift_equalWidth(_ view:UIView)->UIView {
        return self.jd_equalWidth()(view)!
    }
    
    public func swift_equalHeight(_ view:UIView)->UIView {
        return self.jd_equalHeight()(view)!
    }
    
    public func swift_and()->UIView {
        return self.jd_and()()!;
    }
    
    public func swift_layout() {
        self.jd_layout()()
    }
    public func swift_update() {
        self.jd_update()()
    }
    
}

public class JDSwiftRelation {
    
    var relation:JDRelation;
    
    public init(_ relation:JDRelation) {
        self.relation = relation
    }
    //对齐
    public func swift_align()->JDSwiftRelation {
        self.relation.jd_align()
        return self
    }
    
    /**
     倍数
     */
    public func swift_multiplier(_ multiplier:CGFloat)->JDSwiftRelation {
        self.relation.jd_multiplier()(multiplier)
        return self
    }
    /**
     约束关系
     */
    public func swift_equal(_ constant:CGFloat)->UIView {
        return self.relation.jd_equal()(constant)!
    }
    public func swift_lessThanOrEqual(_ constant:CGFloat)->UIView {
        return self.relation.jd_lessThanOrEqual()(constant)!
    }
    public func swift_greaterThanOrEqual(_ constant:CGFloat)->UIView {
        return self.relation.jd_greaterThanOrEqual()(constant)!
    }
    public func swift_and()->UIView {
        return self.relation.jd_and()()!;
    }
    
    public func swift_layout() {
        self.relation.jd_layout()()
    }
    public func swift_update() {
        self.relation.jd_update()()
    }
    
}
