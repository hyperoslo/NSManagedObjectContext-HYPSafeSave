@import CoreData;

static NSString * const HYPSafeSaveNotRecommendedConcurrencyTypeException = @"HYPSafeSave_NOT_RECOMENDED_CONCURRENCY_TYPE";
static NSString * const HYPSafeSaveMainThreadSavedInDifferentThreadException = @"HYPSafeSave_MAIN_THREAD_SAVING_EXCEPTION";
static NSString * const HYPSafeSaveBackgroundThreadSavedInMainThreadException = @"HYPSafeSave_BACKGROUND_THREAD_SAVING_EXCEPTION";

@interface NSManagedObjectContext (HYPSafeSave)

- (BOOL)hyp_save:(NSError * __autoreleasing *)error;

@end
