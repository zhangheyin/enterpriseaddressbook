//
//  EnterpriseNameViewController.h
//  TestSQLite
//
//  Created by admin on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterpriseNameDatabase.h"
@interface EnterpriseNameViewController : UIViewController
@property (nonatomic, retain) EnterpriseNameDatabase *enterpriseDatabase;
@property (nonatomic, retain) NSMutableArray *enterprise_array;
@property (retain, nonatomic) IBOutlet UITableView *tableView;


@end
