# NSManagedObjectContext-HYPSafeSave

[![CI Status](http://img.shields.io/travis/hyperoslo/NSManagedObjectContext-HYPSafeSave.svg?style=flat)](https://travis-ci.org/hyperoslo/NSManagedObjectContext-HYPSafeSave)
[![Version](https://img.shields.io/cocoapods/v/NSManagedObjectContext-HYPSafeSave.svg?style=flat)](http://cocoadocs.org/docsets/NSManagedObjectContext-HYPSafeSave)
[![License](https://img.shields.io/cocoapods/l/NSManagedObjectContext-HYPSafeSave.svg?style=flat)](http://cocoadocs.org/docsets/NSManagedObjectContext-HYPSafeSave)
[![Platform](https://img.shields.io/cocoapods/p/NSManagedObjectContext-HYPSafeSave.svg?style=flat)](http://cocoadocs.org/docsets/NSManagedObjectContext-HYPSafeSave)

When doing `[context save:&error]` warns you about:

- Usage of confinement contexts
- Main context saved
- Background context saved in a main thread

## Usage

```objc
- (BOOL)hyp_save:(NSError * __autoreleasing *)error;
```

## Installation

**NSManagedObjectContext-HYPSafeSave** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NSManagedObjectContext-HYPSafeSave', '~> 0.3'
```

## Author

Hyper AS, teknologi@hyper.no

## License

**NSManagedObjectContext-HYPSafeSave** is available under the MIT license. See the LICENSE file for more info.
