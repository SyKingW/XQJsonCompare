//
//  XQJsonHandel.h
//  XQJsonCompare
//
//  Created by WXQ on 2019/3/21.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQHistoryRecord.h"
#import <YYModel/YYModel.h>
#import <XQProjectTool/NSDictionary+XQJson.h>

typedef NS_ENUM(NSInteger, XQAnalysisError) {
    XQAnalysisErrorNil = 0,
    XQAnalysisErrorSucceed,
    XQAnalysisErrorJson1Error,
    XQAnalysisErrorJson2Error,
};

NS_ASSUME_NONNULL_BEGIN

@interface XQJsonHandel : NSObject

+ (void)modelWithJson1:(NSString *)json1 json2:(NSString *)json2 callback:(void(^)(XQHistoryRecord *model, XQAnalysisError error))callback;

/**
 过滤中文符号
 */
+ (NSString *)filterChineseSymbolWithStr:(NSString *)str;

/**
 去转义
 
 @note 例如 {\"sd\":\"sd\" }
 去转义后 {"sd":"sd" }
 */
+ (NSString *)xq_removeFormatWithStr:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
