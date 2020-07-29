//
//  UmeDoraemonDBViewController.m
//  Pods
//
//  Created by hyhan on 2020/7/27.
//

#import "UmeDoraemonDBViewController.h"
#import "NSObject+Doraemon.h"
#import "DoraemonDefine.h"
#import "FMDatabase.h"
#import "KVDatabase.h"
#import <objc/runtime.h>
 

@interface UmeDoraemonDBViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) KVDatabase   *kvDb;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, assign)BOOL isrunning ;
@property (nonatomic, strong) NSArray *keyArray;
@property (nonatomic, strong)  UITableView * tableView;
@end

@implementation UmeDoraemonDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"数据库异常监控";
    
    NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    dbPath = [dbPath stringByAppendingPathComponent:@"kvdb"];
    BOOL isDirectory = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:dbPath isDirectory:&isDirectory];
    if (!isExist) {
        NSError *error = nil;
        isExist = [[NSFileManager defaultManager] createDirectoryAtPath:dbPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (isExist) {
        // 初始化KV数据库
        NSString *kvPath = [dbPath stringByAppendingPathComponent:@"config.kv"];
        self.kvDb = [KVDatabase dbWithPath:kvPath];
        NSLog(@"%@",kvPath);
    }
    
#if DEBUG
    NSDateFormatter *dateFormart = [[NSDateFormatter alloc]init];
    [dateFormart setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormart.timeZone = [NSTimeZone systemTimeZone];
    NSString *dateString = [dateFormart stringFromDate:[NSDate date]];

  
     dateString = [dateFormart stringFromDate:[NSDate date]];

    [self.kvDb putString:@"Error1 测试" forKey:dateString];
    dateString = [dateFormart stringFromDate:[NSDate date]];

    [self.kvDb putString:@"Error1 测试" forKey:dateString];
    dateString = [dateFormart stringFromDate:[NSDate date]];

    [self.kvDb putString:@"Error1 测试" forKey:dateString];
#endif
    
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _startButton.frame = CGRectMake(15, 100, self.view.doraemon_width - 40, 50);
    _startButton.backgroundColor = [UIColor doraemon_colorWithHex:0x4889db];
    [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startServer) forControlEvents:UIControlEventTouchUpInside];
    _startButton.layer.cornerRadius = 4;
    _startButton.layer.masksToBounds = YES;
    [self.view addSubview:_startButton];
    [_startButton setTitle:@"开启" forState:UIControlStateNormal];
    
     NSArray * resArray = [self.kvDb getAllContents];
 
    self.keyArray = resArray;
    
    CGRect frame = CGRectMake(0, self.startButton.frame.origin.y + self.startButton.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.startButton.frame.origin.y + self.startButton.frame.size.height - 30);
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    [self.view addSubview:self.tableView];

     self.tableView.delegate = self;
     self.tableView.dataSource = self;
 
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MMKVKey"];

     

}


- (void)startServer {
    if (!self.isrunning) {
         self.isrunning = YES;
         [[self class] startRecordDBError];
         [_startButton setTitle:@"服务已开启" forState:UIControlStateNormal];
    }
 
}

+(void)startRecordDBError{
    
      Class cls = NSClassFromString(@"DCDatabase");
      if (cls) {
         [self  safe_instanceSwizzleMethodWithClass:cls
                                            orginalMethod:@selector(recordDBError:)
                                                replaceClass:[self class]
                                               replaceMethod:@selector(ume_recordDBError:)];
      }
   

}

-(void)ume_recordDBError:(FMDatabase *)db{
    if (db.hadError) {
        NSLog(@"ume_recordDBError");
        NSDateFormatter *dateFormart = [[NSDateFormatter alloc]init];
        [dateFormart setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        dateFormart.timeZone = [NSTimeZone systemTimeZone];
        NSString *dateString = [dateFormart stringFromDate:[NSDate date]];
        [self.kvDb putString:db.lastError.localizedDescription forKey:dateString];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



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
      NSDictionary * dict = self.keyArray[indexPath.row];
//      cell.textLabel.text = key;
      cell.textLabel.numberOfLines = 0;
      cell.textLabel.text = [NSString stringWithFormat:@"time:%@ \r\nError:%@",dict[@"wag_key"],dict[@"wag_value"]];
  }
  
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 70;
}
@end
