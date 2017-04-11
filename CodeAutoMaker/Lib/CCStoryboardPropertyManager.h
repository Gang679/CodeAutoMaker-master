//
//  CodeAutoMaker
//     ʕ•͡●̫•ʔ ~♪
//  Created by bear
//  url: https://github.com/xiongcaichang/CodeAutoMaker
//  Copyright © 2015年 bear. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ReadXML.h"

@interface CCStoryboardPropertyManager : NSObject
/**为获取每个view的property属性*/
+ (NSDictionary *)getPropertysForView:(NSDictionary *)idAndViewDic withCustomAndName:(NSDictionary *)customAndNameDic andXMLHandel:(ReadXML *)xml;

/**根据property属性生成代码*/
+ (void)getCodePropertysForViewName:(NSString *)viewName WithidAndViewDic:(NSDictionary *)idAndViewDic withCustomAndName:(NSDictionary *)customAndNameDic withProperty:(ViewProperty *)property toCodeText:(NSMutableString *)codeText;

/**如果没有添加约束,就按照默认frame设置约束*/
+ (NSString *)getConstraintIfNotGiveConstraintsForViewName:(NSString *)viewName withProperty:(ViewProperty *)property withFatherView:(NSString *)fatherView;

/**获取事件代码*/
+ (NSString *)getSelectorEventTypeForViewName:(NSString *)viewName withProperty:(ViewProperty *)property;
@end