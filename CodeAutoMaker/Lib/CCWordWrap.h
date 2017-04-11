//
//  CodeAutoMaker
//     ʕ•͡●̫•ʔ ~♪
//  Created by bear
//  url: https://github.com/xiongcaichang/CodeAutoMaker
//  Copyright © 2015年 bear. All rights reserved.
//
#import "CreatFatherFile.h"

/*这个类的作用是,类似于XCode全选代码,control+i自动帮你排版*/


@interface CCWordWrap : CreatFatherFile

/**把你要排版的文件或工程进行排版*/
- (void)wordWrap:(NSString *)path;

/**把你要排版的代码进行排版*/
- (NSString *)wordWrapText:(NSString *)text;
@end