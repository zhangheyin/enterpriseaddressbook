//
//  ContactItemCell.h
//  Homepwner
//
//  Created by joeconway on 9/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactItemCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (retain, nonatomic) IBOutlet UILabel *name_lable;
@property (retain, nonatomic) IBOutlet UILabel *number_lable;
@property (retain, nonatomic) IBOutlet UILabel *pinyin_lable;


@property (copy, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *number;
@property (copy, nonatomic) NSString *pinyin;
//@property (weak, nonatomic) id controller;
//@property (weak, nonatomic) UITableView *tableView;
//- (IBAction)showImage:(id)sender;

@end
