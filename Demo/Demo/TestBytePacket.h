//
//  TestBytePacket.h
//  Demo
//
//  Created by Flame Grace on 2017/11/8.
//  Copyright © 2017年 com.flamegrace. All rights reserved.
//  数据区结构
// |Head(2)|JsonLength(4)|Json(JsonLength)|

#import "BytePacket.h"

@interface TestBytePacket : BytePacket

@property (strong, nonatomic) NSDictionary *jsonDic;

@end
