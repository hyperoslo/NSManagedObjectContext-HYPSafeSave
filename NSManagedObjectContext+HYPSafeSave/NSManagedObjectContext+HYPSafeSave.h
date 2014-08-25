//
//  NSManagedObjectContext+HYPSafeSave.h
//  Mine Ansatte
//
//  Created by Elvis Nunez on 8/19/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (HYPSafeSave)

- (BOOL)hyp_save:(NSError **)error;

@end
