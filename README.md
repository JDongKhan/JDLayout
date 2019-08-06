# JDAutoLayout
超简易的约束布局

![demo png](https://github.com/JDongKhan/JDLayout/blob/master/demo.gif "demo")

## 跟其他约束库对比有以下几点优势

### 一、更容易更新现有的约束

```objc

    可以简单的更新xib里面的约束，也可以更新其他途径增加的约束，而不需要xib拉一根约束线或者代码持有约束属性！
    
    self.button2.jd_left(self.button1).jd_equal(100).jd_update();

```

### 二、提供垂直平分 、水平平分等简易方法

```objc

    //垂直等高
    self.view1.jd_equalHeightSubViews(@[label1,label2]);
    
    //水平等宽
    self.view2.jd_equalWidthSubViews(@[label1,label21]);
    
    //还有对父View简易使用
    self.view2.jd_leftToSuperView().jd_equal(10).jd_layout();
    
    //对frame、insets、size的封装
    self.view2.jd_insets(UIEdgeInsetsZero).jd_equal(10).jd_layout();
    
```

###  三、支持OC、swift调用，减少项目中约束库（比如Masonry、SnapKit）的引用

```objc

     //swift封装的布局类
     self.view1 = UIView.init()
     
     self.view1.backgroundColor = UIColor.red
     
     self.view.addSubview(self.view1)
     
     self.view1.jd_frame(CGRect(x: 50, y: 300, width: 100, height: 100)).jd_layout()
     
```
     
###  四、链式调用

   可以用链式的方式一直调用下去！！！
   
### 五、布局可以分步实现
   比如先初始化的时候布局左右以及高，等网络请求完在布局top！！！
    

## cocoapods使用

    pod 'JDAutoLayout', '~> 1.1.7'
    
