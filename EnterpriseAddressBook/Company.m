//
//  Company.m
//  Company
//
//  Created by admin on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Company.h"

@implementation Company
@synthesize companyID = _companyID;
@synthesize companyName = _companyName;

- (void)dealloc {
  [self.companyID release];
  [self.companyName release];
  
  [super dealloc];
}
@end
