//
//  CodeAutoMaker
//     ʕ•͡●̫•ʔ ~♪
//  Created by bear
//  url: https://github.com/xiongcaichang/CodeAutoMaker
//  Copyright © 2015年 bear. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FMDatabase.h"

//如果你要换一个名字
static NSString *DataBaseName=@"CCJSONData.rdb";//(数据库名字)
static NSString *TableName=@"CCJSON";//(表格名字)
static NSString *TableNameBLOB=@"CCJSONBLOB";//(这个不能改)
static FMDatabase *dataBase;
@interface CCSaveDataToFMDB : UIView

#pragma mark ----------保存数据(方法一)
/**保存缓存数据:(字典,数组,JSon字符串) 其中中间过程会产生一个临时的文件(速度稍慢)*/
+ (void)saveDataHasTempFileWithData:(id)data WithIdentity:(NSString *)identity;
/**保存缓存数据:(网址) 其中中间过程会产生一个临时的文件(速度稍慢)*/
+ (void)saveDataHasTempFileWithURL:(NSString *)URL WithIdentity:(NSString *)identity;

#pragma mark ----------保存数据(方法二)
/**保存缓存数据:(字典,数组,JSon字符串) 其中中间过程不会产生一个临时的文件(速度较快)*/
+ (void)insertDataWithData:(id)data WithIdentity:(NSString *)identity;
/**保存缓存数据:(网址) 其中中间过程不会产生一个临时的文件(速度较快)*/
+ (void)insertDataWithURL:(NSString *)URL WithIdentity:(NSString *)identity;


#pragma mark ----------读取数据(方法一)
/**将读取出来的数据直接赋值给模型(中间会产生一个临时的文件)*/
+ (BOOL)readDataWithIdentity:(NSString *)identity toModel:(id)model;
/**将读取出来的数据直接赋值给模型(中间不会产生一个临时的文件)*/
+ (BOOL)selectDataWithIdentity:(NSString *)identity toModel:(id)model;

#pragma mark ----------读取数据(方法二)
/**读取数据出来(中间会产生一个临时的文件)*/
+ (id)readDataWithIdentity:(NSString *)identity;
/**读取数据出来(中间不会产生一个临时的文件)*/
+ (id)selectDataWithIdentity:(NSString *)identity;


#pragma mark ----------测试获取的目标数据是哪张类型
/**测试获取的目标数据是哪张类型(中间会产生一个临时的文件)*/
+ (void)testTypeOfDataWithIdentity:(NSString *)identity;
/**测试获取的目标数据是哪张类型(中间不会产生一个临时的文件)*/
+ (void)testTypeOfBLOBDataWithIdentity:(NSString *)identity;

#pragma mark ----------清除所有缓存
+ (void)cleanAllData;
@end
