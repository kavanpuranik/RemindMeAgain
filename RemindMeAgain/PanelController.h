#import "BackgroundView.h"
#import "StatusItemView.h"
#import "NumberField.h"

@class PanelController;

@protocol PanelControllerDelegate <NSObject>

@optional

- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller;

@end

#pragma mark -

@interface PanelController : NSWindowController <NSWindowDelegate, NSUserNotificationCenterDelegate>
{
    BOOL _hasActivePanel;
    __unsafe_unretained BackgroundView *_backgroundView;
    __unsafe_unretained id<PanelControllerDelegate> _delegate;
    
    __unsafe_unretained IBOutlet NSTextField *reminderTextField;    
    __unsafe_unretained IBOutlet NumberField *reminderPeriodField;

    __unsafe_unretained IBOutlet NSTextField *statusLabel;
    __unsafe_unretained IBOutlet NSButton *startStopButton;
    __unsafe_unretained IBOutlet NSButton *quitButton;
    
    NSColor *defaultBackgroundColor;
}

@property (nonatomic, unsafe_unretained) IBOutlet BackgroundView *backgroundView;

@property (nonatomic) BOOL hasActivePanel;
@property (nonatomic, unsafe_unretained, readonly) id<PanelControllerDelegate> delegate;

- (id)initWithDelegate:(id<PanelControllerDelegate>)delegate;

- (void)openPanel;
- (void)closePanel;

@property (weak) NSTimer *repeatingTimer;

- (NSDictionary *)userInfo;

@end
