//
//  XQHistoryRecord.m
//  XQJsonCompare
//
//  Created by WXQ on 2019/3/20.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQHistoryRecord.h"
#import <YYModel/YYModel.h>

#define XQ_UD_Key_JsonHistoryRecord @"XQ_UD_Key_JsonHistoryRecord"

@interface XQHistoryRecord ()

@end

@implementation XQHistoryRecord

- (instancetype)init
{
    self = [super init];
    if (self) {
        _uuidStr = [NSUUID UUID].UUIDString;
        NSLog(@"%s", __func__);
    }
    return self;
}

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

@end
