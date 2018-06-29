# JDAutoLayout
超简易的约束布局

![demo png](https://github.com/wangjindong/JDLayout/blob/master/demo.gif "demo")

## cocoapods使用

    pod 'JDAutoLayout', '~> 1.1.7'
    
# 跟其他约束库对比有以下几点优势

## 一、更容易更新现有的约束

    可以简单的更新xib里面的约束，也可以更新其他途径增加的约束，而不需要xib拉一根约束线或者代码持有约束属性！
    
    self.button2.jd_left(self.button1).jd_equal(100).jd_update();

## 二、提供垂直平分 、水平平分等简易方法
    //垂直等高
    self.view1.jd_equalHeightSubViews(@[label1,label2]);
    //水平等宽
    self.view2.jd_equalWidthSubViews(@[label1,label21]);
    //还有对父View简易使用
    self.view2.jd_leftToSuperView().jd_equal(10).jd_layout();
    //对frame、insets、size的封装
    self.view2.jd_insets(UIEdgeInsetsZero).jd_equal(10).jd_layout();

##  三、支持OC、swift调用，减少项目中约束库的引用
     //swift封装的布局类
     self.view1 = UIView.init()
     self.view1.backgroundColor = UIColor.red
     self.view.addSubview(self.view1)
     self.view1.sf_frame(CGRect(x: 50, y: 300, width: 100, height: 100)).sf_layout()
     
##  四、链式调用

   可以用链式的方式一致调用下去！！！

     
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
    

