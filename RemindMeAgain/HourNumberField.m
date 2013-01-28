//
//  HourNumberField.m
//  RemindMeAgain
//
//  Created by Kavan Puranik on 1/27/13.
//  Copyright (c) 2013 Kavan Puranik. All rights reserved.
//

#import "HourNumberField.h"

@implementation HourNumberField

-(void) textDidChange:(NSNotification *)aNotification {
    
    NSString* value = [self stringValue];
    if ([value length] > 2) {        
        [self setStringValue:[[value uppercaseString] substringFromIndex:[value length] - 1]];
    } else {
        [self setStringValue:[value uppercaseString]];
    }
    
	[self setIntValue:[self intValue]];

    int hourValue = [self intValue];
    if (hourValue > 23){
        [self setStringValue:[[[self stringValue] uppercaseString] substringWithRange:NSMakeRange(0, 1)]];
    }
}

@end
