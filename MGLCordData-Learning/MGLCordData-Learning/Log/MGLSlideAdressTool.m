//
//  MGLSlideAdressTool.m
//  FastPayiOS
//
//  Created by ios on 2020/9/10.
//  Copyright © 2020 FastPay. All rights reserved.
//

#import "MGLSlideAdressTool.h"
#import <mach-o/dyld.h>

@implementation MGLSlideAdressTool

long calculate(void) {
    long slide = 0;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        if (_dyld_get_image_header(i)->filetype == MH_EXECUTE) {
            slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    return slide;
}

@end
