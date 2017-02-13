//
//  ViewController.m
//  VideoDemo
//
//  Created by zhangqi on 10/2/2017.
//  Copyright © 2017 MaxwellQi. All rights reserved.
//

#import "ViewController.h"
#import "ShowRendingVideoController.h"
#import "OpenGLView20.h"

@interface ViewController ()
@property (nonatomic,strong) AVCaptureSession *avCaptureSession;
@property (nonatomic,strong) AVCaptureDevice *captureDevice;
@property (nonatomic,strong) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic,strong) AVCaptureVideoDataOutput *captureVideoDataOutput;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (nonatomic,strong) ShowRendingVideoController *rendingVideoController;
@property (nonatomic,strong) OpenGLView20 *videoView;

@property (nonatomic,assign) int isShowRendingVideoController;
@end

@implementation ViewController

- (ShowRendingVideoController *)rendingVideoController
{
    if (!_rendingVideoController) {
        _rendingVideoController = [[ShowRendingVideoController alloc] initWithNibName:@"ShowRendingVideoController" bundle:nil];
    }
    return _rendingVideoController;
}

- (AVCaptureSession *)avCaptureSession
{
    if (!_avCaptureSession) {
        _avCaptureSession = [[AVCaptureSession alloc] init];
        _captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
        NSError *error = nil;
        _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];
        _captureVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        
        if ([_avCaptureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
            _avCaptureSession.sessionPreset = AVCaptureSessionPreset640x480;
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
    
    _videoView = [[OpenGLView20 alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.height - 40)];
    [_videoView setVideoSize:640 height:480];
    [self.view addSubview:_videoView];

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.avCaptureSession startRunning];
    self.isShowRendingVideoController = 0;
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

    
    // 获取yuv数据
    // 通过CMSampleBufferGetImageBuffer方法，获得CVImageBufferRef。
    // 这里面就包含了yuv420(NV12)数据的指针
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    //图像宽度（像素）
    size_t pixelWidth = CVPixelBufferGetWidth(pixelBuffer);
    //图像高度（像素）
    size_t pixelHeight = CVPixelBufferGetHeight(pixelBuffer);
    
    //yuv中的y所占字节数
    size_t y_size = pixelWidth * pixelHeight;
    //yuv中的uv所占的字节数
    size_t uv_size = y_size / 2;
    
    
    uint8_t *yuv_frame = malloc(uv_size + y_size);
    
    //获取CVImageBufferRef中的y数据
    uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    memcpy(yuv_frame, y_frame, y_size);
    
    //获取CMVImageBufferRef中的uv数据
    uint8_t *uv_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    memcpy(yuv_frame + y_size, uv_frame, uv_size);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    NSData *data = [NSData dataWithBytesNoCopy:yuv_frame length:y_size + uv_size];
    
    
    //
    UInt8 * pFrameRGB = (UInt8 *)[data bytes];
    
    [_videoView displayYUV420pData:pFrameRGB width:640 height:480];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.isShowRendingVideoController = 1;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self presentViewController:self.rendingVideoController animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
