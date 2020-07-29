//
//  LXDZombieSniffer.h
//  LXDZombieSniffer
//
//  Created by linxinda on 2017/10/28.
//

#import <Foundation/Foundation.h>

/*!
 *  @category   LXDZombieSniffer
 *  zombie对象嗅探器
 */
@interface LXDZombieSniffer : NSObject


/*!
 *  @method installSniffer
 *  启动zombie检测
 */
+ (void)installSniffer;

/*!
 *  @method uninstallSnifier
 *  停止zombie检测
 */
+ (void)uninstallSnifier;

/*!
 *  @method appendIgnoreClass
 *  添加白名单类
 */
+ (void)appendIgnoreClass: (Class)cls;


/*!
*  @method isRunning
*  是否已启动zombie检测
*/
+ (BOOL)isRunning;

/*!
*  @method saveInfoLocial
*  是否捕获的信息保存到本地
*/
+ (BOOL)saveInfoLocial;
/*!
*  @method saveInfoLocial
*  设置是否把捕获的信息保存到本地
*/
+ (void)saveInfoLocial:(BOOL)status;
/*!
*  @method lastZombieInfo
*  查看上次的zombie信息
*/
+ (NSString *)lastZombieInfo;

@end
