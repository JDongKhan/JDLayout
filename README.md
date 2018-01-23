# JDLayout
超简易的约束布局

只有一个类，以下是所有方法，支持绝大多数场景。

    @interface UIView (JDAutolayout)
    - (UIView *(^)(void))function(reset);
    - (JDRelation *(^)(UIView *view))function(left);
    - (JDRelation *(^)(UIView *view))function(top);
    - (JDRelation *(^)(UIView *view))function(right);
    - (JDRelation *(^)(UIView *view))function(bottom);
    - (JDRelation *(^)(UIView *view))function(centerX);
    - (JDRelation *(^)(UIView *view))function(centerY);
    - (JDRelation *(^)(void))function(width);
    - (JDRelation *(^)(void))function(height);
    - (void(^)(void))function(layout);
    - (void(^)(void))function(reload);

    - (UIView *(^)(UIView *view))function(equalWidth);
    - (UIView *(^)(UIView *view))function(equalHeight);

    @end

    @interface JDRelation : NSObject
    //对齐
    - (JDRelation *(^)(void))function(align);

    - (UIView *(^)(CGFloat constant))function(equal);
    - (UIView *(^)(CGFloat constant))function(lessThanOrEqual);
    - (UIView *(^)(CGFloat constant))function(greaterThanOrEqual);
    @end


## 一、更新现有的约束

    self.button2.jd_left(self.button1).jd_equal(100).jd_reload();

## 二、垂直平分

    //垂直平分
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"我是垂直平分1";
    label1.backgroundColor = [UIColor redColor];
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view1 addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"我是垂直平分2";
    label2.backgroundColor = [UIColor blueColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [self.view1 addSubview:label2];
    
    label1
    .jd_top(self.view1).jd_equal(0)
    .jd_centerX(self.view1).jd_equal(0)
    .jd_layout();
    
    label2
    .jd_top(label1).jd_equal(0)
    .jd_centerX(label1).jd_equal(0)
    .jd_bottom(self.view1).jd_equal(0)
    .jd_equalHeight(label1)
    .jd_layout();

## 三、水平平分

    //水平平分
    UILabel *label11 = [[UILabel alloc] init];
    label11.text = @"我是水平平分1";
    label11.backgroundColor = [UIColor redColor];
    label11.textAlignment = NSTextAlignmentCenter;
    [self.view2 addSubview:label11];
    UILabel *label21 = [[UILabel alloc] init];
    label21.text = @"我是水平平分2";
    label21.backgroundColor = [UIColor blueColor];
    label21.textAlignment = NSTextAlignmentCenter;
    [self.view2 addSubview:label21];

    label11
    .jd_left(self.view2).jd_equal(0)
    .jd_centerY(self.view2).jd_equal(0)
    .jd_layout();
    
    label21
    .jd_left(label11).jd_equal(0)
    .jd_centerY(label11).jd_equal(0)
    .jd_right(self.view2).jd_equal(0)
    .jd_equalWidth(label11)
    .jd_layout();
    
## 四、对齐

    //水平平分
    UILabel *label11 = [[UILabel alloc] init];
    label11.text = @"我是1";
    label11.backgroundColor = [UIColor redColor];
    label11.textAlignment = NSTextAlignmentCenter;
    [self.view3 addSubview:label11];
    
    label11.jd_left(self.view3).jd_equal(10)
    .jd_top(self.view3).jd_equal(10).jd_layout();
    
    UILabel *label21 = [[UILabel alloc] init];
    label21.text = @"我是2";
    label21.backgroundColor = [UIColor blueColor];
    label21.textAlignment = NSTextAlignmentCenter;
    [self.view3 addSubview:label21];
    //与label11左对齐
    label21.jd_left(label11).jd_align().jd_equal(0)
    .jd_top(label11).jd_equal(10).jd_layout();
    
    

##五、支持lessThanOrEqual、greaterThanOrEqual、equal等
