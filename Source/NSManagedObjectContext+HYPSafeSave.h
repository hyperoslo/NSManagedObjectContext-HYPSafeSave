@import CoreData;

@interface NSManagedObjectContext (HYPSafeSave)

- (BOOL)hyp_save:(NSError * __autoreleasing *)error;

@end
