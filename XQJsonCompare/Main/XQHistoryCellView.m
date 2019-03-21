//
//  XQHistoryCellView.m
//  XQJsonCompare
//
//  Created by WXQ on 2019/3/21.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQHistoryCellView.h"

@interface XQHistoryCellView ()

@end

@implementation XQHistoryCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_textChange:) name:NSTextDidChangeNotification object:nil];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
}

#pragma mark - responds

- (IBAction)respondsToView:(id)sender {
    [self.delegate historyCellView:self tapView:sender];
}

- (IBAction)respondsToOut:(id)sender {
    [self.delegate historyCellView:self tapOut:sender];
}

- (IBAction)respondsToDelete:(id)sender {
    [self.delegate historyCellView:self tapDelete:sender];
}

#pragma mark - Notification

- (void)notification_textChange:(NSNotification *)notification {
    [self.delegate historyCellView:self nameTextDidChange:self.nameTF];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
