//
//  main.m
//  CocoaXPCFramework
//
//  Created by Jinwoo Kim on 2/21/23.
//

#import <Foundation/Foundation.h>
#import "CocoaXPCFramework.h"

int main(int argc, const char *argv[]) {
    CocoaXPCFramework *service = [CocoaXPCFramework new];
    [service run];
    return EXIT_FAILURE;
}
