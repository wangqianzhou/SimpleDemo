//
//  CollectionReusableView.m
//  SimpleDemo
//
//  Created by wangqianzhou on 22/11/2016.
//  Copyright © 2016 wangqianzhou. All rights reserved.
//

#import "CollectionReusableView.h"

@implementation CollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.borderColor = [[UIColor greenColor] CGColor];
        self.layer.borderWidth = 1;
    }
    
    return self;
}

@end
