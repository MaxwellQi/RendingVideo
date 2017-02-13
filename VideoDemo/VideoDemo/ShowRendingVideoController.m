//
//  ShowRendingVideoController.m
//  VideoDemo
//
//  Created by zhangqi on 10/2/2017.
//  Copyright © 2017 MaxwellQi. All rights reserved.
//

#import "ShowRendingVideoController.h"
#import "OpenGLView20.h"

@interface ShowRendingVideoController ()
@property (nonatomic,strong) OpenGLView20 *videoView;
@end

@implementation ShowRendingVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(processingMessageQueue) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)processingMessageQueue
{
    if (self.yuvContainer.count <= 0) {
        return;
    }
    NSLog(@"渲染了");
    [_videoView setVideoSize:self.view.frame.size.width height:self.view.frame.size.height];
    
    NSData *data = [self.yuvContainer objectAtIndex:0];
    UInt8 * pFrameRGB = (UInt8 *)[data bytes];
    
    [_videoView displayYUV420pData:pFrameRGB width:self.view.frame.size.width height:self.view.frame.size.height];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
