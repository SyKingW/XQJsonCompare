//
//  XQHistoryRecord.h
//  XQJsonCompare
//
//  Created by WXQ on 2019/3/20.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQHistoryRecord : NSObject

/** 唯一id */
@property (nonatomic, copy) NSString *uuidStr;

/** 创建时间 */
@property (nonatomic, copy) NSDate *createDate;
/** 更新时间 */
@property (nonatomic, copy) NSDate *updateDate;

/** 数据1 */
@property (nonatomic, copy) NSString *json1;
/** 数据2 */
@property (nonatomic, copy) NSString *json2;

/** json1 比 json2 多的 key */
@property (nonatomic, copy) NSString *json1ToJson2KeyMinus;
/** json2 比 json1 多的 key */
@property (nonatomic, copy) NSString *json2ToJson1KeyMinus;

/** json1和json2不同的value */
@property (nonatomic, copy) NSString *json1ValueDifference;
/** json2和json1不同的value */
@property (nonatomic, copy) NSString *json2ValueDifference;

/** json1和json2 同key 同value */
@property (nonatomic, copy) NSString *equalJson;

/**  */
@property (nonatomic, copy) NSString *name;
/**  */
@property (nonatomic, copy) NSString *note;

/**
 写入model
 */
+ (void)writeWithModel:(XQHistoryRecord *)model;

/**
 删除model
 */
+ (void)deleteWithUUIDStr:(NSString *)uuidStr;

/**
 删除model
 */
+ (void)deleteWithModel:(XQHistoryRecord *)model;

/**
 读取model
 */
+ (XQHistoryRecord *)readWithUUIDStr:(NSString *)uuidStr;

/**
 读取model list
 */
+ (NSArray <XQHistoryRecord *> *)readAllModels;

/**
 更新model
 */
+ (void)updateModel:(XQHistoryRecord *)model;


@end

NS_ASSUME_NONNULL_END
