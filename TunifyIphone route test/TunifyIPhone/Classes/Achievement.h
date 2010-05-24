//
//  Achievement.h
//  TunifyIPhone
//
//  Created by Elegia on 11/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Achievement :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * completion;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * date;

@end
