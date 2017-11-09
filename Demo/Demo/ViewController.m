//
//  ViewController.m
//  Demo
//
//  Created by Flame Grace on 2017/11/8.
//  Copyright © 2017年 com.flamegrace. All rights reserved.
//

#import "ViewController.h"
#import "TestBytePacket.h"
#import "BytePacketDecoder.h"

#define Duration (0.01)

@interface ViewController () <BytePacketDecoderDelegate>
{
    double flag;
}

@property (strong, nonatomic) BytePacketDecoder *decoder;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.decoder = [[BytePacketDecoder alloc]initWithPacketType:[TestBytePacket class]];
    self.decoder.delegate = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:Duration target:self selector:@selector(handleTime) userInfo:nil repeats:YES];
}

- (void)bytePacketDecoder:(id<BytePacketDecoderProtocol>)decoder decodeNewPacket:(TestBytePacket *)packet
{
    NSLog(@"Got a new packet：%@",packet.jsonDic);
}


- (void)handleTime
{
    NSMutableData *data = [NSMutableData data];
    flag += Duration;
    TestBytePacket *packet = [TestBytePacket packet];
    packet.jsonDic = @{@"flag":@(flag),@"content":@"This is a test"};
    if([packet encodeWithError:nil])
    {
        [data appendData:packet.encodeData];
    }
    NSInteger bosh = abs(rand()%20);
    for (int i=0; i<bosh; i++) {
        NSData *boshData = [@"bosh" dataUsingEncoding:NSUTF8StringEncoding];
        [data appendData:boshData];
    }
    [self.decoder receiveNewBufferData:data];
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

@end
