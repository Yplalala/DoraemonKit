//
//  UmeDoraemonMMKVViewController.m
//  Pods
//
//  Created by hyhan on 2020/7/27.
//

#import "UmeDoraemonMMKVViewController.h"
#import <MMKV.h>

@interface UmeDoraemonMMKVViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *keyArray;
@property (nonatomic, strong)  UITableView * tableView;
@end

@implementation UmeDoraemonMMKVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"MMKV";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.tableView];
    
     self.tableView.delegate = self;
     self.tableView.dataSource = self;
    
     self.keyArray = [MMKV defaultMMKV].allKeys;
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MMKVKey"];

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return self.keyArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMKVKey" forIndexPath:indexPath];
  if (self.keyArray.count > indexPath.row) {
      NSString * key = self.keyArray[indexPath.row];
//      cell.textLabel.text = key;
      cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",key,[[MMKV defaultMMKV]getStringForKey:key]?:@"不是字符串类型"];
  }
  
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 70;
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
