//
//  Demo2.swift
//  JDLayout
//
//  Created by JD on 2018/3/9.
//  Copyright © 2018年 jd. All rights reserved.
//

import Foundation
import UIKit
import JDLayout

public class Demo2ViewController: UIViewController {
    
    private var view0: UIView!;
    
    private var view1: UIView!;
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = "demo2"
        self.view.backgroundColor = UIColor.white
        //swift调用oc
        self.view0 = UIView.init()
        self.view0.backgroundColor = UIColor.blue
        self.view.addSubview(self.view0)
        self.view0
            .jd_size(CGSize(width: 200, height: 100))
            .jd_centerX(self.view!)
            .jd_centerY(self.view!)
            .jd_layout()
        
        //swift封装的布局类
        self.view1 = UIView.init()
        self.view1.backgroundColor = UIColor.red
        self.view.addSubview(self.view1)
        //jd_width、jd_height如果传的是view代表与此view等宽、等高
        self.view1
            .jd_frame(CGRect(x: 100, y: 100, width: 10, height: 10))
            .jd_width(self.view0)
            .jd_height(self.view0)
            .jd_layout()
    }
    
}
