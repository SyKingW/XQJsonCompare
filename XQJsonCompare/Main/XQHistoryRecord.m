//
//  XQHistoryRecord.m
//  XQJsonCompare
//
//  Created by WXQ on 2019/3/20.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQHistoryRecord.h"
#import <YYModel/YYModel.h>
#import <XQProjectTool/XQPredicate.h>

#define XQ_UD_Key_JsonHistoryRecord @"XQ_UD_Key_JsonHistoryRecord"

@interface XQHistoryRecord ()

@end

@implementation XQHistoryRecord

/**
 写入model
 */
+ (void)writeWithModel:(XQHistoryRecord *)model {
    if (!model) {
        return;
    }
    
    NSMutableArray *muArr = [self readAll].mutableCopy;
    [muArr insertObject:[model yy_modelToJSONString] atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:muArr forKey:XQ_UD_Key_JsonHistoryRecord];
}

/**
 删除model
 */
+ (void)deleteWithUUIDStr:(NSString *)uuidStr {
    NSMutableArray *muArr = [self readAllModels].mutableCopy;
    for (int i = 0; i < muArr.count; i++) {
        XQHistoryRecord *model = muArr[i];
        
        if (model.uuidStr.length == 0) {
            [muArr removeObject:model];
        }
        
        if ([model.uuidStr isEqualToString:uuidStr]) {
            [muArr removeObject:model];
            break;
        }
        
    }
    
    NSMutableArray *endArr = [NSMutableArray array];
    for (XQHistoryRecord *model in muArr) {
        [endArr addObject:[model yy_modelToJSONString]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:endArr forKey:XQ_UD_Key_JsonHistoryRecord];
}

/**
 删除model
 */
+ (void)deleteWithModel:(XQHistoryRecord *)model {
    [self deleteWithUUIDStr:model.uuidStr];
}

/**
 删除所有model
 */
+ (void)deleteAllModel {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XQ_UD_Key_JsonHistoryRecord];
}

/**
 读取model
 */
+ (XQHistoryRecord *)readWithUUIDStr:(NSString *)uuidStr {
    if (!uuidStr) {
        return nil;
    }
    
    NSArray *arr = [self readAllModels];
    for (XQHistoryRecord *model in arr) {
        if ([model.uuidStr isEqualToString:uuidStr]) {
            return model;
        }
    }
    return nil;
}

/**
 读取model list
 */
+ (NSArray <XQHistoryRecord *> *)readAllModels {
    NSMutableArray *muArr = [NSMutableArray array];
    NSArray *arr = [self readAll];
    
    for (NSString *str in arr) {
        [muArr addObject:[XQHistoryRecord yy_modelWithJSON:str]];
    }
    
    return muArr;
}

+ (NSArray <NSString *> *)readAll {
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:XQ_UD_Key_JsonHistoryRecord];
    if (!arr) {
        arr = [NSArray array];
    }
    return arr;
}

/**
 更新model
 */
+ (void)updateModel:(XQHistoryRecord *)model {
    if (!model || model.uuidStr.length == 0) {
        return;
    }
    
    NSMutableArray *muArr = [self readAllModels].mutableCopy;
    
    NSArray *arr = [XQPredicate predicateKeyEqWithDataArr:muArr value:model.uuidStr key:@"uuidStr"];
    if (arr.count != 1) {
        // 0 or 多个， 不处理
        return;
    }
    
    [muArr replaceObjectAtIndex:[muArr indexOfObject:arr.firstObject] withObject:model];
    
//    for (int i = 0; i < muArr.count; i++) {
//        XQHistoryRecord *m = muArr[i];
//        if ([m.uuidStr isEqualToString:model.uuidStr]) {
//            [muArr replaceObjectAtIndex:i withObject:model];
//            break;
//        }
//    }
    
    NSMutableArray *endArr = [NSMutableArray array];
    for (XQHistoryRecord *model in muArr) {
        [endArr addObject:[model yy_modelToJSONString]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:endArr forKey:XQ_UD_Key_JsonHistoryRecord];
}

@end
