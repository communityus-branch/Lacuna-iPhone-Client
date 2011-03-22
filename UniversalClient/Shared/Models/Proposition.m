//
//  Proposition.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/21/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "Proposition.h"
#import "LEMacros.h"
#import	"Util.h"


@implementation Proposition


@synthesize id;
@synthesize name;
@synthesize description;
@synthesize votesNeeded;
@synthesize votesYes;
@synthesize votesNo;
@synthesize status;
@synthesize dateEnds;
@synthesize proposedById;
@synthesize proposedByName;
@synthesize myVote;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.description = nil;
	self.votesNeeded = nil;
	self.votesYes = nil;
	self.votesNo = nil;
	self.status = nil;
	self.dateEnds = nil;
	self.proposedById = nil;
	self.proposedByName = nil;
	self.myVote = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, description:%@, votesNeeded:%@, votesYes:%@, votesNo:%@, status:%@, dateEnds:%@, proposedById:%@, proposedByName:%@, myVote:%@",
        self.id, self.name, self.description, self.votesNeeded, self.votesYes, self.votesNo, self.status, self.dateEnds, self.proposedById, self.proposedByName, self.myVote];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.id = [Util idFromDict:data named:@"id"];
	self.name = [data objectForKey:@"name"];
	self.description = [data objectForKey:@"description"];
	self.votesNeeded = [Util asNumber:[data objectForKey:@"votes_needed"]];
	self.votesYes = [Util asNumber:[data objectForKey:@"votes_yes"]];
	self.votesNo = [Util asNumber:[data objectForKey:@"votes_no"]];
	self.status = [data objectForKey:@"status"];
	self.dateEnds = [Util date:[data objectForKey:@"date_ends"]];
	self.proposedById = [data objectForKey:@"proposed_by_id"];
	self.proposedByName = [data objectForKey:@"proposed_by_name"];
	self.myVote = [Util asNumber:[data objectForKey:@"my_vote"]];
}


@end
