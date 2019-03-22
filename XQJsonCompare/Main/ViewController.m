//
//  ViewController.m
//  XQJsonCompare
//
//  Created by WXQ on 2019/3/19.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "ViewController.h"
#import <XQProjectTool/XQAlertSystem.h>
#import <XQProjectTool/XQOpenPanel.h>
#import <XQProjectTool/XQRegisterHotKey.h>

#import "XQHistoryCellView.h"

#import "XQJsonHandel.h"

#define XQHistoryCellView_ID @"XQHistoryCellView"

@interface ViewController () <NSTableViewDataSource, NSTableViewDelegate, XQHistoryCellViewDelegate, XQRegisterHotKeyDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTableColumn *tableColumn;

@property (unsafe_unretained) IBOutlet NSTextView *oneView;
@property (unsafe_unretained) IBOutlet NSTextView *twoView;

@property (unsafe_unretained) IBOutlet NSTextView *oneMinusTView;
@property (unsafe_unretained) IBOutlet NSTextView *twoMinusTView;

@property (unsafe_unretained) IBOutlet NSTextView *oneValueTView;
@property (unsafe_unretained) IBOutlet NSTextView *twoValueTView;
@property (unsafe_unretained) IBOutlet NSTextView *equalTView;

/** 历史记录model */
@property (nonatomic, strong) NSMutableArray <XQHistoryRecord *> *modelArr;

/** 当前页面model */
@property (nonatomic, strong) XQHistoryRecord *currentModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    
    self.tableColumn.title = @"历史记录";
    self.tableColumn.width = 240;
    self.tableColumn.maxWidth = 240;
    self.tableColumn.minWidth = 240;
    
    
    NSNib *nib = [[NSNib alloc] initWithNibNamed:@"XQHistoryCellView" bundle:nil];
    [self.tableView registerNib:nib forIdentifier:XQHistoryCellView_ID];
    
    [self getData];
    
    
    // 快捷键, 后面再规划这个吧
    [XQRegisterHotKey manager].delegate = self;
    /**
     1 -> 18
     2 -> 19
     3 -> 20
     */
    [[XQRegisterHotKey manager] xq_registerCustomHotKeyWithSignature:18 keyID:18 inHotKeyCode:18 modifiers:XQModifiersCmdKeyBit];
    [[XQRegisterHotKey manager] xq_registerCustomHotKeyWithSignature:19 keyID:19 inHotKeyCode:19 modifiers:XQModifiersCmdKeyBit];
    [[XQRegisterHotKey manager] xq_registerCustomHotKeyWithSignature:20 keyID:20 inHotKeyCode:20 modifiers:XQModifiersCmdKeyBit];
    [[XQRegisterHotKey manager] xq_registerCustomHotKeyWithSignature:21 keyID:21 inHotKeyCode:21 modifiers:XQModifiersCmdKeyBit];
}

- (void)getData {
    self.modelArr = [XQHistoryRecord readAllModels].mutableCopy;
    [self.tableView reloadData];
}

#pragma mark - respondsTo

- (IBAction)respondsToDeleteAllHistory:(id)sender {
    [XQHistoryRecord deleteAllModel];
    [self getData];
}

- (IBAction)respondsToOutResult:(id)sender {
    if (!self.currentModel) {
        [XQAlertSystem alertSheetWithTitle:@"当前页面没有运算结果" message:@"" contentArr:@[@"确定"] callback:nil];
        return;
    }
    [[self class] outWithModel:self.currentModel window:self.view.window];
}

- (IBAction)respondsToRemoveFormat:(id)sender {
    self.oneView.string = [XQJsonHandel xq_removeFormatWithStr:self.oneView.string];
    self.twoView.string = [XQJsonHandel xq_removeFormatWithStr:self.twoView.string];
}

- (IBAction)respondsToRemoveChinese:(id)sender {
    self.oneView.string = [XQJsonHandel filterChineseSymbolWithStr:self.oneView.string];
    self.twoView.string = [XQJsonHandel filterChineseSymbolWithStr:self.twoView.string];
}

- (IBAction)respondsToAnalysis:(id)sender {
    [XQJsonHandel modelWithJson1:self.oneView.string json2:self.twoView.string callback:^(XQHistoryRecord *model, XQAnalysisError error) {
        
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
                model.uuidStr = [NSUUID UUID].UUIDString;
                model.createDate = [NSDate date];
                model.updateDate = model.createDate;
                
                [self reloadViewWithModel:model];
                
                [XQHistoryRecord writeWithModel:model];
                [self.modelArr insertObject:model atIndex:0];
                
                [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:NSTableViewAnimationSlideLeft];
            }
                break;
                
            default:
                break;
        }
        
    }];
}

- (void)reloadViewWithModel:(XQHistoryRecord *)model {
    self.currentModel = model;
    
    self.oneMinusTView.string = model.json1ToJson2KeyMinus;
    self.twoMinusTView.string = model.json2ToJson1KeyMinus;
    
    self.oneValueTView.string = model.json1ValueDifference;
    self.twoValueTView.string = model.json2ValueDifference;
    
    self.equalTView.string = model.equalJson;
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSLog(@"%s", __func__);
    return self.modelArr.count;
}

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    XQHistoryCellView *view = [tableView viewAtColumn:0 row:row makeIfNecessary:YES];
    if (!view) {
        // 发现一直不会去释放这些view....不知道持有机制到底在哪
        view = [tableView makeViewWithIdentifier:XQHistoryCellView_ID owner:nil];
    }
    
    XQHistoryRecord *model = self.modelArr[row];
    
    view.nameTF.stringValue = model.name ? model.name : @"";
    view.timeTF.stringValue = [[self class] date2Str:model.createDate];
    view.delegate = self;
    
    return view;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 100;
}


