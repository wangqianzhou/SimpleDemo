//
//  CollectionViewCell.m
//  SimpleDemo
//
//  Created by wangqianzhou on 22/11/2016.
//  Copyright © 2016 wangqianzhou. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.borderColor = [[UIColor redColor] CGColor];
        self.layer.borderWidth = 1;
    }
    
    return self;
}

@end
