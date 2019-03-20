//
//  ViewController.m
//  XQJsonCompare
//
//  Created by WXQ on 2019/3/19.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "ViewController.h"
#import <XQProjectTool/NSDictionary+XQJson.h>
#import <XQProjectTool/XQAlertSystem.h>
#import <YYModel/YYModel.h>
#import "XQHistoryRecord.h"

typedef NS_ENUM(NSInteger, XQAnalysisError) {
    XQAnalysisErrorNil = 0,
    XQAnalysisErrorSucceed,
    XQAnalysisErrorJson1Error,
    XQAnalysisErrorJson2Error,
};

@interface ViewController () <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTableColumn *tableColumn;

@property (unsafe_unretained) IBOutlet NSTextView *oneView;
@property (unsafe_unretained) IBOutlet NSTextView *twoView;

@property (unsafe_unretained) IBOutlet NSTextView *oneMinusTView;
@property (unsafe_unretained) IBOutlet NSTextView *twoMinusTView;

@property (unsafe_unretained) IBOutlet NSTextView *oneValueTView;
@property (unsafe_unretained) IBOutlet NSTextView *twoValueTView;
@property (unsafe_unretained) IBOutlet NSTextView *equalTView;

/** <#note#> */
@property (nonatomic, copy) NSArray <XQHistoryRecord *> *modelArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modelArr = [XQHistoryRecord readAllModels];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableColumn.title = @"历史记录";
    self.tableColumn.width = 240;
    self.tableColumn.maxWidth = 240;
    self.tableColumn.minWidth = 240;
}

#pragma mark - respondsTo

- (IBAction)respondsToOutResult:(id)sender {
    
}

- (IBAction)respondsToRemoveFormat:(id)sender {
    self.oneView.string = [[self class] xq_removeFormatWithStr:self.oneView.string];
    self.twoView.string = [[self class] xq_removeFormatWithStr:self.twoView.string];
}

- (IBAction)respondsToAnalysis:(id)sender {
    [[self class] modelWithJson1:self.oneView.string json2:self.twoView.string callback:^(XQHistoryRecord *model, XQAnalysisError error) {
        
        switch (error) {
            case XQAnalysisErrorNil:{
                [XQAlertSystem alertSheetWithTitle:@"数据不能为空" message:@"" contentArr:@[@"确定"] callback:^(NSInteger index) {
                    
                }];
            }
                break;
                
            case XQAnalysisErrorJson1Error:{
                [XQAlertSystem alertSheetWithTitle:@"Json1无法解析" message:@"" contentArr:@[@"确定"] callback:^(NSInteger index) {
                    
                }];
            }
                break;
                
            case XQAnalysisErrorJson2Error:{
                [XQAlertSystem alertSheetWithTitle:@"Json2无法解析" message:@"" contentArr:@[@"确定"] callback:^(NSInteger index) {
                    
                }];
            }
                break;
                
            case XQAnalysisErrorSucceed:{
                self.oneMinusTView.string = model.json1ToJson2KeyMinus;
                self.twoMinusTView.string = model.json2ToJson1KeyMinus;
                
                self.oneValueTView.string = model.json1ValueDifference;
                self.twoValueTView.string = model.json2ValueDifference;
                
                self.equalTView.string = model.equalJson;
            }
                break;
                
            default:
                break;
        }
        
    }];
}


#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSLog(@"%s", __func__);
    return 1;
}

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSLog(@"%s", __func__);
    return nil;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 100;
}

#pragma mark - Other Method

