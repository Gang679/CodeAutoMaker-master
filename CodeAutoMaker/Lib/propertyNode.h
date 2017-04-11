//
//  CodeAutoMaker
//     ʕ•͡●̫•ʔ ~♪
//  Created by bear
//  url: https://github.com/xiongcaichang/CodeAutoMaker
//  Copyright © 2015年 bear. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface propertyNode : NSObject
@property (nonatomic,copy)NSString *key;
@property (nonatomic,copy)NSString *value;
@property (nonatomic,strong) propertyNode *next;
@end