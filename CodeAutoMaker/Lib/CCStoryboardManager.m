//
//  CodeAutoMaker
//     ʕ•͡●̫•ʔ ~♪
//  Created by bear
//  url: https://github.com/xiongcaichang/CodeAutoMaker
//  Copyright © 2015年 bear. All rights reserved.
//
#import "CCStoryboardManager.h"


@interface CCStoryboardManager ()
@property (nonatomic,assign)NSInteger viewCount;

@property (nonatomic,strong)NSDictionary *customAndId;
@property (nonatomic,strong)NSDictionary *customAndName;
@property (nonatomic,strong)NSDictionary *idAndViewPropertys;
@property (nonatomic,strong)NSDictionary *idAndViews;
@end

@implementation CCStoryboardManager
- (void)StroyBoard_To_Masonry:(NSString *)stroyBoard{
    _viewCount=0;
    NSLog(@"%@",@"开始");
    
    NSString *filePath=stroyBoard;
    
    if ([CCFileManager fileExistsAtPath:filePath]==NO) {
        return;
    }
    
    NSString *context=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    context=[CCStoryboardTextManager addCustomClassToAllViews:context];
    
//    [context writeToFile:[@"/Users/mac/Desktop" stringByAppendingPathComponent:@"MainNew.storyboard"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    ReadXML *xml=[ReadXML new];
    [xml initWithXMLString:context];
    
    NSDictionary *MyDic=[xml TreeToDict:xml.rootElement];
    
    NSArray *allViewControllers=[CCStoryboardXMLManager getAllViewControllerWithDic:MyDic andXMLHandel:xml];
    
    //    获取所有的ViewController名字
    NSArray *viewControllers=[CCStoryboardXMLManager getViewControllerCountNamesWithAllViewControllerArrM:allViewControllers];
    
    for (NSString *viewController in viewControllers) {
        //创建MVC文件夹
        [CCStroyBoardFileManager creat_MVC_WithViewControllerName:viewController];
        //创建对应的ViewController文件
        [CCStroyBoardFileManager creat_m_h_file:viewController isModel:NO isView:NO isController:YES isTableView:YES isCollectionView:NO forViewController:viewController];
    }
    
    //获取所有View的CustomClass与对应的id
    NSDictionary *customAndId=[CCStoryboardXMLManager getAllViewCustomAndIdWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    self.customAndId=customAndId;
    //获取所有View的CustomClass与对应的真实控件类型名字
    NSDictionary *customAndName=[CCStoryboardXMLManager getAllViewCustomAndNameWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    self.customAndName=customAndName;
    
    NSDictionary *idAndViews=[CCStoryboardXMLManager getAllViewWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    self.idAndViews=idAndViews;
    
    
    NSDictionary *idAndViewPropertys=[CCStoryboardPropertyManager getPropertysForView:idAndViews withCustomAndName:customAndName andXMLHandel:xml];
    self.idAndViewPropertys=idAndViewPropertys;
    
    //开始操作所有ViewController
    for (NSDictionary *dic in allViewControllers) {
        
        NSString *viewController;
        if(dic[@"customClass"]!=nil){
            viewController=dic[@"customClass"];
            {
                
                NSString *viewControllerFileName=[viewController stringByAppendingString:viewController];//对应的ViewController字典key值,通过这个key值可以找到对应存放在字典中的文件内容
                
                //先创建所有cell文件
                NSArray *allTableViewCells=[CCStoryboardXMLManager getAllTableViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                for (NSString *tableViewCell in allTableViewCells) {
                    
                    //创建对应的CellView文件
                    [CCStroyBoardFileManager creat_m_h_file:tableViewCell isModel:NO isView:YES isController:NO isTableView:YES isCollectionView:NO forViewController:viewController];
                    //创建对应的Model文件
                    [CCStroyBoardFileManager creat_m_h_file:tableViewCell isModel:YES isView:NO isController:NO isTableView:YES isCollectionView:NO forViewController:viewController];
                }
                
                NSArray *allCollectionViewCells=[CCStoryboardXMLManager getAllCollectionViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                for (NSString *collectionViewCell in allCollectionViewCells) {
                    //创建对应的CellView文件
                    [CCStroyBoardFileManager creat_m_h_file:collectionViewCell isModel:NO isView:YES isController:NO isTableView:NO isCollectionView:YES forViewController:viewController];
                    //创建对应的Model文件
                    [CCStroyBoardFileManager creat_m_h_file:collectionViewCell isModel:YES isView:NO isController:NO isTableView:NO isCollectionView:YES forViewController:viewController];
                }
                
                //获取这个ViewController的所有tableView ,其中每个tableView都对应其所有的tableViewCell
                NSDictionary *tableViewCellDic=[CCStoryboardXMLManager getAllTableViewAndTableViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                //                NSLog(@"**tableViewCellDic=%@",tableViewCellDic);
                //获取这个ViewController的所有tableViewCell
                NSMutableArray *tableViewCells=[NSMutableArray array];
                for (NSString *tableView in tableViewCellDic) {
                    NSArray *cells=tableViewCellDic[tableView];
                    for (NSString *cell in cells) {
                        if ([tableViewCells containsObject:cell]==NO) {
                            [tableViewCells addObject:cell];
                        }
                    }
                }
                NSLog(@"%@",viewController);
                NSLog(@"%@",tableViewCellDic);
                
                //获取这个ViewController的所有collectionView ,其中每个collectionView都对应其所有的collectionViewCell
                NSDictionary *collectionViewCellDic=[CCStoryboardXMLManager getAllCollectionViewAndCollectionViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                //                NSLog(@"------collectionViewCellDic=%@",collectionViewCellDic);
                //获取这个ViewController的所有collectionViewCell
                NSMutableArray *collectionViewCells=[NSMutableArray array];
                for (NSString *collectionView in collectionViewCellDic) {
                    NSArray *cells=collectionViewCellDic[collectionView];
                    for (NSString *cell in cells) {
                        if ([collectionViewCells containsObject:cell]==NO) {
                            [collectionViewCells addObject:cell];
                        }
                    }
                }
                NSLog(@"%@",collectionViewCellDic);
                
                //插入#import
                for (NSString *tableViewCell in tableViewCells) {
                    [CCStoryboardTextManager addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",tableViewCell] andInsertType:CCAddCodeType_Import toStrM:[CCStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                }
                
                for (NSString *collectionViewCell in collectionViewCells) {
                    [CCStoryboardTextManager addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",collectionViewCell] andInsertType:CCAddCodeType_Import toStrM:[CCStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                }
                
                //插入属性property
                NSArray *views=[CCStoryboardXMLManager getAllViewControllerSubViewsWithViewControllerDic:dic andXMLHandel:xml];
                
                //在这里,定义存储控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束的字典
                NSMutableDictionary *viewConstraintDicM_Self=[NSMutableDictionary dictionary];
                NSMutableDictionary *viewConstraintDicM_Other=[NSMutableDictionary dictionary];
                
                //                NSLog(@"%@\n\n\n\n",views);
                _viewCount+=views.count;
                
                //获取特殊的View --- >self.view
                [CCStoryboardXMLManager getViewAllConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:@"self.view" withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                
                for (NSString *idStr in views) {
                    
//                    if ([idStr hasPrefix:@"tableView"]||[idStr hasPrefix:@"collectionView"]) {
//                        continue;
//                    }
                    
                    //在这里,获取控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束
                    [CCStoryboardXMLManager getViewAllConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                    
                    //这里获取的属性不包括特殊控件,比如tableView,collectionView
                    NSString *property=[CCStoryboardTextManager getPropertyWithViewName:customAndId[idStr] withViewCategory:customAndName[idStr]];
                    
                    if (property.length>0) {
                        [CCStoryboardTextManager addCodeText:property andInsertType:CCAddCodeType_Interface toStrM:[CCStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                    }
                }
                
                NSMutableDictionary *viewConstraintDicM_Self_NEW=[viewConstraintDicM_Self mutableCopy];
                NSMutableDictionary *viewConstraintDicM_Other_NEW=[viewConstraintDicM_Other mutableCopy];
                
                [CCStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                [CCStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Second:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                [CCStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Three:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                
                //在这里插入所有view的创建和约束
                
                //开始建立一个父子和兄弟关系的链表
                NSMutableDictionary *viewRelationShipDic=[NSMutableDictionary dictionary];
                [CCStoryboardXMLManager createRelationShipWithControllerDic:dic andXMLHandel:xml WithViews:[NSMutableArray arrayWithArray:views] withRelationShipDic:viewRelationShipDic isCell:NO];
                
                
                //创建这个数组是无奈之举,因为兄弟之间的约束,有时候是两个兄弟之间的互相约束,这样必须先同时创建两个兄弟,所以才用这个数组来保存已经创建好的兄弟,防止又一次创建
                NSMutableArray *brotherOrderArrM=[NSMutableArray array];
                
                BOOL isOnlyTableViewOrCollectionView=NO;
                if(tableViewCellDic.count>0||collectionViewCellDic.count>0){
                    //获取该ViewController的tableview的个数
                    NSInteger tableViewCount=tableViewCellDic.count;
                    //获取该ViewController的collectionview的个数
                    NSInteger collectionViewCount=collectionViewCellDic.count;
                    
                    if (tableViewCount>0&&collectionViewCount>0) {
                        isOnlyTableViewOrCollectionView=NO;
                    }else if(tableViewCount<=1&&collectionViewCount<=1){
                        isOnlyTableViewOrCollectionView=YES;
                    }else{
                        isOnlyTableViewOrCollectionView=NO;
                    }
                }
                
                //1.首先开始创建控件  从父亲的subViews开始
                NSMutableString *creatCodeStrM=[NSMutableString string];
                [creatCodeStrM appendString:@"- (void)addSubViews{\n\n"];
                for (NSString *idStr in views) {
                    NSString *fatherView=[CCStoryboardTextManager getFatherView:self.customAndId[idStr] inViewRelationShipDic:viewRelationShipDic];
                    
                    NSString *creatCode=[CCStoryboardTextManager getCreateViewCodeWithIdStr:idStr WithViewName:self.customAndId[idStr] withViewCategoryName:self.customAndName[idStr]  withOutletView:nil addToFatherView:fatherView withDoneArrM:brotherOrderArrM isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView];
                    
                    NSMutableString *propertyCode=[NSMutableString string];
                    [propertyCode setString:creatCode];
                    
                    [CCStoryboardPropertyManager getCodePropertysForViewName:idStr WithidAndViewDic:customAndId withCustomAndName:customAndName withProperty:idAndViewPropertys[idStr] toCodeText:propertyCode];
                    
                    [creatCodeStrM appendString:propertyCode];
                    
                    NSString *selectorEventType=[CCStoryboardPropertyManager getSelectorEventTypeForViewName:idStr withProperty:idAndViewPropertys[idStr]];
                    if (selectorEventType.length>0) {
                        [CCStoryboardTextManager addCodeText:selectorEventType andInsertType:CCAddCodeType_Implementation toStrM:[CCStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                    }
                    
                    NSMutableDictionary *originalConstraintDicM_Self=[NSMutableDictionary dictionary];
                    [CCStoryboardXMLManager getViewAllConstraintWithViewDic:self.idAndViews[idStr] andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:originalConstraintDicM_Self];
                    
                    //创建约束
                    NSString *constraintCode=[CCStoryboardTextManager getCreatConstraintCodeWithIdStr:idStr WithViewName:self.customAndId[idStr] withConstraintDic:viewConstraintDicM_Self_NEW withSelfConstraintDic:originalConstraintDicM_Self withOutletView:nil isCell:NO withDoneArrM:brotherOrderArrM withCustomAndNameDic:self.customAndName addToFatherView:fatherView isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView];
                    
                    //有时我们在StroyBoard或者xib中忘记添加约束,这是就用默认的frame作为约束
                    if([constraintCode rangeOfString:@".equalTo"].location==NSNotFound&&[constraintCode rangeOfString:@"make."].location==NSNotFound){
                        
                        NSString *constraintCodeDefualt=[CCStoryboardPropertyManager getConstraintIfNotGiveConstraintsForViewName:idStr withProperty:self.idAndViewPropertys[idStr] withFatherView:fatherView];
                        constraintCode = [constraintCode stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"[%@ mas_makeConstraints:^(MASConstraintMaker *make) {\n",idStr] withString:@""];
                        constraintCode = [constraintCode stringByReplacingOccurrencesOfString:@"}];\n\n\n" withString:@""];
                        constraintCode = [constraintCode stringByAppendingString:constraintCodeDefualt];
                        constraintCode = [constraintCode stringByAppendingString:@"\n\n"];
                    }
                    
                    [creatCodeStrM appendString:constraintCode];
                }
                
                //解决self.tableView3=tableView3;的问题 但是实际上这个viewcontroller只有一个tableView
                [CCStoryboardTextManager dealWith_self_tableView_collectionView:creatCodeStrM isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView];
                
                [creatCodeStrM appendString:@"}\n"];
                
                [CCStoryboardTextManager addCodeText:creatCodeStrM andInsertType:CCAddCodeType_Implementation toStrM:[CCStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                
                //解决UIMapView *mapView1;的问题
                [CCStoryboardTextManager dealWith_UIMapView:[CCStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] needInserFramework:YES];
                
                //                NSLog(@"%@",creatCodeStrM);
                //                NSLog(@"viewConstraintDicM_Self=%@",viewConstraintDicM_Self_NEW);
                
                
                //再添加代码
                if(tableViewCellDic.count>0&&collectionViewCellDic.count>0){
                    
                    //获取该ViewController的tableview的个数
                    NSInteger tableViewCount=tableViewCellDic.count;
                    //获取该ViewController的collectionview的个数
                    NSInteger collectionViewCount=collectionViewCellDic.count;
                    
                    NSInteger tableViewCount_new=[CCStoryboardTextManager getTableViewCount:views];
                    if (tableViewCount_new!=tableViewCount) {
                        NSLog(@"1-%@:%@",viewController,@"筛选没有筛选完");
                    }
                    NSInteger collectionViewCount_new=[CCStoryboardTextManager getCollectionViewCount:views];
                    if (collectionViewCount!=collectionViewCount_new) {
                        NSLog(@"2-%@:%@",viewController,@"筛选没有筛选完");
                    }
                    
                    //添加代理方法
                    [CCStoryboardTextManager addDelegateFunctionToText:[CCStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withTableViews:tableViewCellDic isOnlyTableViewOrCollectionView:NO];
                    [CCStoryboardTextManager addDelegateFunctionToText:[CCStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withCollectionViews:collectionViewCellDic isOnlyTableViewOrCollectionView:NO];
                }
                else if (tableViewCellDic.count>0){
                    //获取该ViewController的tableview的个数
                    NSInteger tableViewCount=tableViewCellDic.count;
                    
                    NSInteger tableViewCount_new=[CCStoryboardTextManager getTableViewCount:views];
                    if (tableViewCount_new!=tableViewCount) {
                        NSLog(@"3-%@:%@",viewController,@"筛选没有筛选完");
                    }
                    
                    if (tableViewCount==1) {
                        //添加代理方法
                        [CCStoryboardTextManager addDelegateFunctionToText:[CCStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withTableViews:tableViewCellDic isOnlyTableViewOrCollectionView:YES];
                    }else{
                        //添加代理方法
                        [CCStoryboardTextManager addDelegateFunctionToText:[CCStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withTableViews:tableViewCellDic isOnlyTableViewOrCollectionView:NO];
                    }
                    
                }else if (collectionViewCellDic.count>0){
                    
                    //获取该ViewController的collectionview的个数
                    NSInteger collectionViewCount=collectionViewCellDic.count;
                    
                    NSInteger collectionViewCount_new=[CCStoryboardTextManager getCollectionViewCount:views];
                    if (collectionViewCount!=collectionViewCount_new) {
                        NSLog(@"4-%@:%@",viewController,@"筛选没有筛选完");
                    }
                    
                    if (collectionViewCount==1) {
                        //添加代理方法
                        [CCStoryboardTextManager addDelegateFunctionToText:[CCStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withCollectionViews:collectionViewCellDic isOnlyTableViewOrCollectionView:YES];
                    }else{
                        //添加代理方法
                        [CCStoryboardTextManager addDelegateFunctionToText:[CCStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withCollectionViews:collectionViewCellDic isOnlyTableViewOrCollectionView:NO];
                    }
                }
            }
            
            
            NSArray *tableViewCellDic=[CCStoryboardXMLManager getTableViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
            NSArray *collectionViewCellDic=[CCStoryboardXMLManager getCollectionViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
            
            [self detailSubCells:tableViewCellDic andXMLHandel:xml withFatherViewController:viewController];
            [self detailSubCells:collectionViewCellDic andXMLHandel:xml withFatherViewController:viewController];
        }
    }
    
    NSInteger count=0;
    
    count=[CCStoryboardTextManager getAllViewCount];
    //    NSLog(@"count=%ld",count);
    
//    删除副本故事版StroyBoard
//    [[NSFileManager defaultManager]removeItemAtPath:[mainPath stringByAppendingPathComponent:@"MainNew.storyboard"] error:nil];
    
    //这句话一定要加
    [CCStroyBoardFileManager done];
    [CCStoryboardTextManager done];
    
    customAndId=nil;
    customAndName=nil;
    xml=nil;
    
    NSLog(@"%@",@"结束");//时间花销 0.6s
    NSLog(@"%ld",_viewCount);
}

- (void)Xib_To_Masonry:(NSString *)xib{
    //先生成ViewController,因为XIB里面也可能有ViewController
    
    [self StroyBoard_To_Masonry:xib];
    
    [self Xib_To_MasonryForView:xib];
    
}



- (void)Xib_To_MasonryForView:(NSString *)xib{
    _viewCount=0;
    
    NSString *filePath=xib;
    
    if ([CCFileManager fileExistsAtPath:filePath]==NO) {
        return;
    }
    
    NSString *mainPath=[CCFileManager getFilePathRemoveFileName:filePath];
    
    NSString *context=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    context=[CCStoryboardTextManager addCustomClassToAllViews:context];
    
//    [context writeToFile:[mainPath stringByAppendingPathComponent:@"MainNew.storyboard"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    ReadXML *xml=[ReadXML new];
    [xml initWithXMLString:context];
    
    NSDictionary *MyDic=[xml TreeToDict:xml.rootElement];
    
    //    获取所有的View,TableViewCell,CollectionViewCell
    NSArray *allViews=[CCStoryboardXMLManager getAllViewWithDic:MyDic andXMLHandel:xml];
    
    //    获取所有的View,TableViewCell,CollectionViewCell名字
    NSArray *views=[CCStoryboardXMLManager getViewControllerCountNamesWithAllViewControllerArrM:allViews];
    
    for (NSString *view in views) {
        //创建MVC文件夹
        [CCStroyBoardFileManager creat_V_WithViewName_XIB:view];
        //创建对应的View文件
        [CCStroyBoardFileManager creat_m_h_file_XIB:view forView:view];
    }
    
    //开始操作所有View
    for (NSDictionary *dic in allViews) {
        
        NSString *viewController;
        if(dic[@"customClass"]!=nil){
            viewController=dic[@"customClass"];
            {
                NSString *viewControllerFileName=[viewController stringByAppendingString:viewController];//对应的ViewController字典key值,通过这个key值可以找到对应存放在字典中的文件内容
                
                self.customAndId=self.customAndName=self.idAndViewPropertys=nil;
                
                //获取所有View的CustomClass与对应的id
                NSDictionary *customAndId=[CCStoryboardXMLManager getAllViewCustomAndIdWithAllViewArrM_XIB:allViews andXMLHandel:xml];
                self.customAndId=customAndId;
                
                //获取所有View的CustomClass与对应的真实控件类型名字
                NSDictionary *customAndName=[CCStoryboardXMLManager getAllViewCustomAndNameWithAllViewArrM_XIB:allViews andXMLHandel:xml];
                self.customAndName=customAndName;
                
                if ([viewController hasSuffix:@"TableViewCell"]) {
                    //获取所有View的CustomClass与对应的属性
                    NSDictionary *idAndViews=[CCStoryboardXMLManager getAllCellViewWithAllViewControllerArrM_XIB:allViews andXMLHandel:xml];
                    NSDictionary *idAndViewPropertys=[CCStoryboardPropertyManager getPropertysForView:idAndViews withCustomAndName:customAndName andXMLHandel:xml];
                    self.idAndViewPropertys=idAndViewPropertys;
                }else{
                    //获取所有View的CustomClass与对应的属性
                    NSDictionary *idAndViews=[CCStoryboardXMLManager getAllViewWithAllViewControllerArrM:allViews andXMLHandel:xml];
                    
                    NSDictionary *idAndViewPropertys=[CCStoryboardPropertyManager getPropertysForView:idAndViews withCustomAndName:customAndName andXMLHandel:xml];
                    self.idAndViewPropertys=idAndViewPropertys;
                }
                
                //插入属性property
                NSArray *views;
                if ([viewController hasSuffix:@"TableViewCell"]) {
                    views=[CCStoryboardXMLManager getAllCellSubViewsWithViewControllerDic:dic andXMLHandel:xml];
                }
                else views=[CCStoryboardXMLManager getAllViewControllerSubViewsWithViewControllerDic:dic andXMLHandel:xml];
                
                //在这里,定义存储控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束的字典
                NSMutableDictionary *viewConstraintDicM_Self=[NSMutableDictionary dictionary];
                NSMutableDictionary *viewConstraintDicM_Other=[NSMutableDictionary dictionary];
                
                _viewCount+=views.count;
                
                if ([viewController hasSuffix:@"TableViewCell"]){
                    //获取特殊的View --- >self.view
                    [CCStoryboardXMLManager getTableViewCellViewAllConstraintWithControllerDic_XIB:dic andXMLHandel:xml withViewIdStr:viewController withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                }else{
                    //获取特殊的View --- >self.view
                    [CCStoryboardXMLManager getViewAllConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:viewController withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                }
                
                BOOL isOnlyTableViewOrCollectionView=NO;
                NSInteger tableViewCount=0,collectionViewCount=0;
                
                for (NSString *idStr in views) {
                    
                    if ([idStr hasPrefix:@"tableView"]) {
                        tableViewCount++;
                    }else if ([idStr hasPrefix:@"collectionView"]){
                        collectionViewCount++;
                    }
                }
                
                if (tableViewCount>0&&collectionViewCount>0) {
                    isOnlyTableViewOrCollectionView=NO;
                }else if(tableViewCount<=1&&collectionViewCount<=1){
                    isOnlyTableViewOrCollectionView=YES;
                }else{
                    isOnlyTableViewOrCollectionView=NO;
                }
                
                for (NSString *idStr in views) {
                    
                    //在这里,获取控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束
                    [CCStoryboardXMLManager getViewAllConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                    
                    //这里获取的属性不包括特殊控件,比如tableView,collectionView
                    NSString *property=[CCStoryboardTextManager getPropertyWithViewName_XIB:self.customAndId[idStr] withViewCategory:self.customAndName[idStr] isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView];
                    
                    if (property.length>0) {
                        [CCStoryboardTextManager addCodeText:property andInsertType:CCAddCodeType_Interface toStrM:[CCStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                    }
                }
                
                NSMutableDictionary *viewConstraintDicM_Self_NEW=[viewConstraintDicM_Self mutableCopy];
                NSMutableDictionary *viewConstraintDicM_Other_NEW=[viewConstraintDicM_Other mutableCopy];
                
                [CCStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                [CCStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Second:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                [CCStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Three:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                
                //在这里插入所有view的创建和约束
                
                //开始建立一个父子和兄弟关系的链表
                NSMutableDictionary *viewRelationShipDic=[NSMutableDictionary dictionary];
                [CCStoryboardXMLManager createRelationShipWithControllerDic:dic andXMLHandel:xml WithViews:[NSMutableArray arrayWithArray:views] withRelationShipDic:viewRelationShipDic isCell:NO];
                
                
                //创建这个数组是无奈之举,因为兄弟之间的约束,有时候是两个兄弟之间的互相约束,这样必须先同时创建两个兄弟,所以才用这个数组来保存已经创建好的兄弟,防止有一次创建
                NSMutableArray *brotherOrderArrM=[NSMutableArray array];
                [brotherOrderArrM addObject:viewController];
                
                //1.首先开始创建控件  从父亲的subViews开始
                NSMutableString *creatCodeStrM=[NSMutableString string];
                [creatCodeStrM appendString:@"- (void)addSubViews{\n\n"];
                for (NSString *idStr in views) {
                    NSString *fatherView=[CCStoryboardTextManager getFatherView:self.customAndId[idStr] inViewRelationShipDic:viewRelationShipDic];
                    NSString *creatCode=[CCStoryboardTextManager getCreateViewCodeWithIdStr:idStr WithViewName:self.customAndId[idStr] withViewCategoryName:self.customAndName[idStr] withOutletView:nil addToFatherView:fatherView withDoneArrM:brotherOrderArrM isOnlyTableViewOrCollectionView:YES];
                    
                    NSMutableString *propertyCode=[NSMutableString string];
                    [propertyCode setString:creatCode];
                    
                    [CCStoryboardPropertyManager getCodePropertysForViewName:idStr WithidAndViewDic:self.customAndId withCustomAndName:self.customAndName withProperty:self.idAndViewPropertys[idStr] toCodeText:propertyCode];
                    
                    [creatCodeStrM appendString:propertyCode];
                    
                    NSMutableDictionary *originalConstraintDicM_Self=[NSMutableDictionary dictionary];
                    [CCStoryboardXMLManager getViewAllConstraintWithViewDic:self.idAndViews[idStr] andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:originalConstraintDicM_Self];
                    
                    //创建约束
                    NSString *constraintCode=[CCStoryboardTextManager getCreatConstraintCodeWithIdStr:idStr WithViewName:self.customAndId[idStr] withConstraintDic:viewConstraintDicM_Self_NEW withSelfConstraintDic:originalConstraintDicM_Self withOutletView:nil isCell:NO withDoneArrM:brotherOrderArrM withCustomAndNameDic:self.customAndName addToFatherView:fatherView isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView];
                    
                    //有时我们在StroyBoard或者xib中忘记添加约束,这是就用默认的frame作为约束
                    if([constraintCode rangeOfString:@".equalTo"].location==NSNotFound&&[constraintCode rangeOfString:@"make."].location==NSNotFound){
                        NSString *constraintCodeDefualt=[CCStoryboardPropertyManager getConstraintIfNotGiveConstraintsForViewName:idStr withProperty:self.idAndViewPropertys[idStr] withFatherView:fatherView];
                        constraintCode = [constraintCode stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"[%@ mas_makeConstraints:^(MASConstraintMaker *make) {\n",idStr] withString:@""];
                        constraintCode = [constraintCode stringByReplacingOccurrencesOfString:@"}];\n\n\n" withString:@""];
                        constraintCode = [constraintCode stringByAppendingString:constraintCodeDefualt];
                        constraintCode = [constraintCode stringByAppendingString:@"\n\n"];
                    }
                    
                    [creatCodeStrM appendString:constraintCode];
                }
//                //解决self.tableView3=tableView3;的问题
                [CCStoryboardTextManager dealWith_self_tableView_collectionView:creatCodeStrM isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView];
                [creatCodeStrM appendString:@"}\n"];
                
                //对creatCodeStrM进行替换
                NSString *creatCodeStrM_new=[creatCodeStrM stringByReplacingOccurrencesOfString:viewController withString:@"self"];
                creatCodeStrM_new=[creatCodeStrM_new stringByReplacingOccurrencesOfString:@"self.view." withString:@"self."];
                creatCodeStrM_new=[creatCodeStrM_new stringByReplacingOccurrencesOfString:@"self.view " withString:@"self "];
                
                //如果是tableViewCell或者CollectionViewCell
                if ([viewController hasSuffix:@"TableViewCell"]||[viewController hasSuffix:@"CollectionViewCell"]){
                    creatCodeStrM_new=[creatCodeStrM_new stringByReplacingOccurrencesOfString:@"[self addSubview:" withString:@"[self.contentView addSubview:"];
                    creatCodeStrM_new=[creatCodeStrM_new stringByReplacingOccurrencesOfString:@"self.mas" withString:@"self.contentView.mas"];
                }
                
                [CCStoryboardTextManager addCodeText:creatCodeStrM_new andInsertType:CCAddCodeType_Implementation toStrM:[CCStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                //解决UIMapView *mapView1;的问题
                [CCStoryboardTextManager dealWith_UIMapView:[CCStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] needInserFramework:YES];
            }
        }
    }
    
    NSInteger count=0;
    
    count=[CCStoryboardTextManager getAllViewCount];
    //    NSLog(@"count=%ld",count);
    
    //删除副本故事版StroyBoard
    [[NSFileManager defaultManager]removeItemAtPath:[mainPath stringByAppendingPathComponent:@"MainNew.storyboard"] error:nil];
    
    //这句话一定要加
    [CCStroyBoardFileManager done];
    [CCStoryboardTextManager done];
    xml=nil;
}

/**递归继续子cell的代码生成*/
- (void)detailSubCells:(NSArray *)subCells andXMLHandel:(ReadXML *)xml withFatherViewController:(NSString *)viewController{
    for (NSDictionary *subDic in subCells) {
        
        NSString *fatherCellName=[xml dicNodeValueWithKey:@"customClass" ForDic:subDic];
        NSString *NewFileName=[viewController stringByAppendingString:fatherCellName];
        
        //给.h文件添加refreshUI的方法
        //先导入model头文件
        [CCStoryboardTextManager addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",[fatherCellName stringByAppendingString:@"Model"]] andInsertType:CCAddCodeType_Import toStrM:[CCStroyBoardFileManager get_H_ContextByIdentity:NewFileName] insertFunction:nil];
        //再添加refreshUI方法
        [CCStoryboardTextManager addCodeText:[NSString stringWithFormat:@"- (void)refreshUI:(%@ *)dataModel;",[fatherCellName stringByAppendingString:@"Model"]] andInsertType:CCAddCodeType_Interface toStrM:[CCStroyBoardFileManager get_H_ContextByIdentity:NewFileName] insertFunction:nil];
        
        //给.m文件添加refreshUI
        [CCStoryboardTextManager addCodeText:[NSString stringWithFormat:@"\n- (void)refreshUI:(%@ *)dataModel{\n\
                                              \n\
                                              }",[fatherCellName stringByAppendingString:@"Model"]] andInsertType:CCAddCodeType_Implementation toStrM:[CCStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
        
        
        NSDictionary *subTableViewCells=[CCStoryboardXMLManager getAllTableViewAndTableViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        if (subTableViewCells.count>0) {
            //插入#import
            for (NSString *tableViewName in subTableViewCells) {
                NSArray *tableViewCells=subTableViewCells[tableViewName];
                for (NSString *tableViewCell in tableViewCells) {
                    [CCStoryboardTextManager addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",tableViewCell] andInsertType:CCAddCodeType_Import toStrM:[CCStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
                }
            }
        }
        
        NSDictionary *subCollectionViewCells=[CCStoryboardXMLManager getAllCollectionViewAndCollectionViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        if (subCollectionViewCells.count>0) {
            for (NSString *collectionViewName in subCollectionViewCells) {
                NSArray *collectionViewCells=subCollectionViewCells[collectionViewName];
                for (NSString *collectionViewCell in collectionViewCells) {
                    [CCStoryboardTextManager addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",collectionViewCell] andInsertType:CCAddCodeType_Import toStrM:[CCStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
                }
            }
        }
        
        //插入属性property
        NSArray *views=[CCStoryboardXMLManager getAllCellSubViewsWithViewControllerDic:subDic andXMLHandel:xml];
        
        //在这里,定义存储控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束的字典
        NSMutableDictionary *viewConstraintDicM_Self=[NSMutableDictionary dictionary];
        NSMutableDictionary *viewConstraintDicM_Other=[NSMutableDictionary dictionary];
        
        //                NSLog(@"%@\n\n\n\n",views);
        _viewCount+=views.count;
        
        //获取特殊的View --- >self.view
        [CCStoryboardXMLManager getViewAllConstraintWithControllerDic:subDic andXMLHandel:xml withViewIdStr:fatherCellName withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
        
        
        for (NSString *idStr in views) {
            
//            if ([idStr hasPrefix:@"tableView"]||[idStr hasPrefix:@"collectionView"]) {
//                continue;
//            }
            
            //在这里,获取控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束
            [CCStoryboardXMLManager getViewAllConstraintWithControllerDic:subDic andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
            
            //这里获取的属性不包括特殊控件,比如tableView,collectionView
            NSString *property=[CCStoryboardTextManager getPropertyWithViewName:self.customAndId[idStr] withViewCategory:self.customAndName[idStr]];
            
            if (property.length>0) {
                [CCStoryboardTextManager addCodeText:property andInsertType:CCAddCodeType_Interface toStrM:[CCStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
            }
        }
        
        NSMutableDictionary *viewConstraintDicM_Self_NEW=[viewConstraintDicM_Self mutableCopy];
        NSMutableDictionary *viewConstraintDicM_Other_NEW=[viewConstraintDicM_Other mutableCopy];
        
        
        [CCStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
        [CCStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Second:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
        [CCStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Three:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
        
        //在这里插入所有view的创建和约束
        
        //开始建立一个父子和兄弟关系的链表
        NSMutableDictionary *viewRelationShipDic=[NSMutableDictionary dictionary];
        [CCStoryboardXMLManager createRelationShipWithControllerDic:subDic andXMLHandel:xml WithViews:[NSMutableArray arrayWithArray:views] withRelationShipDic:viewRelationShipDic isCell:YES];
        
        
        BOOL isOnlyTableViewOrCollectionView=YES;
        if(subTableViewCells.count>0||subCollectionViewCells.count>0){
            //获取该ViewController的tableview的个数
            NSInteger tableViewCount=subTableViewCells.count;
            //获取该ViewController的collectionview的个数
            NSInteger collectionViewCount=subCollectionViewCells.count;
            
            if (tableViewCount>0&&collectionViewCount>0) {
                isOnlyTableViewOrCollectionView=NO;
            }else if(tableViewCount<=1&&collectionViewCount<=1){
                isOnlyTableViewOrCollectionView=YES;
            }else{
                isOnlyTableViewOrCollectionView=NO;
            }
        }
        
        //创建这个数组是无奈之举,因为兄弟之间的约束,有时候是两个兄弟之间的互相约束,这样必须先同时创建两个兄弟,所以才用这个数组来保存已经创建好的兄弟,防止有一次创建
        NSMutableArray *brotherOrderArrM=[NSMutableArray array];
        
        //1.首先开始创建控件  从父亲的subViews开始
        NSMutableString *creatCodeStrM=[NSMutableString string];
        [creatCodeStrM appendString:@"- (void)addSubViews{\n\n"];
        for (NSString *idStr in views) {
            NSString *fatherView=[CCStoryboardTextManager getFatherView:self.customAndId[idStr] inViewRelationShipDic:viewRelationShipDic];
            NSString *creatCode=[CCStoryboardTextManager getCreateViewCodeWithIdStr:idStr WithViewName:self.customAndId[idStr] withViewCategoryName:self.customAndName[idStr] withOutletView:nil addToFatherView:fatherView withDoneArrM:brotherOrderArrM isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView];
            
            NSMutableString *propertyCode=[NSMutableString string];
            [propertyCode setString:creatCode];
            
            [CCStoryboardPropertyManager getCodePropertysForViewName:idStr WithidAndViewDic:self.customAndId withCustomAndName:self.customAndName withProperty:self.idAndViewPropertys[idStr] toCodeText:propertyCode];
            
            [creatCodeStrM appendString:propertyCode];
            
            NSString *selectorEventType=[CCStoryboardPropertyManager getSelectorEventTypeForViewName:idStr withProperty:self.idAndViewPropertys[idStr]];
            if (selectorEventType.length>0) {
                [CCStoryboardTextManager addCodeText:selectorEventType andInsertType:CCAddCodeType_Implementation toStrM:[CCStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
            }
            
            NSMutableDictionary *originalConstraintDicM_Self=[NSMutableDictionary dictionary];
            [CCStoryboardXMLManager getViewAllConstraintWithViewDic:self.idAndViews[idStr] andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:originalConstraintDicM_Self];
            
            //创建约束
            NSString *constraintCode=[CCStoryboardTextManager getCreatConstraintCodeWithIdStr:idStr WithViewName:self.customAndId[idStr] withConstraintDic:viewConstraintDicM_Self_NEW withSelfConstraintDic:originalConstraintDicM_Self withOutletView:nil isCell:YES withDoneArrM:brotherOrderArrM withCustomAndNameDic:self.customAndName addToFatherView:fatherView isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView];
            
            //有时我们在StroyBoard或者xib中忘记添加约束,这是就用默认的frame作为约束
            if([constraintCode rangeOfString:@".equalTo"].location==NSNotFound&&[constraintCode rangeOfString:@"make."].location==NSNotFound){
                
                NSString *constraintCodeDefualt=[CCStoryboardPropertyManager getConstraintIfNotGiveConstraintsForViewName:idStr withProperty:self.idAndViewPropertys[idStr] withFatherView:fatherView];
                constraintCode = [constraintCode stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"[%@ mas_makeConstraints:^(MASConstraintMaker *make) {\n",idStr] withString:@""];
                constraintCode = [constraintCode stringByReplacingOccurrencesOfString:@"}];\n\n\n" withString:@""];
                constraintCode = [constraintCode stringByAppendingString:constraintCodeDefualt];
                constraintCode = [constraintCode stringByAppendingString:@"\n\n"];
            }
            
            [creatCodeStrM appendString:constraintCode];
        }
        
        //解决self.tableView3=tableView3;的问题
        [CCStoryboardTextManager dealWith_self_tableView_collectionView:creatCodeStrM isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView];
        
        [creatCodeStrM appendString:@"}"];
        [CCStoryboardTextManager addCodeText:creatCodeStrM andInsertType:CCAddCodeType_Implementation toStrM:[CCStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
        
        //解决UIMapView *mapView1;的问题
        [CCStoryboardTextManager dealWith_UIMapView:[CCStroyBoardFileManager get_M_ContextByIdentity:NewFileName] needInserFramework:YES];
        
        //                NSLog(@"%@",creatCodeStrM);
        //        NSLog(@"viewConstraintDicM_Self=%@",viewConstraintDicM_Self_NEW);
        
        //再添加代码
        if(subTableViewCells.count>0&&subCollectionViewCells.count>0){
            
            //获取该ViewController的tableview的个数
            NSInteger tableViewCount=subTableViewCells.count;
            //获取该ViewController的collectionview的个数
            NSInteger collectionViewCount=subCollectionViewCells.count;
            
            NSInteger tableViewCount_new=[CCStoryboardTextManager getTableViewCount:views];
            if (tableViewCount_new!=tableViewCount) {
                NSLog(@"%@",@"筛选没有筛选完");
            }
            NSInteger collectionViewCount_new=[CCStoryboardTextManager getCollectionViewCount:views];
            if (collectionViewCount!=collectionViewCount_new) {
                NSLog(@"%@",@"筛选没有筛选完");
            }
            
            //添加代理方法
            [CCStoryboardTextManager addDelegateFunctionToText:[CCStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withTableViews:subTableViewCells isOnlyTableViewOrCollectionView:NO];
            [CCStoryboardTextManager addDelegateFunctionToText:[CCStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withCollectionViews:subCollectionViewCells isOnlyTableViewOrCollectionView:NO];
        }
        else if (subTableViewCells.count>0){
            //获取该ViewController的tableview的个数
            NSInteger tableViewCount=subTableViewCells.count;
            
            NSInteger tableViewCount_new=[CCStoryboardTextManager getTableViewCount:views];
            if (tableViewCount_new!=tableViewCount) {
                NSLog(@"%@",@"筛选没有筛选完");
            }
            
            if (tableViewCount==1) {
                //添加代理方法
                [CCStoryboardTextManager addDelegateFunctionToText:[CCStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withTableViews:subTableViewCells isOnlyTableViewOrCollectionView:YES];
            }else{
                //添加代理方法
                [CCStoryboardTextManager addDelegateFunctionToText:[CCStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withTableViews:subTableViewCells isOnlyTableViewOrCollectionView:NO];
            }
            
        }else if (subCollectionViewCells.count>0){
            
            //获取该ViewController的collectionview的个数
            NSInteger collectionViewCount=subCollectionViewCells.count;
            
            NSInteger collectionViewCount_new=[CCStoryboardTextManager getCollectionViewCount:views];
            if (collectionViewCount!=collectionViewCount_new) {
                NSLog(@"%@",@"筛选没有筛选完");
            }
            
            if (collectionViewCount==1) {
                //添加代理方法
                [CCStoryboardTextManager addDelegateFunctionToText:[CCStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withCollectionViews:subCollectionViewCells isOnlyTableViewOrCollectionView:YES];
            }else{
                //添加代理方法
                [CCStoryboardTextManager addDelegateFunctionToText:[CCStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withCollectionViews:subCollectionViewCells isOnlyTableViewOrCollectionView:NO];
            }
        }
        NSArray *tableViewCellDic=[CCStoryboardXMLManager getTableViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        NSArray *collectionViewCellDic=[CCStoryboardXMLManager getCollectionViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        
        [self detailSubCells:tableViewCellDic andXMLHandel:xml withFatherViewController:viewController];
        [self detailSubCells:collectionViewCellDic andXMLHandel:xml withFatherViewController:viewController];
    }
}
@end