//
//  CocoaXPCFramework.h
//  CocoaXPCFramework
//
//  Created by Jinwoo Kim on 2/21/23.
//

#import <Foundation/Foundation.h>
#import "CocoaXPCFrameworkProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface CocoaXPCFramework : NSObject <CocoaXPCFrameworkProtocol>
@end
