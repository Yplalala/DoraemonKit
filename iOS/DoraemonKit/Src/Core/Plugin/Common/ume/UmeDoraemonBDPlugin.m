//
//  UmeDoraemonBDPlugin.m
//  Pods
//
//  Created by hyhan on 2020/7/27.
//

#import "UmeDoraemonBDPlugin.h"
#import "UmeDoraemonDBViewController.h"
#import "DoraemonHomeWindow.h"

@implementation UmeDoraemonBDPlugin


- (void)pluginDidLoad{
    UmeDoraemonDBViewController *vc = [[UmeDoraemonDBViewController alloc] init];
    [DoraemonHomeWindow openPlugin:vc];
}

@end
