//
//  CustomView.m
//  EnterpriseAddressBook
//
//  Created by admin on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView
//@synthesize layer = _layer;
- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    CGColorRef color;
    
    UIView *contentView = self;//[[self window] contentView];
    CALayer *rootLayer = [CALayer layer];
    color = [UIColor blackColor].CGColor;//CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1.0);
    [rootLayer setBackgroundColor:color];
    //[contentView 
    // [contentView setWantsLayer:YES];
    [[contentView layer] insertSublayer:rootLayer atIndex:0];
    //self.layer = [CALayer layer];
    color =[UIColor grayColor].CGColor;// CGColorCreateGenericRGB(0.5f, 0.5f, 0.5f, 1.0f);
    [self.layer setBackgroundColor:color];
    
    [self.layer setCornerRadius:5.0f];
    
    color =[UIColor whiteColor].CGColor;// CGColorCreateGenericRGB(0.0f, 1.0f, 0.0f, 1.0f);
    [self.layer setBorderColor:color];
    [self.layer setBorderWidth:2.0f];
    
    [self.layer setBounds:CGRectMake(0, 0, 100, 100)];
    [self.layer setPosition:CGPointMake(55, 55)];
    
    [rootLayer addSublayer:self.layer];
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
