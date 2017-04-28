//
//  gift.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "gift.h"
#import <CoreData/CoreData.h>

@implementation gift


- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.giftid forKey:@"giftid"];
    
    [coder encodeObject:self.giftname forKey:@"giftname"];
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.giftid = [aDecoder decodeObjectForKey:@"giftid"];
        
        self.giftname = [aDecoder decodeObjectForKey:@"giftname"];
    }
    return self;
}


@end
