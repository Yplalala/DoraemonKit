//
//  KVDatabase.m
//
//
//  Created by rui on 2017/5/9.
//  Copyright © 2017年  . All rights reserved.
//

#import "KVDatabase.h"
#import <FMDB/FMDB.h>

@interface KVDatabase ()
@property(nonatomic, strong) FMDatabaseQueue *dbQueue;
@end

@implementation KVDatabase


+ (instancetype)dbWithPath:(NSString *)filePath
{
    KVDatabase *kv = [KVDatabase new];
    kv.dbQueue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    [kv setupDatabase];
    return kv;
}

- (void)setupDatabase
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS KVConfig( wag_category integer not null default 0, wag_key varchar(255) not null, wag_value text );"
                      "CREATE UNIQUE INDEX IF NOT EXISTS index_category_key on KVConfig (wag_category,wag_key);";

    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeStatements:sql];
    }];
}

- (BOOL)putInteger:(long long)data forKey:(NSString *)key {
    return [self putInteger:data forKey:key toCategory:0];
}

- (long long)getIntegerWithKey:(NSString *)key {
    return [self getIntegerWithKey:key fromCategory:0];
}

- (BOOL)putString:(NSString *)data forKey:(NSString *)key
{
    return [self putString:data forKey:key toCategory:0];
}

- (NSString *)getStringWithKey:(NSString *)key
{
    return [self getStringWithKey:key fromCategory:0];
}

- (BOOL)putDictionary:(NSDictionary *)data forKey:(NSString *)key
{
    return [self putObject:data forKey:key toCategory:0];
}

- (NSDictionary *)getDictionaryWithKey:(NSString *)key
{
    return [self getObjectWithKey:key fromCategory:0];
}

- (BOOL)putArray:(NSArray *)data forKey:(NSString *)key
{
    return [self putObject:data forKey:key toCategory:0];
}

- (NSArray *)getArrayWithKey:(NSString *)key
{
    return [self getObjectWithKey:key fromCategory:0];
}


#pragma mark - kv with category

- (BOOL)putInteger:(long long)data forKey:(NSString *)key toCategory:(int)category {
    return [self putString:@(data).stringValue forKey:key toCategory:category];
}

- (long long)getIntegerWithKey:(NSString *)key fromCategory:(int)category {
    NSString *dataString = [self getStringWithKey:key fromCategory:category];
    return [dataString longLongValue];
}

- (BOOL)putString:(NSString *)data forKey:(NSString *)key toCategory:(int)category
{
    NSString *sql = @"INSERT OR REPLACE INTO KVConfig (wag_category, wag_key, wag_value) VALUES (?, ?, ?)";
    __block BOOL success = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:sql,@(category),key?:@"",data?:@""];
        if (!success) {
            NSLog(@"putString error = %@", [db lastErrorMessage]);
        }
    }];
    return success;
}

- (NSString *)getStringWithKey:(NSString *)key fromCategory:(int)category
{
    __block NSString *ret = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from KVConfig where wag_category = ? and wag_key = ?",@(category),key?:@""];
        if([rs next]) {
            ret = [rs stringForColumn:@"wag_value"];
        }
        [rs close];
    }];
    return ret;
}

- (NSArray *)getAllContents{
  NSArray * dict = [self getAllContentFromCategory:0];
   return  dict;
 
}


- (NSArray *)getAllContentFromCategory:(int)category
{
    __block NSArray *ret = nil;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"select * from KVConfig where wag_category = ?",@(category) ];
       
        
        NSEnumerator *columnNames = [result.columnNameToIndexMap keyEnumerator];
        
        NSString *tempColumnName = @"";
        
        NSMutableArray *columnNameArray = [[NSMutableArray alloc] init];
        while ((tempColumnName = [columnNames nextObject]))
        {
            [columnNameArray addObject:tempColumnName];
        }
        
        NSError *log_error = [db lastError];
        if ( 0 != log_error.code ) {
             return;
        }
        NSMutableArray * resultArray = [NSMutableArray array];
        
        while ([result next]) {       //retrieve values for each record
            NSMutableDictionary * resultDic = [NSMutableDictionary dictionary];
            for (NSString * colName in columnNameArray) {
                id  resObj = [result objectForColumnName:colName];
                if (resObj) {
                    resultDic[colName] = resObj;
                }
            }
            [resultArray addObject:resultDic];
        }

       [result close];
        ret = resultArray.copy;
        
    }];
    return ret;
}

- (BOOL)putDictionary:(NSDictionary *)data forKey:(NSString *)key toCategory:(int)category
{
    return [self putObject:data forKey:key toCategory:category];
}

- (NSDictionary *)getDictionaryWithKey:(NSString *)key fromCategory:(int)category
{
    return [self getObjectWithKey:key fromCategory:category];
}

- (BOOL)putArray:(NSArray *)data forKey:(NSString *)key toCategory:(int)category
{
    return [self putObject:data forKey:key toCategory:category];
}

- (NSArray *)getArrayWithKey:(NSString *)key fromCategory:(int)category
{
    return [self getObjectWithKey:key fromCategory:category];
}

- (BOOL)putObject:(id)data forKey:(NSString *)key toCategory:(int)category
{
    NSString *value = nil;
    if ([NSJSONSerialization isValidJSONObject:data]) {
        NSError *error = nil;
        value = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:data options:0 error:&error] encoding:NSUTF8StringEncoding];
        if (error) {
            NSLog(@"error == %@",error.description);
        }
    }

    return [self putString:value forKey:key toCategory:category];
}

- (id)getObjectWithKey:(NSString *)key fromCategory:(int)category
{
    NSString *value = [self getStringWithKey:key fromCategory:category];
    id ret = nil;
    if (value.length > 0) {
        NSError *error = nil;
        ret = [NSJSONSerialization JSONObjectWithData:[value dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"error == %@",error.description);
        }
    }
    return ret;
}


- (void)dealloc
{
    [self.dbQueue close];
}

@end
