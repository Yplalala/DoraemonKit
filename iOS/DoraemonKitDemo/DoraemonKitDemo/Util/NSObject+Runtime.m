//
//  NSObject+Runtime.m
//  DoraemonKitDemo
//
//  Created by yixiang on 2018/1/30.
//  Copyright © 2018年 yixiang. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>

@implementation NSObject (Runtime)

+ (void)swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Class cls = object_getClass(self);
    
    Method originAddObserverMethod = class_getClassMethod(cls, oriSel);
    Method swizzledAddObserverMethod = class_getClassMethod(cls, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originAddObserverMethod swizzledSel:swiSel swizzledMethod:swizzledAddObserverMethod class:cls];
}

+ (void)swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Method originAddObserverMethod = class_getInstanceMethod(self, oriSel);
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originAddObserverMethod swizzledSel:swiSel swizzledMethod:swizzledAddObserverMethod class:self];
}

+ (void)swizzleMethodWithOriginSel:(SEL)oriSel
                         oriMethod:(Method)oriMethod
                       swizzledSel:(SEL)swizzledSel
                    swizzledMethod:(Method)swizzledMethod
                             class:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}


+ (void)safe_instanceSwizzleMethodWithClass:(Class _Nonnull )klass
                              orginalMethod:(SEL _Nonnull )originalSelector
                               replaceClass:(Class _Nonnull )rlass
                              replaceMethod:(SEL _Nonnull )replaceSelector {
  
  Method origMethod = class_getInstanceMethod(klass, originalSelector);
  Method replaceMeathod = class_getInstanceMethod(rlass, replaceSelector);
  
  // class_addMethod:如果发现方法已经存在，会失败返回，也可以用来做检查用,我们这里是为了避免源方法没有实现的情况;如果方法没有存在,我们则先尝试添加被替换的方法的实现
  BOOL didAddMethod = class_addMethod(klass,
                                      originalSelector,
                                      method_getImplementation(replaceMeathod),
                                      method_getTypeEncoding(replaceMeathod));
  if (didAddMethod) {
    // 原方法未实现，则替换原方法防止crash
    class_replaceMethod(klass,
                        replaceSelector,
                        method_getImplementation(origMethod),
                        method_getTypeEncoding(origMethod));
  }else {
    // 添加失败：说明源方法已经有实现，直接将两个方法的实现交换即
    method_exchangeImplementations(origMethod, replaceMeathod);
  }
}

@end
