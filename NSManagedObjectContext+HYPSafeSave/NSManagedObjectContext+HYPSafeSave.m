//
//  NSManagedObjectContext+HYPSafeSave.m
//  Mine Ansatte
//
//  Created by Elvis Nunez on 8/19/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "NSManagedObjectContext+HYPSafeSave.h"

@implementation NSManagedObjectContext (HYPSafeSave)

- (BOOL)hyp_save:(NSError **)error
{
#if DEBUG
    BOOL wasMainThread = [NSThread isMainThread];

    [self performBlockAndWait:^{
        NSThread *currentThread = [NSThread currentThread];

        if (wasMainThread) {
            if (![currentThread isEqual:[NSThread mainThread]]) {
                [NSException raise:@"REMA_MAIN_THREAD_SAVING_EXCEPTION"
                            format:@"Main context saved in a background thread."];
            }
        } else {
            if ([currentThread isEqual:[NSThread mainThread]]) {
                [NSException raise:@"REMA_BACKGROUND_THREAD_SAVING_EXCEPTION"
                            format:@"Background context saved in a main thread."];
            }
        }
    }];
#endif
    return [self save:error];
}

@end
