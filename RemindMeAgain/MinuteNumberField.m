//  NumberField.m
//  Created by Kavan Puranik
#import "MinuteNumberField.h"

@implementation MinuteNumberField

-(void) textDidChange:(NSNotification *)aNotification {
    
    NSString* value = [self stringValue];
    if ([value length] > 2) {
        [self setStringValue:[[value uppercaseString] substringFromIndex:[value length] - 1]];
    } else {
        [self setStringValue:[value uppercaseString]];
    }
    
	[self setIntValue:[self intValue]];
    
    if ([self intValue] > 59){
        [self setStringValue:[[[self stringValue] uppercaseString] substringWithRange:NSMakeRange(0, 1)]];
    }
    
    if ([self intValue] == 0){
        [self setStringValue: @""];
    }
    
    // TODO read up about delegates first: http://mobiledevelopertips.com/objective-c/the-basics-of-protocols-and-delegates.html
    // make sure the notification is sent back to any delegate
    // [[self delegate] textDidChange:aNotification];
}

@end