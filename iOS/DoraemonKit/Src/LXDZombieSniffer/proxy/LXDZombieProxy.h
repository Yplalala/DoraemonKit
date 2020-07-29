//
//  LXDZombieProxy.h
//  LXDZombieSniffer
//
//  Created by linxinda on 2017/10/28.
//

#import <Foundation/Foundation.h>
static const NSString * ZombieStatusNotLog = @"ZombieStatusNotLog";
static const NSString * ZombieInfo   = @"ZombieInfo";

/*!
 *  @class  LXDZombieProxy
 *  zombie对象类
 */
@interface LXDZombieProxy : NSProxy

@property (nonatomic, assign) Class originClass;


@end
