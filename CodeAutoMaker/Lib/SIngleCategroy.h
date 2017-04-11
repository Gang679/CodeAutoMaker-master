//
//  CodeAutoMaker
//     ʕ•͡●̫•ʔ ~♪
//  Created by bear
//  url: https://github.com/xiongcaichang/CodeAutoMaker
//  Copyright © 2015年 bear. All rights reserved.
//
#import <Foundation/Foundation.h>
static NSMutableDictionary *ZHSIngleCategroy;
@interface SIngleCategroy : NSObject
+ (NSMutableDictionary *)defaultSIngleCategroy;
+ (void)setValueWithIdentity:(NSString *)Identity withValue:(NSString *)value;
+ (NSString *)getValueWithIdentity:(NSString *)Identity;
@end