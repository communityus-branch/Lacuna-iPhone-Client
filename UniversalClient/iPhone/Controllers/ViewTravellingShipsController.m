//
//  ViewTravellingShipsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewTravellingShipsController.h"
#import "LEMacros.h"
#import "Util.h"
#import	"SpacePort.h"
#import "Ship.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellShip.h"
#import "LETableViewCellTravellingShip.h"


typedef enum {
	ROW_SHIP_INFO,
	ROW_TRAVELLING_INFO
} ROW;


@interface ViewTravellingShipsController (PrivateMethods)

- (void)togglePageButtons;

@end


@implementation ViewTravellingShipsController


@synthesize pageSegmentedControl;
@synthesize spacePort;
@synthesize lastUpdated;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Ships In Transit";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.pageSegmentedControl = [[[UISegmentedControl alloc] initWithItems:_array(UP_ARROW_ICON, DOWN_ARROW_ICON)] autorelease];
	[self.pageSegmentedControl addTarget:self action:@selector(switchPage) forControlEvents:UIControlEventValueChanged]; 
	self.pageSegmentedControl.momentary = YES;
	self.pageSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.pageSegmentedControl] autorelease];
	self.navigationItem.rightBarButtonItem = rightBarButtonItem; 
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.spacePort addObserver:self forKeyPath:@"travellingShipsUpdated" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.spacePort.travellingShips) {
		[self.spacePort loadTravellingShipsForPage:1];
	} else {
		if (self.lastUpdated) {
			if ([self.lastUpdated compare:self.spacePort.travellingShipsUpdated] == NSOrderedAscending) {
				[self.tableView reloadData];
				self.lastUpdated = self.spacePort.travellingShipsUpdated;
			}
		} else {
			self.lastUpdated = self.spacePort.travellingShipsUpdated;
		}
	}

	[self togglePageButtons];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.spacePort removeObserver:self forKeyPath:@"travellingShipsUpdated"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.spacePort && self.spacePort.travellingShips) {
		if ([self.spacePort.travellingShips count] > 0) {
			return [self.spacePort.travellingShips count];
		} else {
			return 1;
		}

	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.spacePort && self.spacePort.travellingShips) {
		if ([self.spacePort.travellingShips count] > 0) {
			return 2;
		} else {
			return 1;
		}
		
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.spacePort && self.spacePort.travellingShips) {
		if ([self.spacePort.travellingShips count] > 0) {
			switch (indexPath.row) {
				case ROW_SHIP_INFO:
					return [LETableViewCellShip getHeightForTableView:tableView];
					break;
				case ROW_TRAVELLING_INFO:
					return [LETableViewCellTravellingShip getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
					break;
			}
		} else {
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
		}

	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	if (self.spacePort && self.spacePort.travellingShips) {
		if ([self.spacePort.travellingShips count] > 0) {
			Ship *currentShip = [self.spacePort.travellingShips objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_SHIP_INFO:
					; //DO NOT REMOVE
					LETableViewCellShip *shipInfoCell = [LETableViewCellShip getCellForTableView:tableView isSelectable:NO];
					[shipInfoCell setShip:currentShip];
					cell = shipInfoCell;
					break;
				case ROW_TRAVELLING_INFO:
					; //DO NOT REMOVE
					LETableViewCellTravellingShip *travellingInfoCell = [LETableViewCellTravellingShip getCellForTableView:tableView];
					[travellingInfoCell setShip:currentShip];
					cell = travellingInfoCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			loadingCell.label.text = @"In Transit";
			loadingCell.content.text = @"None";
			cell = loadingCell;
		}

	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.pageSegmentedControl = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.pageSegmentedControl = nil;
	self.spacePort = nil;
	self.lastUpdated = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void) switchPage {
	switch (self.pageSegmentedControl.selectedSegmentIndex) {
		case 0:
			[self.spacePort loadTravellingShipsForPage:(self.spacePort.travellingShipsPageNumber-1)];
			break;
		case 1:
			[self.spacePort loadTravellingShipsForPage:(self.spacePort.travellingShipsPageNumber+1)];
			break;
		default:
			NSLog(@"Invalid switchPage");
			break;
	}
}


#pragma mark -
#pragma mark Private Methods

- (void)togglePageButtons {
	[self.pageSegmentedControl setEnabled:[self.spacePort hasPreviousTravellingShipsPage] forSegmentAtIndex:0];
	[self.pageSegmentedControl setEnabled:[self.spacePort hasNextTravellingShipsPage] forSegmentAtIndex:1];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewTravellingShipsController *)create {
	return [[[ViewTravellingShipsController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"travellingShipsUpdated"]) {
		[self togglePageButtons];
		[self.tableView reloadData];
		self.lastUpdated = self.spacePort.travellingShipsUpdated;
	}
}


@end

