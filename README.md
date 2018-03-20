# JDAutoLayout
超简易的约束布局

![demo png](https://github.com/wangjindong/JDLayout/blob/master/demo.gif "demo")

## cocoapods使用

    pod 'JDAutoLayout', '~> 1.1.7'

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
    .jd_height(label1)
    .jd_layout();
    
   简易的写法：
   
    self.view1.jd_equalHeightSubViews(@[label1,label2]);

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
    .jd_width(label11)
    .jd_layout();
    
   简易的写法
    
    self.view2.jd_equalWidthSubViews(@[label1,label21]);
    
## 四、对齐

    //水平平分
    UILabel *label11 = [[UILabel alloc] init];
    label11.text = @"我是1";
    label11.backgroundColor = [UIColor redColor];
    label11.textAlignment = NSTextAlignmentCenter;
    [self.view3 addSubview:label11];
    
    label11
    .jd_left(self.view3).jd_equal(10)
    .jd_top(self.view3).jd_equal(10)
    .jd_layout();
    
    UILabel *label21 = [[UILabel alloc] init];
    label21.text = @"我是2";
    label21.backgroundColor = [UIColor blueColor];
    label21.textAlignment = NSTextAlignmentCenter;
    [self.view3 addSubview:label21];
    //与label11左对齐
    label21
    .jd_left(label11.jd_leftAttribute).jd_equal(0)
    .jd_top(label11).jd_equal(10)
    .jd_layout();
    
    

## 五、支持lessThanOrEqual、greaterThanOrEqual、equal等



### 只有一个类，以下是所有方法，支持绝大多数场景。

    @interface UIView (JDAutolayout)

    /**
       约束基本设置
    */
    - (JDRelation *(^)(id attr))jd_left;
    - (JDRelation *(^)(id attr))jd_top;
    - (JDRelation *(^)(id attr))jd_right;
    - (JDRelation *(^)(id attr))jd_bottom;
    - (JDRelation *(^)(id attr))jd_centerX;
    - (JDRelation *(^)(id attr))jd_centerY;
    - (JDRelation *(^)(id attr))jd_width;
    - (JDRelation *(^)(id attr))jd_height;
    /**
     宽高比
     */
    - (UIView *(^)(CGFloat ratio))jd_aspectRatio;
    
    /**
     连接方法，用于逻辑上连接下一个语句
     */
    - (UIView *(^)(void))jd_and;
    
    /**
    重置约束
    */
    - (UIView *(^)(void))jd_reset;

    /**
    约束布局
    */
    - (void(^)(void))jd_layout;
    - (void(^)(void))jd_reload;

    @end

    @interface UIView (JDAutolayoutExtention)

    /**
     对width和height的封装
     */
    - (UIView *(^)(CGSize size))jd_size;
    - (UIView *(^)(CGRect frame))jd_frame;
    - (UIView *(^)(UIEdgeInsets insets))jd_insets;
    
    /**
    子view等宽、等高
    */
    - (void(^)(NSArray *subViews))jd_equalWidthSubViews;
    - (void(^)(NSArray *subViews))jd_equalHeightSubViews;

    @end

    @interface JDRelation : NSObject

    /**
     倍数
     */
    - (JDRelation *(^)(CGFloat multiplier))jd_multiplier;

    /**
    约束关系
    */
    - (UIView *(^)(CGFloat constant))jd_equal;
    - (UIView *(^)(CGFloat constant))jd_lessThanOrEqual;
    - (UIView *(^)(CGFloat constant))jd_greaterThanOrEqual;

    /**
    连接方法，用于逻辑上连接下一个语句
    */
    - (UIView *(^)(void))jd_and;

    /**
     约束布局
    */
    - (void(^)(void))jd_layout;
    - (void(^)(void))jd_reload;

    @end
    
 ##  六、支持swift调用
     //swift封装的布局类
     self.view1 = UIView.init()
     self.view1.backgroundColor = UIColor.red
     self.view.addSubview(self.view1)
     self.view1.sf_frame(CGRect(x: 50, y: 300, width: 100, height: 100)).sf_layout()
