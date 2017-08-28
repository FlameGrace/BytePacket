//
//  BytePacketDecoder.m
//  LanP2P
//
//  Created by Flame Grace on 16/11/22.
//  Copyright © 2016年 hello. All rights reserved.
//

#import "BytePacketFileDecoder.h"
#import "ByteTransfrom.h"


@interface BytePacketFileDecoder()

//读取buffer数据的指针位置
@property (assign, nonatomic) NSInteger fileBufferHandle;
//定时解析
@property (strong, nonatomic) NSTimer *timer;

@end



@implementation BytePacketFileDecoder


- (instancetype)init
{
    if(self = [super init])
    {
        self.readBufferLength = 1024*1024;
    }
    return self;
}




- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
}

- (void)endTimer
{
    if(self.timer || self.timer.isValid)
    {
        NSLog(@"Timer 已经停止工作。");
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)timerHandle
{
    [self decode];
}



- (void)receiveNewBufferData:(NSData *)newBuffer
{
    dispatch_sync(self.decodeQueue, ^{
        if(newBuffer.length <1 )
            return;
        
        //将数据写入临时文件
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if(![fileManager fileExistsAtPath:self.bufferFilePath])
        {
            if(![newBuffer writeToFile:self.bufferFilePath atomically:YES])
            {
                NSLog(@"buffer文件创建失败！");
                
            }
        }
        else
        {
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.bufferFilePath];
            [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
            [fileHandle writeData:newBuffer]; //追加写入数据
            [fileHandle closeFile];
        }
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:self.bufferFilePath error:nil] fileSize];
        NSLog(@"当前buffer大小：%llu",fileSize);
        
        if(!self.timer.isValid || !self.timer)
        {
            [self performSelectorOnMainThread:@selector(startTimer) withObject:nil waitUntilDone:NO];
        }
        
    });

}



- (void)decodeNewPacketInBufferData:(NSData *)bufferData
{
    BytePacket *packet = [[self.packetClass alloc] init];
    NSData *headerData = [packet packHead];
    NSInteger find = [ByteTransfrom findData:headerData firstPositionInData:bufferData];
    
    if(find == -1)
    {
        //没有找到头数据
        self.fileBufferHandle += bufferData.length;
        return;
    }
    
    NSUInteger sumLength = bufferData.length;
    NSData *data = [bufferData subdataWithRange:NSMakeRange(find, (sumLength - find))];
    packet.encodeData = data;
    NSError *error;
    if([packet decodeWithError:&error])
    {
        self.fileBufferHandle += find + packet.encodeLength;
        if([self.delegate respondsToSelector:@selector(bytePacketDecoder:decodeNewPacket:)])
        {
            [self.delegate bytePacketDecoder:self decodeNewPacket:packet];
        }
        return;
    }
    else
    {
        //如果因为数据长度不够而解码出错，读取的指针,下一次从find位置开始读
        if(error.code == BytePacketLackDataErrorCode)
        {
            self.fileBufferHandle += find;
        }
        else
        {
            self.fileBufferHandle += find + 1;
        }
        
        return;
    }

}




//解析下载数据
- (void)decode
{
    BOOL isDecodeDone = NO;
    NSData *bufferData = [self readBufferDataStart:self.fileBufferHandle length:[self readBufferLength]];
    if(bufferData.length)
    {
        [self decodeNewPacketInBufferData:bufferData];
        isDecodeDone = NO;
    }
    else
    {
        isDecodeDone = YES;
    }
    
    if(isDecodeDone)
    {
        [self removeDecodedBufferData];
        [self endTimer];
    }
}

//从buffer文件中读取数据
//start:起始位置
//length:长度
- (NSData *)readBufferDataStart:(NSInteger)start length:(NSUInteger)length
{
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:self.bufferFilePath];
    [readHandle seekToFileOffset:start];
    NSData *bufferData = [readHandle readDataOfLength:length];
    [readHandle closeFile];
    return bufferData;
    
}


//清除已被解码的缓存数据
- (void)removeDecodedBufferData
{
    NSInteger minHandle = self.fileBufferHandle;
    if(minHandle == 0)
    {
        return ;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    unsigned long long fileSize = [[fileManager attributesOfItemAtPath:self.bufferFilePath error:nil] fileSize];
    minHandle -= [self readBufferLength];
    
    if(fileSize > minHandle && minHandle >0)
    {
        NSData *leftData = [self readBufferDataStart:minHandle length:(NSUInteger)(fileSize - minHandle)];
        [fileManager removeItemAtPath:self.bufferFilePath error:nil];
        
        [leftData writeToFile:self.bufferFilePath atomically:YES];
        
        self.fileBufferHandle = 0;
    }
}


- (void)dealloc
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:self.bufferFilePath error:nil];
}



@end
