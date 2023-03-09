//
//  AppDelegate.m
//  CocoaXPC_3
//
//  Created by Jinwoo Kim on 3/8/23.
//

#import "AppDelegate.h"
#import <xpc/xpc.h>

@interface AppDelegate ()
@property (strong) xpc_session_t session;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    xpc_rich_error_t session_error = NULL;
    xpc_session_t session = xpc_session_create_xpc_service("com.pookjw.CocoaXPC.Service", NULL, XPC_SESSION_CREATE_INACTIVE, &session_error);
    
    if (session_error) {
        char *error_description = xpc_rich_error_copy_description(session_error);
        [NSException raise:@"" format:@"%s", error_description];
        free(error_description);
    }
    
    xpc_rich_error_t activation_error = NULL;
    xpc_session_activate(session, &activation_error);
    xpc_conn

    if (activation_error) {
        char *error_description = xpc_rich_error_copy_description(activation_error);
        [NSException raise:@"" format:@"%s", error_description];
        free(error_description);
    }
    
    self.session = session;
}

@end
