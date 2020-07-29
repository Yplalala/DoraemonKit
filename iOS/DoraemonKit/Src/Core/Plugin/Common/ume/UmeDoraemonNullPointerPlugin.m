//
//  UmeDoraemonNullPointerPlugin.m
//  Pods
//
//  Created by hyhan on 2020/7/27.
//

#import "UmeDoraemonNullPointerPlugin.h"
#import "DoraemonHomeWindow.h"
#import "UmeDoraemonNUllPointerViewController.h"

@implementation UmeDoraemonNullPointerPlugin


- (void)pluginDidLoad{
    UmeDoraemonNUllPointerViewController *vc = [[UmeDoraemonNUllPointerViewController alloc] init];
    [DoraemonHomeWindow openPlugin:vc];
}

@end
