//
//  GetIBViewCell.m
//  CodeAutoMaker
//
//  Created by bear on 15/11/15.
//  Copyright © 2015年 bear. All rights reserved.
//

#import "GetSBCellModel.h"


@implementation GetSBCellModel
- (NSMutableArray *)dataArr{
	if (!_dataArr) {
		_dataArr=[NSMutableArray array];
	}
	return _dataArr;
}
- (void)setAutoWidthText:(NSString *)autoWidthText{
	_autoWidthText=autoWidthText;
	self.width=[autoWidthText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.width;
}

@end
