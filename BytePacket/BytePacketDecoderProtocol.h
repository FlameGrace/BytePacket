//
//  BytePacketDecoderProtocol.h
//  ToolsKit
//
//  Created by Flame Grace on 2017/8/24.
//  Copyright © 2017年 hello. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BytePacket.h"
#import "ByteTransfrom.h"

@protocol BytePacketDecoderProtocol;


@protocol BytePacketDecoderDelegate <NSObject>

//解析到新数据块
- (void)bytePacketDecoder:(id<BytePacketDecoderProtocol>)decoder decodeNewPacket:(BytePacket *)packet;

@end


@protocol BytePacketDecoderProtocol <NSObject>

@property (strong, nonatomic) dispatch_queue_t decodeQueue;

@property (strong, nonatomic) Class packetClass;

@property (weak, nonatomic) id <BytePacketDecoderDelegate>delegate;

//接收新数据
- (void)receiveNewBufferData:(NSData *)newBuffer;

@end


