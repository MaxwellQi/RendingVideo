//
//  ViewController.m
//  VideoDemo
//
//  Created by zhangqi on 10/2/2017.
//  Copyright © 2017 MaxwellQi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) AVCaptureSession *avCaptureSession;
@property (nonatomic,strong) AVCaptureDevice *captureDevice;
@property (nonatomic,strong) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic,strong) AVCaptureVideoDataOutput *captureVideoDataOutput;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@end

@implementation ViewController

- (AVCaptureSession *)avCaptureSession
{
    if (!_avCaptureSession) {
        _avCaptureSession = [[AVCaptureSession alloc] init];
        _captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
        NSError *error = nil;
        _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];
        _captureVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        
        if ([_avCaptureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            _avCaptureSession.sessionPreset = AVCaptureSessionPreset1280x720;
        }
        
        if ([_avCaptureSession canAddInput:_captureDeviceInput]) {
            [_avCaptureSession addInput:_captureDeviceInput];
        }
        
        
        if ([_avCaptureSession canAddOutput:_captureVideoDataOutput]) {
            [_avCaptureSession addOutput:_captureVideoDataOutput];
        }
        
        dispatch_queue_t queue = dispatch_queue_create("videoQueue", NULL);
        [_captureVideoDataOutput setSampleBufferDelegate:self queue:queue];
        
    }
    return _avCaptureSession;
}

- (AVCaptureVideoPreviewLayer *)captureVideoPreviewLayer
{
    if (!_captureVideoDataOutput) {
        _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.avCaptureSession];
    }
    return _captureVideoPreviewLayer;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *layer = self.view.layer;
    layer.masksToBounds = YES;
    self.captureVideoPreviewLayer.frame = layer.bounds;
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResize;
    
    [layer insertSublayer:self.captureVideoPreviewLayer atIndex:0];
    //    [layer insertSublayer:self.captureVideoPreviewLayer above:self.view.layer];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.avCaptureSession startRunning];
}

-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
            
        }
    }
    return nil;
}

#pragma mark ------------------AVCaptureVideoDataOutputSampleBufferDelegate--------------------------------
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
