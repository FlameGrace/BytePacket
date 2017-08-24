//
//  SocketPacket.h
//  LanP2P
//
//  Created by Flame Grace on 16/11/16.
//  Copyright © 2016年 hello. All rights reserved.
//  字节数据解析

#import <Foundation/Foundation.h>
#import "BytePacketProtocol.h"

@class BytePacket;

/*
 packet: 解析到的块数据，
 headBytePostion: 解析到头数据的位置
 */
typedef void(^BytePacketDecodeSuccessBlock)(BytePacket *packet, NSInteger headBytePostion);
/*
 packet: 解析到的块数据
 headBytePostion: 解析到头数据的位置
 error: 解析失败的错误提示
 */
typedef void(^BytePacketDecodeFailureBlock)(BytePacket *packet, NSInteger headBytePostion, NSError *error);


@interface BytePacket : NSObject <BytePacketProtocol>

//编码后数据
@property (strong ,nonatomic) NSData *encodeData;
//编码后数据总长度
@property (assign, nonatomic) NSUInteger encodeLength;

+ (instancetype)packet;

//从bufferData中解析块数据
+ (void)decodeInBufferData:(NSData *)bufferData withSuccessBlock:(BytePacketDecodeSuccessBlock)success failureBlock:(BytePacketDecodeFailureBlock)failure;

@end
