//
//  BytePacketDecoderProtocol.h
//
//  Created by Flame Grace on 2017/8/24.
//  Copyright © 2017年 zhouhaoran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BytePacketProtocol.h"

@protocol BytePacketDecoderProtocol;

//
@protocol BytePacketDecoderDelegate <NSObject>

//代理通知方法，解析到符合二进制协议的数据块
- (void)bytePacketDecoder:(id<BytePacketDecoderProtocol>)decoder decodeNewPacket:(id<BytePacketProtocol>)packet;

@end


@protocol BytePacketDecoderProtocol <NSObject>
//临时缓存数据
@property (strong, nonatomic) NSMutableData *bufferData;
//解析线程
@property (strong, nonatomic) dispatch_queue_t decodeQueue;
//需要解码的数据块类型，需遵循<BytePacketProtocol>
@property (readonly, nonatomic) Class packetType;

@property (weak, nonatomic) id <BytePacketDecoderDelegate>delegate;

- (instancetype)initWithPacketType:(Class<BytePacketProtocol>)packetType;
//接收新数据
- (void)receiveNewBufferData:(NSData *)newBuffer;

@end


