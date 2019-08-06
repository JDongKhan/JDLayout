//
//  ViewController.m
//  JDLayout
//
//  Created by JD on 2018/1/23.
//  Copyright © 2018年 . All rights reserved.
//


#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *itemsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    //    [self.tableView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    //    [self.tableView setContentCompressionResistancePriority: UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    self.itemsArray = [NSMutableArray array];
    [self.itemsArray addObject:@{
                                 @"title" : @"纯代码布局",
                                 @"VC" : @"Demo0ViewController"
                                 }];
    [self.itemsArray addObject:@{
                                 @"title" : @"配合xib",
                                 @"VC" : @"SPTConstraintViewController"
                                 }];
    [self.itemsArray addObject:@{
                                 @"title" : @"swift",
                                 @"VC" : @"Demo.Demo2ViewController"
                                 }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }
    NSDictionary *dataInfo = self.itemsArray[indexPath.row];
    cell.textLabel.text = dataInfo[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataInfo = self.itemsArray[indexPath.row];
    Class vcClass = NSClassFromString(dataInfo[@"VC"]);
    UIViewController *vc = [[vcClass alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
