//
//  GiftEntities.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "GiftEntities.h"

@implementation GiftEntities

@dynamic giftArray;
@dynamic maxCoin;
@dynamic minCoin;

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:@(self.minCoin) forKey:@"minCoin"];
    [coder encodeObject:@(self.maxCoin) forKey:@"maxCoin"];
    [coder encodeObject:self.giftArray forKey:@"giftArray"];
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        self.minCoin = [[aDecoder decodeObjectForKey:@"minCoin"] intValue];
        self.maxCoin = [[aDecoder decodeObjectForKey:@"maxCoin"] intValue];
        self.giftArray = [aDecoder decodeObjectForKey:@"giftArray"];
        
    }
    
    return self;
}


@end
