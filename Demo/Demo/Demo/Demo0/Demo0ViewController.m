//
//  Demo0ViewController.m
//  JDLayout
//
//  Created by JD on 2018/3/8.
//  Copyright © 2018年. All rights reserved.
//

#import "Demo0ViewController.h"
#import "UIView+JDLayout.h"

@interface Demo0ViewController ()

@property (nonatomic, strong) UIButton *view0;
@property (nonatomic, strong) UIButton *view1;
@property (nonatomic, strong) UIButton *view2;
@property (nonatomic, strong) UIButton *view3;
@end

@implementation Demo0ViewController {
    CGFloat _changeValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view0 = [[UIButton alloc] init];
    self.view0.backgroundColor = [UIColor redColor];
    [self.view0 setTitle:@"点我有惊喜" forState:UIControlStateNormal];
    [self.view0 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.view0];
    //下面的remove是无效代码，仅用于测试。
    self.view0.jd_remove();
    self.view0
    .jd_removeLeft().jd_removeTop().jd_removeRight()
    .jd_removeBottom().jd_removeWidth().jd_removeHeight()
    .jd_removeCenterX().jd_removeCenterY().jd_removeAspectRatio();
    
    self.view0.jd_remove()
    .jd_top(self.view).jd_equal(80).jd_and()
    .jd_left(self.view).jd_equal(80).jd_and()
    .jd_width(@(100)).jd_and()
    .jd_height(@(100))
    .jd_layout();
    //简写
    //self.view0.jd_frame(CGRectMake(80, 0, 100, 100)).jd_layout();
    
    self.view1 = [[UIButton alloc] init];
    self.view1.backgroundColor = [UIColor blueColor];
    [self.view1 setTitle:@"点我有惊喜" forState:UIControlStateNormal];
    [self.view1 addTarget:self action:@selector(click0:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.view1];
    //下面2个都对top布局了，但是只有最后一个生效
    self.view1
    .jd_frame(CGRectMake(80, 200, 100, 100)).jd_and()
    .jd_left(self.view0).jd_equal(5).jd_and()
    .jd_layout();
    //改写对top的布局，也是最后一个生效
    self.view1
    .jd_left(self.view0.jd_leftAttribute).jd_equal(0).jd_and()
    .jd_layout();
    
    self.view2 = [[UIButton alloc] init];
    [self.view2 setTitle:@"点我有惊喜" forState:UIControlStateNormal];
    self.view2.backgroundColor = [UIColor redColor];
    [self.view2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.view2];
    self.view2.jd_insets(UIEdgeInsetsMake(350, 80, -100, -100)).jd_layout();
    
    self.view3 = [[UIButton alloc] init];
    [self.view3 setTitle:@"宽高比" forState:UIControlStateNormal];
    self.view3.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.view3];
    self.view3
    .jd_right(self.view).jd_equal(-20).jd_and()
    .jd_top(self.view).jd_equal(100).jd_and()
    .jd_width(@(100)).jd_and()
    .jd_aspectRatio(2)
    .jd_layout();
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(action) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}
    
- (void)action{
    static CGFloat offset;
    if(_changeValue <= 60){//最小宽度
        _changeValue = 60;
        offset = 10;
    }else if(_changeValue >= 200 ){//最大宽度
        _changeValue = 200;
        offset = -10;
    }
    _changeValue = _changeValue + offset;
    self.view3.jd_width(@(_changeValue)).jd_update();
}
  
- (void)click0:(UIView *)sender {
    self.view0
    .jd_top(self.view).jd_equal(200)
    .jd_update();
    [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:0 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.view0
        .jd_top(self.view).jd_equal(80)
        .jd_update();
        [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1 options:0 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }];
}
- (void)click:(UIView *)sender {
    //self.view2.layer.anchorPoint = CGPointMake(0.5,0.5);
    sender
    .jd_left(self.view).jd_equal(200)
    .jd_layout();
    [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:0 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        sender
        .jd_left(self.view).jd_equal(80)
        .jd_layout();
        [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1 options:0 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
