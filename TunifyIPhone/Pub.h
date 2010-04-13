//
//  Pub.h
//  TunifyIPhone
//
//  Created by Maarten on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Pub :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * rating;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * zipcode;

@end



