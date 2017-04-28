//
//  GiftsEntities.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/25.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "GiftsEntities.h"

@implementation GiftsEntities

@dynamic uid;
@dynamic name;
@dynamic iconUrl;
@dynamic coins;
@dynamic isHidden;
@dynamic animationType;
@dynamic allowContinue;

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:@(self.coins) forKey:@"coins"];
    [coder encodeObject:@(self.isHidden) forKey:@"ishidden"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.iconUrl forKey:@"iconUrl"];
    [coder encodeObject:self.uid forKey:@"uid"];
    [coder encodeObject:@(self.animationType) forKey:@"animationType"];
    [coder encodeObject:@(self.allowContinue) forKey:@"allowContinue"];
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        self.coins = [[aDecoder decodeObjectForKey:@"coins"] intValue];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.isHidden = [[aDecoder decodeObjectForKey:@"ishidden"] intValue];
        self.iconUrl = [aDecoder decodeObjectForKey:@"iconUrl"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.allowContinue = [[aDecoder decodeObjectForKey:@"allowContinue"] intValue];
        self.animationType = [[aDecoder decodeObjectForKey:@"animationType"] intValue];
    }
    
    return self;
}



@end
