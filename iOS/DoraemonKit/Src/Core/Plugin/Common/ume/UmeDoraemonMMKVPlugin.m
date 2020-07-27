//
//  UmeDoraemonMMKVPlugin.m
//  Pods
//
//  Created by hyhan on 2020/7/27.
//

#import "UmeDoraemonMMKVPlugin.h"
#import "DoraemonHomeWindow.h"
#import "UmeDoraemonMMKVViewController.h"

@implementation UmeDoraemonMMKVPlugin

- (void)pluginDidLoad{
    UmeDoraemonMMKVViewController *vc = [[UmeDoraemonMMKVViewController alloc] init];
    [DoraemonHomeWindow openPlugin:vc];
}


@end
