//
//  UmeDoraemonNUllPointerViewController.m
//  Pods
//
//  Created by hyhan on 2020/7/27.
//

#import "UmeDoraemonNUllPointerViewController.h"
#import "DoraemonDefine.h"
#import "DebugDatabaseManager.h"

#import "LXDZombieSniffer.h"


@interface UmeDoraemonNUllPointerViewController ()

@property (nonatomic ,strong) UIButton * startButton;
@property (nonatomic, strong) UILabel *tipLabel;


@end

@implementation UmeDoraemonNUllPointerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"野指针";
    
    
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _startButton.frame = CGRectMake(15, self.bigTitleView.doraemon_bottom + 50, self.view.doraemon_width - 40, 50);
    _startButton.backgroundColor = [UIColor doraemon_colorWithHex:0x4889db];
    [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startServer:) forControlEvents:UIControlEventTouchUpInside];
    _startButton.layer.cornerRadius = 4;
    _startButton.layer.masksToBounds = YES;
    [_startButton setTitle:DoraemonLocalizedString(@"开启服务") forState:UIControlStateNormal];
    [_startButton setTitle:DoraemonLocalizedString(@"关闭服务") forState:UIControlStateSelected];
    _startButton.selected = [LXDZombieSniffer isRunning];
    [self.view addSubview:_startButton];
    
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(_startButton.doraemon_left, _startButton.doraemon_bottom + 40, _startButton.doraemon_width, 150)];
    _tipLabel.textColor = [UIColor doraemon_colorWithHex:0x808080];
    _tipLabel.numberOfLines = 0;
    
    [self.view addSubview:_tipLabel];
    [self showNotice];
}

- (void)startServer:(UIButton *)button
{
    button.selected = !button.isSelected;
    if (button.selected) {
        if (![LXDZombieSniffer isRunning]) {
            [LXDZombieSniffer installSniffer];
        }
    }else{
        if ([LXDZombieSniffer isRunning]) {
            [LXDZombieSniffer uninstallSnifier];
        }
    }
    
    [self showNotice];
}

- (void)showNotice{
    NSString *tips = @"";
    if ([LXDZombieSniffer isRunning]) {
        NSString * lastInfo = [LXDZombieSniffer lastZombieInfo];
        NSString * showZombieInfo = @"";
        if (lastInfo.length > 0) {
            showZombieInfo = [NSString stringWithFormat:@"上次zombie信息:%@",lastInfo];
        }
        tips = [NSString stringWithFormat:@"%@：\n\n%@\n\n%@", DoraemonLocalizedString(@"温馨提示"), DoraemonLocalizedString(@"服务已开启"), showZombieInfo];
    }else {
        tips = [NSString stringWithFormat:@"%@：\n\n%@！\n%@\n", DoraemonLocalizedString(@"温馨提示"), DoraemonLocalizedString(@"服务已关闭"), DoraemonLocalizedString(@"")];
    }
    _tipLabel.text = tips;
}




- (BOOL)needBigTitleView{
    return YES;
}


@end
