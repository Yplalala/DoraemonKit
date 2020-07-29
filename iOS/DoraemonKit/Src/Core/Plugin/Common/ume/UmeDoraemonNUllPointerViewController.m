//
//  UmeDoraemonNUllPointerViewController.m
//  Pods
//
//  Created by hyhan on 2020/7/27.
//

#import "UmeDoraemonNUllPointerViewController.h"
#import "LXDZombieSniffer.h"

@interface UmeDoraemonNUllPointerViewController ()

@end

@implementation UmeDoraemonNUllPointerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"野指针";
    
    UILabel * nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(0, 0, 160, 30);
    nameLabel.center = CGPointMake(self.view.frame.size.width/2, 120);
    nameLabel.text = @"LXDZombieSniffer";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];

    UIButton * startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setBackgroundColor:[UIColor lightGrayColor]];
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(beginAction:) forControlEvents:UIControlEventTouchUpInside];
    startBtn.frame = CGRectMake(50, 160, 50, 44);
    [self.view addSubview:startBtn];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundColor:[UIColor lightGrayColor]];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 160, 50, 44);
    [self.view addSubview:closeBtn];
    
}

- (void)beginAction:(UIButton *)button{
    [LXDZombieSniffer installSniffer];
}

- (void)closeAction:(UIButton *)button{
    [LXDZombieSniffer uninstallSnifier];
}
@end
