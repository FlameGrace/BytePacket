# BytePacket
A byte decode tool.

## 简书主页

[https://www.jianshu.com/u/9c7775326f88](https://www.jianshu.com/u/9c7775326f88)

## 使用场景

App中在使用TCP/UDP或蓝牙通讯时，由于传输的数据类型为二进制数据，定制协议一般为：

|Head(2)|DataLength(4)|Data|

需要按照协议从二进制数据中解析出数据块，进而获取到所需的Data.



## 设计思路

因为场景不同，二进制数据协议不可能相同，但是循环解析模块却相对稳定，因此抽取解析类和数据块基类。

```shell
├── BytePacketProtocol.h  数据块协议，根据二进制协议生成不同的子类
├── BytePacket.h     
├── BytePacket.m
├── BytePacketDecoderProtocol.h  解析类协议，接受数据，循环解析数据块
├── BytePacketDecoder.h
├── BytePacketDecoder.m
├── ByteTransfrom.h           byte与基本数据类型转换工具，适应大小端  
└── ByteTransfrom.m
```



### BytePacketProtocol 数据块

```objective-c
typedef NS_ENUM(NSInteger, BytePacketErrorCode){
    
    BytePacketDefaultErrorCode = -1, //解码或编码过程中时数据出现错误
    BytePacketLackDataErrorCode, //解码因当前数据不足而失败
};


@protocol BytePacketProtocol <NSObject>

//编码后的数据或需要解码的数据
@property (strong ,nonatomic) NSData *encodeData;
/*
 可以被解码器忽略的长度
 The Length Can Be Skipped By Decoder From the Buffer。
*/
@property (assign, nonatomic) NSUInteger canBeSkippedLength;

//解码
- (BOOL)decodeWithError:(NSError **)error;
//编码
- (BOOL)encodeWithError:(NSError **)error;

@end

```



BytePacket及其子类实现特定的二进制协议，其中**encodeData**为需要解析的二进制数据，通常由解析类赋值临时缓存数据。

具体解析过程通过调用

```
- (BOOL)decodeWithError:(NSError **)error
```

完成，因此子类需实现该方法。在此过程中，若**encodeData**中有符合协议的数据，则需要通过设置**canBeSkippedLength**来告知解析类将其从临时缓存数据删除。

#### 解码错误

BytePacketDefaultErrorCode：

1. **encodeData**找不到协议头，整块数据都应该被丢弃，**canBeSkippedLength**应该为**encodeData**.length。
2. 其他不符合协议，需要丢弃数据的情况**canBeSkippedLength**根据场景变动。

BytePacketLackDataErrorCode：

1. **encodeData**长度不够，当前无法解析，需要等待更多数据，如**encodeData**比数据区长度小，或者连解析协议头的长度都不够等

   注：此场景**canBeSkippedLength**应该为0

   

### BytePacketDecoderProtocol

```objective-c
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
```

**BytePacketDecoderProtocol**为解析类协议，根据初始化时传入的**packetType**来解析出特定的数据块，在使用时只需要外部调用：

```objective-c
- (void)receiveNewBufferData:(NSData *)newBuffer;
```

将新数据丢入即可，类内部会自动循环解析数据块。



### BytePacketDecoder 解析类基类

```objective-c
#import "BytePacketDecoderProtocol.h"

@interface BytePacketDecoder : NSObject <BytePacketDecoderProtocol>
/**
 Cyclic decoding of current cached data
 对当前缓存数据进行循环解码,内部会保持while循环调用decodeSinglePacketInBufferData来解析，直到缓存数据为空时停止
 */
- (void)decodePacketsInBufferData;

/**
 Parse a single package
 解析单个包，根据canBeSkippedLength删除临时数据
 @return YES:已解析出一个包，可以继续下一个包的解析；NO:当前包解析因数据长度不足失败，需要等待数据
         YES: has resolved a package that can continue parsing the next packet; NO: current packet parsing needs to wait for data because of lack data
 */
- (BOOL)decodeSinglePacketInBufferData;

@end
```



## Demo及Pod导入

Demo地址：[https://github.com/FlameGrace/BytePacket](https://github.com/FlameGrace/BytePacket)

```ruby
pod 'BytePacket'
```


