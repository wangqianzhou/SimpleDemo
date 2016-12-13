//
//  CollectionViewCell.h
//  SimpleDemo
//
//  Created by wangqianzhou on 22/11/2016.
//  Copyright © 2016 wangqianzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef const struct AuthorizationOpaqueRef* AuthorizationRef;
typedef const struct __SCPreferences* SCPreferencesRef;
SCPreferencesRef SCPreferencesCreateWithAuthorization(CFAllocatorRef allocator, CFStringRef name, CFStringRef prefsID, AuthorizationRef authorization);

@interface CollectionViewCell : UICollectionViewCell

@end
