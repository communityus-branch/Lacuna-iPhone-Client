//
//  SelectPlanController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class BaseTradeBuilding;


@interface SelectPlanController : LETableViewControllerGrouped {
	BaseTradeBuilding *baseTradeBuilding;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;


+ (SelectPlanController *) create;


@end
