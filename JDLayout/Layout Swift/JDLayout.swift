//
//  JDLayout.swift
//  JDLayout
//
//  Created by JD on 2018/3/9.
//  Copyright © 2018年 Suning. All rights reserved.
//

import Foundation

extension UIView {
    public func sf_left(_ view:Any)->JDSwiftRelation {
        return JDSwiftRelation(self.jd_left()(view)!)
    }
    public func sf_top(_ view:Any)->JDSwiftRelation {
        return JDSwiftRelation(self.jd_top()(view)!)
    }
    public func sf_right(_ view:Any)->JDSwiftRelation {
        return JDSwiftRelation(self.jd_right()(view)!)
    }
    public func sf_bottom(_ view:Any)->JDSwiftRelation {
        return JDSwiftRelation(self.jd_bottom()(view)!)
    }
    public func sf_centerX(_ view:Any)->JDSwiftRelation {
        return JDSwiftRelation(self.jd_centerX()(view)!)
    }
    public func sf_centerY(_ view:Any)->JDSwiftRelation {
        return JDSwiftRelation(self.jd_centerY()(view)!)
    }
    public func sf_width(_ view:Any)->JDSwiftRelation {
        return JDSwiftRelation(self.jd_width()(view)!)
    }
    public func sf_height(_ view:Any)->JDSwiftRelation {
        return JDSwiftRelation(self.jd_height()(view)!)
    }
    
    public func sf_aspectRatio(_ ration:CGFloat)->UIView {
        return self.jd_aspectRatio()(ration)!
    }
    
    public func sf_size(_ size:CGSize)->UIView {
        return self.jd_size()(size)!
    }
    
    public func sf_frame(_ frame:CGRect)->UIView {
        return self.jd_frame()(frame)!
    }
    
    public func sf_insets(_ insets:UIEdgeInsets)->UIView {
        return self.jd_insets()(insets)!
    }
    
    public func sf_and()->UIView {
        return self.jd_and()()!;
    }
    
    public func sf_layout() {
        self.jd_layout()()
    }
    public func sf_update() {
        self.jd_update()()
    }
    
}

public class JDSwiftRelation {
    
    var relation:JDRelation;
    
    public init(_ relation:JDRelation) {
        self.relation = relation
    }
    
    /**
     倍数
     */
    public func sf_multiplier(_ multiplier:CGFloat)->JDSwiftRelation {
        self.relation.jd_multiplier()(multiplier)
        return self
    }
    /**
     约束关系
     */
    public func sf_equal(_ constant:CGFloat)->UIView {
        return self.relation.jd_equal()(constant)!
    }
    public func sf_lessThanOrEqual(_ constant:CGFloat)->UIView {
        return self.relation.jd_lessThanOrEqual()(constant)!
    }
    public func sf_greaterThanOrEqual(_ constant:CGFloat)->UIView {
        return self.relation.jd_greaterThanOrEqual()(constant)!
    }
    public func sf_and()->UIView {
        return self.relation.jd_and()()!;
    }
    
    public func sf_layout() {
        self.relation.jd_layout()()
    }
    public func sf_update() {
        self.relation.jd_update()()
    }
    
}
