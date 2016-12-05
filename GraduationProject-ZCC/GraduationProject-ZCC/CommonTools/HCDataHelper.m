//
//  HCDataHelper.m
//  SlamBall
//
//  Created by 诺达 on 16/7/27.
//  Copyright © 2016年 诺达. All rights reserved.
//

#import "HCDataHelper.h"

@implementation HCDataHelper
// 程序目录，不能存任何东西
+ (NSString *)appPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

// 文档目录，需要ITUNES同步备份的数据存这里
+ (NSString *)docPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

// 配置目录，配置文件存这里
+ (NSString *)libPrefPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
}

// 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)libCachePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

// 缓存目录，APP退出后，系统可能会删除这里的内容
+ (NSString *)tmpPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/tmp"];
}
#pragma mark - BaseMethods
//获取某文件夹下的所有文件
+(NSArray *)GetFilesName:(NSString *)path{

    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray *arrayfiles = [fileManager subpathsAtPath:path];
    return arrayfiles;
}
//创建文件
+(BOOL)CreateFile:(NSString *)path fileName:(NSString *)filename{

    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //进入待操作目录
    [fileManager changeCurrentDirectoryPath:[path stringByExpandingTildeInPath]];
    //创建文件filename文件名称, contents文件的内容,若没有内容可以设置为nil,attributes文件的属性,初始化为nil
    [fileManager createFileAtPath:filename contents:nil attributes:nil];
    return YES;
}
//删除文件
+(BOOL)DeleteFile:(NSString*)path {
    @try {
        //创建文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //更改到待操作的目录下
        [fileManager changeCurrentDirectoryPath:[path stringByExpandingTildeInPath]];
        //删除
        [fileManager removeItemAtPath:path error:nil];
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
        
    }
    return YES;
}

#pragma mark - DataMethods - Default Path To NSDocumentDirectory
//储存文件
+(BOOL)SaveFileWithName:(NSString *)FileName DataSource:(NSMutableArray *)dataSource {
    //获取文件路径
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    if ([arrayPath count] <= 0) {
        return YES;
    }
    NSString *stringPath = [arrayPath objectAtIndex:0];
    NSString *stringFile=[stringPath stringByAppendingPathComponent:FileName];
    
    //储存
    if ([dataSource writeToFile:stringFile atomically:YES]) {
        return YES;
    }else {
        return NO;
    }
}

//获取文件
+(NSMutableArray *)GetFileWithName:(NSString *)FileName {
    //获取文件路径
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    if ([arrayPath count] <= 0) {
        return nil;
    }
    NSString *stringPath = [arrayPath objectAtIndex:0];
    NSString *stringFile=[stringPath stringByAppendingPathComponent:FileName];
    
    //获取文件
    NSMutableArray *arraySource = [[NSMutableArray alloc] initWithContentsOfFile:stringFile];
    return arraySource;
}

//储存字典到指定的文件中
+(BOOL)DataSaveDictWith:(NSMutableDictionary *)dictSave fileName:(NSString *)fileName {
    NSMutableArray *arraySource = [HCDataHelper GetFileWithName:fileName];
    if (arraySource == nil) {
        arraySource = [[NSMutableArray alloc] init];
    }
    if (![arraySource containsObject:dictSave]) {
        [arraySource addObject:dictSave];
    }else {
        return NO;
    }
    [HCDataHelper SaveFileWithName:fileName DataSource:arraySource];
    return YES;
}
//将字典从指定的文件中删除
+(BOOL)DataDeleteDictWithKey:(NSString *)key  KeyValue:(NSString *)keyValue fileName:(NSString *)fileName {
    NSMutableArray *arraySource = [HCDataHelper GetFileWithName:fileName];
    if (arraySource == nil) {
        arraySource = [[NSMutableArray alloc] init];
    }
    for (NSMutableDictionary *dictSub in arraySource) {
        if ([[dictSub objectForKey:key] isEqualToString:keyValue]) {
            [arraySource removeObject:dictSub];
            break;
        }
    }
    [HCDataHelper SaveFileWithName:fileName DataSource:arraySource];
    return YES;
}

//获取指定键值对的对象
+(NSMutableDictionary *)DataGetDictWithKey:(NSString *)key KeyValue:(NSString *)keyValue fileName:(NSString *)fileName {
    NSMutableArray *arraySource = [HCDataHelper GetFileWithName:fileName];
    if (arraySource == nil) {
        arraySource = [[NSMutableArray alloc] init];
    }
    for (NSMutableDictionary *dictSub in arraySource) {
        if ([[dictSub objectForKey:key] isEqualToString:keyValue]) {
            return dictSub;
        }
    }
    return nil;
}



@end