+ (void)modelWithJson1:(NSString *)json1 json2:(NSString *)json2 callback:(void(^)(XQHistoryRecord *model, XQAnalysisError error))callback {
    if (json1.length == 0 || json2.length == 0) {
        if (callback) {
            callback(nil, XQAnalysisErrorNil);
        }
        return;
    }
    
    NSDictionary *oneDic = [NSDictionary dictionaryWithJsonString:[[self class] filterChineseSymbolWithStr:json1]];
    if (!oneDic) {
        
        NSLog(@"%@, %@", json1, [json1 yy_modelToJSONString]);
        
        if (callback) {
            callback(nil, XQAnalysisErrorJson1Error);
        }
        return;
    }
    
    NSDictionary *twoDic = [NSDictionary dictionaryWithJsonString:[[self class] filterChineseSymbolWithStr:json2]];
    if (!twoDic) {
        if (callback) {
            callback(nil, XQAnalysisErrorJson2Error);
        }
        return;
    }
    
    
    // 对比key
    NSMutableSet *twoSet = [NSMutableSet setWithArray:twoDic.allKeys];
    NSMutableSet *oneSet = [NSMutableSet setWithArray:oneDic.allKeys];
    
    NSMutableSet *intersectSet = [NSMutableSet setWithArray:oneDic.allKeys];
    NSMutableSet *oneMinusSet = [NSMutableSet setWithArray:oneDic.allKeys];
    
    NSMutableSet *twoMinusSet = [NSMutableSet setWithArray:twoDic.allKeys];
    
    
    // oneSet变成交集, 获取相同的key
    [intersectSet intersectSet:twoSet];
    
    // 第一个json相比第二个json, 多出的key
    [oneMinusSet minusSet:twoSet];
    
    // 第二个json相比第一个json, 多出的key
    [twoMinusSet minusSet:oneSet];
    
    
//    self.oneMinusTView.string = [[self class] strWithSet:oneMinusSet dic:oneDic];
//    self.twoMinusTView.string = [[self class] strWithSet:twoMinusSet dic:twoDic];
    
    //    NSLog(@"\n交集:%@ \none多出key:%@, \ntwo多出key:%@", intersectSet, oneMinusSet, twoMinusSet);
    
    // 对比相同key的value
    NSMutableDictionary *oneMuDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *twoMuDic = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *equalMuDic = [NSMutableDictionary dictionary];
    
    for (NSString *key in intersectSet.allObjects) {
        // 对比类型
        if (![oneDic[key] isKindOfClass:[twoDic[key] class]]) {
            [oneMuDic addEntriesFromDictionary:@{key: oneDic[key]}];
            [twoMuDic addEntriesFromDictionary:@{key: twoDic[key]}];
            continue;
        }
        
        if ([oneDic[key] isKindOfClass:[NSDictionary class]]) {
            // 字段要做额外处理, 这里要写一个循环....
            // 不过其实一般情况来说, 要求人家自己来弄更舒服点...不然这样循环出来, 你还要去显示，也要很麻烦..
            if (![oneDic[key] isEqualToDictionary:twoDic[key]]) {
                [oneMuDic addEntriesFromDictionary:@{key: oneDic[key]}];
                [twoMuDic addEntriesFromDictionary:@{key: twoDic[key]}];
                continue;
            }
            
        }else if ([oneDic[key] isKindOfClass:[NSString class]]) {
            if (![oneDic[key] isEqualToString:twoDic[key]]) {
                [oneMuDic addEntriesFromDictionary:@{key: oneDic[key]}];
                [twoMuDic addEntriesFromDictionary:@{key: twoDic[key]}];
                continue;
            }
            
        }else if ([oneDic[key] isKindOfClass:[NSNumber class]]) {
            if (![oneDic[key] isEqualToNumber:twoDic[key]]) {
                [oneMuDic addEntriesFromDictionary:@{key: oneDic[key]}];
                [twoMuDic addEntriesFromDictionary:@{key: twoDic[key]}];
                continue;
            }
            
        }else if ([oneDic[key] isKindOfClass:[NSArray class]]) {
            if (![oneDic[key] isEqualToArray:twoDic[key]]) {
                [oneMuDic addEntriesFromDictionary:@{key: oneDic[key]}];
                [twoMuDic addEntriesFromDictionary:@{key: twoDic[key]}];
                continue;
            }
            
        }else if ([oneDic[key] isKindOfClass:[NSDate class]]) {
            if (![oneDic[key] isEqualToDate:twoDic[key]]) {
                [oneMuDic addEntriesFromDictionary:@{key: oneDic[key]}];
                [twoMuDic addEntriesFromDictionary:@{key: twoDic[key]}];
                continue;
            }
            
        }else if ([oneDic[key] isKindOfClass:[NSData class]]) {
            if (![oneDic[key] isEqualToData:twoDic[key]]) {
                [oneMuDic addEntriesFromDictionary:@{key: oneDic[key]}];
                [twoMuDic addEntriesFromDictionary:@{key: twoDic[key]}];
                continue;
            }
            
        }else {
            // 无法识别类型
            //            [oneMuDic addEntriesFromDictionary:@{key: oneDic[key]}];
            //            [twoMuDic addEntriesFromDictionary:@{key: twoDic[key]}];
            
            [equalMuDic addEntriesFromDictionary:@{[NSString stringWithFormat:@"无法识别value类型: %@", key]: oneDic[key]}];
            continue;
        }
        
        [equalMuDic addEntriesFromDictionary:@{key:oneDic[key]}];
    }
    
//    self.oneValueTView.string = [NSDictionary jsonStrWithDic:oneMuDic];
//    self.twoValueTView.string = [NSDictionary jsonStrWithDic:twoMuDic];
//
//    self.equalTView.string = [NSDictionary jsonStrWithDic:equalMuDic];
    
    if (callback) {
        XQHistoryRecord *model = [XQHistoryRecord new];
        model.json1ToJson2KeyMinus = [[self class] strWithSet:oneMinusSet dic:oneDic];
        model.json2ToJson1KeyMinus = [[self class] strWithSet:twoMinusSet dic:twoDic];
        model.json1ValueDifference = [NSDictionary jsonStrWithDic:oneMuDic];
        model.json2ValueDifference = [NSDictionary jsonStrWithDic:twoMuDic];
        model.equalJson = [NSDictionary jsonStrWithDic:equalMuDic];
        callback(model, XQAnalysisErrorSucceed);
    }
}

/**
 把Set存在的key, 然后取dic value 出来, 重组一个字典, 并转为字符串
 
 @param set key的set
 @param dic 原数据
 */
+ (NSString *)strWithSet:(NSSet *)set dic:(NSDictionary *)dic {
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    for (NSString *key in set.allObjects) {
        [muDic addEntriesFromDictionary:@{key: dic[key]}];
    }
    return [NSDictionary jsonStrWithDic:muDic];
}

/**
 过滤中文符号
 */
+ (NSString *)filterChineseSymbolWithStr:(NSString *)str {
    // 中文符号转换
    unichar c = 8221;
    NSString *strC = [NSString stringWithCharacters:&c length:1];
    
    str = [str stringByReplacingOccurrencesOfString:@"“" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:strC withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"，" withString:@","];
    str = [str stringByReplacingOccurrencesOfString:@"：" withString:@":"];
    str = [str stringByReplacingOccurrencesOfString:@"@" withString:@""];
    return str;
}

/**
 去转义
 
 @note 例如 {\"sd\":\"sd\" }
 去转义后 {"sd":"sd" }
 */
+ (NSString *)xq_removeFormatWithStr:(NSString *)str {
    NSMutableString *responseString = [NSMutableString stringWithString:str];
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"])
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
    }
    
    return responseString;
}



@end














