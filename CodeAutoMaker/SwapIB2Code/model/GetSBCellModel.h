//
//  GetIBViewCell.h
//  CodeAutoMaker
//
//  Created by bear on 15/11/15.
//  Copyright © 2015年 bear. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface GetSBCellModel : NSObject
@property (nonatomic,copy)NSString *iconImageName;
@property (nonatomic,assign)BOOL isSelect;
@property (nonatomic,assign)BOOL noFile;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *filePath;
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,copy)NSString *autoWidthText;
@property (nonatomic,strong)NSMutableArray *dataArr;
@end
