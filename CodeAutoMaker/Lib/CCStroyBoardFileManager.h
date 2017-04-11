//
//  CodeAutoMaker
//     ʕ•͡●̫•ʔ ~♪
//  Created by bear
//  url: https://github.com/xiongcaichang/CodeAutoMaker
//  Copyright © 2015年 bear. All rights reserved.
//
#import <Foundation/Foundation.h>

/**这个类用于创建文件*/

@interface CCStroyBoardFileManager : NSObject
+ (NSMutableDictionary *)defalutFileDicM;
+ (NSMutableDictionary *)defalutContextDicM;
+ (NSString *)getCurDateString;
+ (void)creatFileDirectory;
+ (void)done;
+ (void)creat_MVC_WithViewControllerName:(NSString *)ViewController;
+ (void)creat_V_WithViewName_XIB:(NSString *)View;

+ (NSMutableString *)get_H_ContextByIdentity:(NSString *)identity;

+ (NSMutableString *)get_M_ContextByIdentity:(NSString *)identity;

+ (void)creat_m_h_file:(NSString *)fileName isModel:(BOOL)isModel isView:(BOOL)isView isController:(BOOL)isController isTableView:(BOOL)isTableView isCollectionView:(BOOL)isCollectionView forViewController:(NSString *)viewController;
+ (void)creat_m_h_file_XIB:(NSString *)fileName forView:(NSString *)view;

+ (NSString *)getAdapterTableViewCellName:(NSString *)name;
+ (NSString *)getAdapterTableViewCellModelName:(NSString *)name;

+ (NSString *)getAdapterCollectionViewCellName:(NSString *)name;
+ (NSString *)getAdapterCollectionViewCellModelName:(NSString *)name;

+ (NSString *)getAdapterCollectionViewCellAndTableViewCellName:(NSString *)name;
+ (NSString *)getAdapterCollectionViewCellAndTableViewCellNameForPureHandProject:(NSString *)name;
@end