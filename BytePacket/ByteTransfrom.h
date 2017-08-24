//
//  ByteHandle.h
//  p2p
//
//  Created by Flame Grace on 16/11/4.
//  Copyright © 2016年 hello. All rights reserved.
//  字节数据转换

#import <Foundation/Foundation.h>

@interface ByteTransfrom : NSObject


+ (short)lowBytesToShortInt:(Byte *)byte;

+ (short)highBytesToShortInt:(Byte *)byte;

+(int)highBytesToInt:(Byte*)byte;

+ (int)lowBytesToInt:(Byte *)byte;

//从data数组中查找含有相应字节的子数组的第一次出现的位置
+ (NSInteger)findData:(NSData *)find firstPositionInData:(NSData *)data;

//从data数组中查找含有相应字节的子数组的位置，返回位置数组
+ (NSArray <NSNumber *> *)findData:(NSData *)find positionsInData:(NSData *)data;
//从Data中截取部分字节数组
//start:起始位置
//length:截取长度
+ (Byte *)subdata:(NSData *)data start:(NSInteger)start length:(NSInteger)length;

//从字符串中截取部分字符串
+ (char *)substr:(char *)src start:(NSInteger)start length:(NSInteger)length;

+ (long)lowBytesToLong:(Byte *)byte;

@end
