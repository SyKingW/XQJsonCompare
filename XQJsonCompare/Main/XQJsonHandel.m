//
//  XQJsonHandel.m
//  XQJsonCompare
//
//  Created by WXQ on 2019/3/21.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQJsonHandel.h"

@implementation XQJsonHandel

#pragma mark - Other Method

+ (void)modelWithJson1:(NSString *)json1 json2:(NSString *)json2 callback:(void(^)(XQHistoryRecord *model, XQAnalysisError error))callback {
    if (json1.length == 0 || json2.length == 0) {
        if (callback) {
            callback(nil, XQAnalysisErrorNil);
        }
        NSLog(@"数据空");
        return;
    }
    
    NSDictionary *oneDic = [NSDictionary dictionaryWithJsonString:json1];
    if (!oneDic) {
        if (callback) {
            callback(nil, XQAnalysisErrorJson1Error);
        }
        NSLog(@"数据1错误");
        return;
    }
    
    NSDictionary *twoDic = [NSDictionary dictionaryWithJsonString:json2];
    if (!twoDic) {
        if (callback) {
            callback(nil, XQAnalysisErrorJson2Error);
        }
        NSLog(@"数据2错误");
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
    
    //    NSLog(@"\n交集:%@ \none多出key:%@, \ntwo多出key:%@", intersectSet, oneMinusSet, twoMinusSet);
    
    // 不同k
    NSMutableDictionary *oneMinusDic = [self dicWithSet:oneMinusSet dic:oneDic].mutableCopy;
    NSMutableDictionary *twoMinusDic = [self dicWithSet:twoMinusSet dic:twoDic].mutableCopy;
    
    // 相同k不同v
    NSMutableDictionary *oneMuDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *twoMuDic = [NSMutableDictionary dictionary];
    
    // 同k同v
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
//                [oneMuDic addEntriesFromDictionary:@{key: oneDic[key]}];
//                [twoMuDic addEntriesFromDictionary:@{key: twoDic[key]}];
                
                
                [self modelWithJson1:[oneDic[key] yy_modelToJSONString] json2:[twoDic[key] yy_modelToJSONString] callback:^(XQHistoryRecord * _Nonnull model, XQAnalysisError error) {
                    
                    NSDictionary *json1ToJson2KeyMinus = [NSDictionary dictionaryWithJsonString:model.json1ToJson2KeyMinus];
                    if (json1ToJson2KeyMinus.allKeys.count != 0) {
                        [oneMinusDic addEntriesFromDictionary:@{key: json1ToJson2KeyMinus}];
                    }
                    
                    NSDictionary *json2ToJson1KeyMinus = [NSDictionary dictionaryWithJsonString:model.json2ToJson1KeyMinus];
                    if (json2ToJson1KeyMinus.allKeys.count != 0) {
                        [twoMinusDic addEntriesFromDictionary:@{key: json2ToJson1KeyMinus}];
                    }
                    
                    NSDictionary *json1ValueDifference = [NSDictionary dictionaryWithJsonString:model.json1ValueDifference];
                    if (json1ValueDifference.allKeys.count != 0) {
                        [oneMuDic addEntriesFromDictionary:@{key: json1ValueDifference}];
                    }
                    
                    NSDictionary *json2ValueDifference = [NSDictionary dictionaryWithJsonString:model.json2ValueDifference];
                    if (json2ValueDifference.allKeys.count != 0) {
                        [twoMuDic addEntriesFromDictionary:@{key: json2ValueDifference}];
                    }
                    
                    NSDictionary *equalJson = [NSDictionary dictionaryWithJsonString:model.equalJson];
                    if (equalJson.allKeys.count != 0) {
                        [equalMuDic addEntriesFromDictionary:@{key: equalJson}];
                    }
                    
                }];
                
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
        model.json1 = json1;
        model.json2 = json2;
        model.json1ToJson2KeyMinus = [NSDictionary jsonStrWithDic:oneMinusDic];
        model.json2ToJson1KeyMinus = [NSDictionary jsonStrWithDic:twoMinusDic];
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
    return [NSDictionary jsonStrWithDic:[self dicWithSet:set dic:dic]];
}

+ (NSDictionary *)dicWithSet:(NSSet *)set dic:(NSDictionary *)dic {
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    for (NSString *key in set.allObjects) {
        [muDic addEntriesFromDictionary:@{key: dic[key]}];
    }
    return muDic;
}

/**
 过滤中文符号
 */
+ (NSString *)filterChineseSymbolWithStr:(NSString *)str {
    if (str.length == 0) {
        return @"";
    }
    
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