#pragma mark - XQHistoryCellViewDelegate

// 查看
- (void)historyCellView:(XQHistoryCellView *)historyCellView tapView:(NSButton *)sender {
    NSInteger row = [self.tableView rowForView:historyCellView];
    XQHistoryRecord *model = self.modelArr[row];
    
    self.oneView.string = model.json1 ? model.json1 : @"";
    self.twoView.string = model.json2 ? model.json2 : @"";
    [self reloadViewWithModel:model];
}

// 导出
- (void)historyCellView:(XQHistoryCellView *)historyCellView tapOut:(NSButton *)sender {
    NSInteger row = [self.tableView rowForView:historyCellView];
    XQHistoryRecord *model = self.modelArr[row];
    [[self class] outWithModel:model window:self.view.window];
}

// 删除
- (void)historyCellView:(XQHistoryCellView *)historyCellView tapDelete:(NSButton *)sender {
    NSInteger row = [self.tableView rowForView:historyCellView];
    XQHistoryRecord *model = self.modelArr[row];
    [XQHistoryRecord deleteWithModel:model];
    [self.modelArr removeObject:model];
    [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationSlideLeft];
}

// name改变
- (void)historyCellView:(XQHistoryCellView *)historyCellView nameTextDidChange:(NSTextField *)nameTF {
    NSInteger row = [self.tableView rowForView:historyCellView];
    XQHistoryRecord *model = self.modelArr[row];
    model.name = nameTF.stringValue ? nameTF.stringValue : @"";
    [XQHistoryRecord updateModel:model];
}

#pragma mark - XQRegisterHotKeyDelegate

- (void)hotKeyHandlerWithSignature:(UInt32)signature keyID:(UInt32)keyID {
    switch (signature) {
        case 18:{
            [self respondsToAnalysis:nil];
        }
            break;
            
        case 19:{
            [self respondsToOutResult:nil];
        }
            break;
            
        case 20:{
            [self respondsToRemoveFormat:nil];
        }
            break;
            
        case 21:{
            [self respondsToRemoveChinese:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Other Method

/**
 把数据转成文件, 然后放到用户选择的路径下
 */
+ (void)outWithModel:(XQHistoryRecord *)model window:(NSWindow *)window {
    if (!model) {
        return;
    }
    
    [XQOpenPanel beginSheetModalWithWindow:window openCallback:^(NSString *path) {
        // 路径
        NSString *name = [NSString stringWithFormat:@"%@_%@.md", @"xqJC", [[self class] date2Str:model.createDate ? model.createDate : [NSDate date]]];
        path = [path stringByAppendingPathComponent:name];
        
        // 数据
        NSString *dataStr = [NSString stringWithFormat:@""
                             "%@  \n\n"// 目录
                             "%@  \n"
                             "%@  \n"
                             "%@  \n"
                             "%@  \n"
                             "%@  \n"
                             "\n\n"
                             
                             "%@  \n\n"// 基础数据
                             "%@  \n%@  \n\n"
                             "%@  \n%@  \n\n"
                             "%@  \n%@  \n\n"
                             "%@  \n%@  \n\n"
                             "%@  \n%@  \n\n"
                             "\n\n"
                             
                             "%@  \n\n"// 原数据
                             "%@  \n\n```json  \n%@\n```  \n\n"
                             "%@  \n\n```json  \n%@\n```  \n\n"
                             "\n\n"
                             
                             "%@  \n\n"// 多余key
                             "%@  \n\n```json  \n%@\n```  \n\n"
                             "%@  \n\n```json  \n%@\n```  \n\n"
                             "\n\n"
                             
                             "%@  \n\n"// 同k不同v
                             "%@  \n\n```json  \n%@\n```  \n\n"
                             "%@  \n\n```json  \n%@\n```  \n\n"
                             "\n\n"
                             
                             "%@  \n\n"// 同k同v
                             "%@  \n\n```json  \n%@\n```  \n\n"
                             "\n\n",
                             
                             @"# 目录",
                             @"- [基础数据](#基础数据)",
                             @"- [原数据](#原数据)",
                             @"- [多余Key](#多余Key)",
                             @"- [同Key不同Value](#同Key不同Value)",
                             @"- [同key同Value](#同key同Value)",
                             
                             @"# 基础数据",
                             @"* 名称", model.name,
                             @"* 唯一id", model.uuidStr,
                             @"* 创建日期", model.createDate,
                             @"* 更新日期", model.updateDate,
                             @"* 详细描述", model.note,
                             
                             @"# 原数据",
                             @"* json1  ", model.json1,
                             @"* json2  ", model.json2,
                             
                             @"# 多余Key",
                             @"* json1 比 json2 多的 key  ", model.json1ToJson2KeyMinus,
                             @"* json2 比 json1 多的 key  ", model.json2ToJson1KeyMinus,
                             
                             @"# 同Key不同Value",
                             @"* json1和json2不同的value", model.json1ValueDifference,
                             @"* json2和json1不同的value", model.json2ValueDifference,
                             
                             @"# 同key同Value",
                             @"* 同Key同Value", model.equalJson
                             
                             ];
        
        
        
        BOOL succeed = [[NSFileManager defaultManager] createFileAtPath:path contents:[dataStr dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        if (!succeed) {
            [XQAlertSystem alertSheetWithTitle:@"写入失败" message:@"" contentArr:@[@"确定"] callback:nil];
        }
        
    } cancelCallback:nil];
}

+ (NSString *)date2Str:(NSDate *)date {
    if (!date) {
        return @"不存在日期";
    }
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    return [f stringFromDate:date];
}


@end














