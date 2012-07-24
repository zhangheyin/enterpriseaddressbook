//
//  ContactItemCell.m
//  Homepwner
//
//  Created by joeconway on 9/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactItemCell.h"

@implementation ContactItemCell

@synthesize name_lable = _name_lable;
//@synthesize pinyin_lable = _pinyin_lable;
@synthesize number_lable = _number_lable;
@synthesize thumbnailView = _thumbnailView;

@synthesize name = _name;
//@synthesize pinyin = _pinyin;
@synthesize number = _number;
@synthesize image = _image;

- (void) setName:(NSString *)aName
{
    if (![aName isEqualToString:_name]) {
        _name = [aName copy];
        self.name_lable.text = _name;
    }
}

//- (void)setPinyin:(NSString *)aPinyin
//{
//    if (![aPinyin isEqualToString:_pinyin]) {
//        _pinyin = [aPinyin copy];
//        self.pinyin_lable.text = _pinyin;
//    }
//}

- (void)setImage:(UIImage *) aImage
{
    if (![aImage isEqual:_image]) {
        _image = [aImage copy];
        self.thumbnailView.image = _image;
    }   
}

- (void)setNumber:(NSString *) aNumber
{
    if (![aNumber isEqual:self.name]) {
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
    [_thumbnailView release];
    [_name_lable release];
    [_number_lable release];
  //  [_pinyin_lable release];
    [super dealloc];
}
@end
