//
//  HCDataHelper.h
//  SlamBall
//
//  Created by 诺达 on 16/7/27.
//  Copyright © 2016年 诺达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCDataHelper : NSObject

#pragma mark - URLMethods
// 程序目录，不能存任何东西
+(NSString *)appPath;
// 文档目录，需要ITUNES同步备份的数据存这里
+(NSString *)docPath;
// 配置目录，配置文件存这里
+(NSString *)libPrefPath;
// 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+(NSString *)libCachePath;
// 缓存目录，APP退出后，系统可能会删除这里的内容
+(NSString *)tmpPath;

#pragma mark - BaseMethods
//获取某文件夹下的所有文件
+(NSArray*)GetFilesName:(NSString*)path;
//创建文件
+(BOOL)CreateFile:(NSString*)path fileName:(NSString*)filename;
//删除文件
+(BOOL)DeleteFile:(NSString*)path;

#pragma mark - DataMethods
//储存文件
+(BOOL)SaveFileWithName:(NSString *)FileName DataSource:(NSMutableArray *)dataSource;
//获取文件
+(NSMutableArray *)GetFileWithName:(NSString *)FileName;
//储存字典到指定的文件中
+(BOOL)DataSaveDictWith:(NSMutableDictionary *)dictSave fileName:(NSString *)fileName;
//将字典从指定的文件中删除
+(BOOL)DataDeleteDictWithKey:(NSString *)key  KeyValue:(NSString *)keyValue fileName:(NSString *)fileName;
//获取指定键值对的对象
+(NSMutableDictionary *)DataGetDictWithKey:(NSString *)key KeyValue:(NSString *)keyValue fileName:(NSString *)fileName;

#pragma mark - NetWorkDataHelper
+ (void)saveResponseDic:(NSDictionary *)dic withFileName:(NSString *)fileName hostName:(NSString *)hostName;

@end
