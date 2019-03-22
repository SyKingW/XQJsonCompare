//
//  XQHistoryCellView.h
//  XQJsonCompare
//
//  Created by WXQ on 2019/3/21.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XQTextField.h"

@class XQHistoryCellView;

@protocol XQHistoryCellViewDelegate <NSObject>

- (void)historyCellView:(XQHistoryCellView *)historyCellView tapView:(NSButton *)sender;
- (void)historyCellView:(XQHistoryCellView *)historyCellView tapOut:(NSButton *)sender;
- (void)historyCellView:(XQHistoryCellView *)historyCellView tapDelete:(NSButton *)sender;

- (void)historyCellView:(XQHistoryCellView *)historyCellView nameTextDidChange:(NSTextField *)nameTF;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XQHistoryCellView : NSView

@property (weak) IBOutlet XQTextField *nameTF;
@property (weak) IBOutlet NSTextField *timeTF;

/** <#note#> */
@property (nonatomic, weak) id <XQHistoryCellViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
