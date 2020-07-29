//
//  KVDatabase.h
//
//
//  Created by   on 2017/5/9.
//  Copyright © 2017年  . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVDatabase : NSObject

+ (instancetype)dbWithPath:(NSString *)filePath;

- (BOOL)putInteger:(long long)data forKey:(NSString *)key;

- (long long)getIntegerWithKey:(NSString *)key;

- (BOOL)putString:(NSString *)data forKey:(NSString *)key;

- (NSString *)getStringWithKey:(NSString *)key;

- (BOOL)putDictionary:(NSDictionary *)data forKey:(NSString *)key;

- (NSDictionary *)getDictionaryWithKey:(NSString *)key;

- (BOOL)putArray:(NSArray *)data forKey:(NSString *)key;

- (NSArray *)getArrayWithKey:(NSString *)key;


- (BOOL)putInteger:(long long)data forKey:(NSString *)key toCategory:(int)category;

- (long long)getIntegerWithKey:(NSString *)key fromCategory:(int)category;

- (BOOL)putString:(NSString *)data forKey:(NSString *)key toCategory:(int)category;

- (NSString *)getStringWithKey:(NSString *)key fromCategory:(int)category;

- (BOOL)putDictionary:(NSDictionary *)data forKey:(NSString *)key toCategory:(int)category;

- (NSDictionary *)getDictionaryWithKey:(NSString *)key fromCategory:(int)category;

- (BOOL)putArray:(NSArray *)data forKey:(NSString *)key toCategory:(int)category;

- (NSArray *)getArrayWithKey:(NSString *)key fromCategory:(int)category;


- (NSArray *)getAllContents;

@end
