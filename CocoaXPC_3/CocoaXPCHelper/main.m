//
//  main.m
//  CocoaXPCHelper
//
//  Created by Jinwoo Kim on 3/8/23.
//

#import <Foundation/Foundation.h>
#import <xpc/xpc.h>

int main(int argc, const char * argv[]) {
    xpc_rich_error_t session_error = NULL;
    xpc_session_t session = xpc_session_create_mach_service("com.pookjw.CocoaXPC.Helper",
                                                            NULL,
                                                            XPC_SESSION_CREATE_INACTIVE,
                                                            &session_error);

    if (session_error) {
        char *error_description = xpc_rich_error_copy_description(session_error);
        [NSException raise:@"" format:@"%s", error_description];
        free(error_description);
    }

    xpc_session_set_incoming_message_handler(session, ^(xpc_object_t  _Nonnull message) {
        xpc_session_t session = (xpc_session_t)message;

        xpc_session_set_incoming_message_handler(session, ^(xpc_object_t  _Nonnull message) {
            xpc_type_t type = xpc_get_type(message);

            if (type == XPC_TYPE_DICTIONARY) {
                xpc_object_t dictionary = xpc_dictionary_create(NULL, NULL, 0);
                xpc_dictionary_set_string(dictionary, "test", "GOOD");
                xpc_rich_error_t _Nullable error = xpc_session_send_message(session, dictionary);

                if (error) {
                    char *error_description = xpc_rich_error_copy_description(error);
                    [NSException raise:@"" format:@"%s", error_description];
                    free(error_description);
                }
            }
        });

        xpc_rich_error_t activation_error = NULL;
        xpc_session_activate(session, &activation_error);

        if (activation_error) {
            char *error_description = xpc_rich_error_copy_description(activation_error);
            [NSException raise:@"" format:@"%s", error_description];
            free(error_description);
        }
    });

    xpc_rich_error_t activation_error = NULL;
    xpc_session_activate(session, &activation_error);

    if (activation_error) {
        char *error_description = xpc_rich_error_copy_description(activation_error);
        [NSException raise:@"" format:@"%s", error_description];
        free(error_description);
    }
    
    dispatch_main();
    
    return EXIT_FAILURE;
}
