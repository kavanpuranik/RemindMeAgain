//
//  LoginStartup.h
//  RemindMeAgain
//
//  Created by Kavan Puranik on 7/27/13.
//  Copyright (c) 2013 Kavan Puranik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginStartupDelegate : NSObject

- (void) enable;

- (void) disable;

- (BOOL) isEnabled;
@end
