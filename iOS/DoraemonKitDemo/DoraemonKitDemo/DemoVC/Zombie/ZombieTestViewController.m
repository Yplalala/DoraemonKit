//
//  ZombieTestViewController.m
//  DoraemonKitDemo
//
//  Created by  on 2020/7/29.
//  Copyright © 2020 yixiang. All rights reserved.
//

#import "ZombieTestViewController.h"

@interface ZombieTestViewController ()

@property (nonatomic, assign) id assignObj;

@end

@implementation ZombieTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    id obj = [UIImageView new];
    self.assignObj = obj;

    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 200, 50, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(zombieAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)zombieAction{
    
    NSLog(@"%@", self.assignObj);
}

@end
