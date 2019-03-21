//
//  XQJCAboutVC.m
//  XQJsonCompare
//
//  Created by WXQ on 2019/3/21.
//  Copyright © 2019 WXQ. All rights reserved.
//

#import "XQJCAboutVC.h"

@interface XQJCAboutVC ()

@property (weak) IBOutlet NSTextField *githubTF;

@end

@implementation XQJCAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    // @property IBOutlet NSTextField *tf;
//    [self.githubTF setAllowsEditingTextAttributes: YES];
//    [self.githubTF setSelectable:YES];
//    NSString *credits = @"Visit our <a href=\"https://github.com/SyKingW/XQJsonCompare/releases\">open baidu</a>";
//    [self.githubTF setAttributedStringValue:[self stringFromHTML:credits withFont:[self.githubTF font]]];
    
    
    // 超链接
    NSString *str = @"GitHub App更新地址";
    NSMutableAttributedString *mAStr = [[NSMutableAttributedString alloc] initWithString:str];
    [mAStr addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"https://github.com/SyKingW/XQJsonCompare/releases"] range:NSMakeRange(0, str.length)];
    [self.githubTF setAttributedStringValue:mAStr];
    
    self.githubTF.selectable = YES;
    self.githubTF.allowsEditingTextAttributes = YES;
    
}

@end
