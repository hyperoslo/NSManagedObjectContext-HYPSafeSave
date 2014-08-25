//
//  HYPAppDelegate.h
//  Demo
//
//  Created by Elvis Nunez on 25/08/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
