//
//  NSObject+Doraemon.h
//  AFNetworking
//
//  Created by yixiang on 2018/7/2.
//

#import <Foundation/Foundation.h>

@interface NSObject (Doraemon)

/**
 swizzle 类方法
 
 @param oriSel 原有的方法
 @param swiSel swizzle的方法
 */
+ (void)doraemon_swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;

/**
 swizzle 实例方法
 
 @param oriSel 原有的方法
 @param swiSel swizzle的方法
 */
+ (void)doraemon_swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;


+ (void)safe_instanceSwizzleMethodWithClass:(Class _Nonnull )klass
orginalMethod:(SEL _Nonnull )originalSelector
 replaceClass:(Class _Nonnull )rlass
                              replaceMethod:(SEL _Nonnull )replaceSelector;

@end
