//
//  ShowRendingVideoController.m
//  VideoDemo
//
//  Created by zhangqi on 10/2/2017.
//  Copyright © 2017 MaxwellQi. All rights reserved.
//

#import "ShowRendingVideoController.h"


@interface ShowRendingVideoController ()

@end

@implementation ShowRendingVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _videoView = [[OpenGLView20 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    [_videoView setVideoSize:640 height:480];
    [self.view addSubview:_videoView];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
