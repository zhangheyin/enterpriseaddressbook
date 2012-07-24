//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by joeconway on 9/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CallRecordCell.h"

@implementation CallRecordCell

@synthesize main_lable = _main_lable;
@synthesize dial_time_lable = _dial_time_lable;
@synthesize number_lable = _number_lable;
@synthesize picView = _picView;

@synthesize main = _main;
@synthesize dialTime = _dialTime;
@synthesize number = _number;
@synthesize image = _image;

- (void) setMain:(NSString *)aMain
{
  if (![aMain isEqualToString:_main]) {
    _main = [aMain copy];
    self.main_lable.text = _main;
  }
}

- (void)setDialTime:(NSString *)aDialTime
{
  if (![aDialTime isEqualToString:_dialTime]) {
    _dialTime = [aDialTime copy];
    self.dial_time_lable.text = _dialTime;
  }
}

- (void)setImage:(UIImage *) aImage
{
  if (![aImage isEqual:_image]) {
    _image = [aImage copy];
    self.picView.image = _image;
  }   
}

- (void)setNumber:(NSString *) aNumber
{
  if (![aNumber isEqualToString:_number]) {
    _number = [aNumber copy];
    self.number_lable.text = _number;
  }
}
//@synthesize controller;
//@synthesize tableView;
/*
 - (IBAction)showImage:(id)sender 
 {
 NSString *selector = NSStringFromSelector(_cmd);
 selector = [selector stringByAppendingString:@"atIndexPath:"];
 SEL newSelector = NSSelectorFromString(selector);
 
 NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
 if(indexPath) {
 if([controller respondsToSelector:newSelector]) {
 [controller performSelector:newSelector withObject:sender 
 withObject:indexPath];
 }
 }
 }*/
- (void)dealloc {
  [_picView release];
  [_main_lable release];
  [_number_lable release];
  [_dial_time_lable release];
  [self.image release];
  [self.main release];
  [self.number release];
  [self.dialTime release];
  
  [super dealloc];
}
@end
