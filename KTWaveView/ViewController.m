//
//  ViewController.m
//  KTWaveView
//
//  Created by KT on 2017/9/5.
//  Copyright © 2017年 KEENTEAM. All rights reserved.
//

#import "ViewController.h"
#import "KTWaveView.h"
@interface ViewController ()<KTWaveViewDelegate>{

    KTWaveView *_wave;
    KTWaveView *_rectWave;
    KTWaveView *_customWave;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setupUI {
    
    NSArray *colors = @[(__bridge id)[UIColor colorWithRed:134/255.0 green:208/255.0 blue:248/255.0 alpha:0.75].CGColor, (__bridge id)[UIColor whiteColor].CGColor];  //里
    NSArray *sColors = @[(__bridge id)[UIColor colorWithRed:166/255.0 green:240/255.0 blue:255/255.0 alpha:0.5].CGColor, (__bridge id)[UIColor colorWithRed:240/255.0 green:250/255.0 blue:255/255.0 alpha:0.5].CGColor];  //外
    
    
    //默认圆形波浪
    CGFloat waveWidth = 160;
    _wave = [[KTWaveView alloc]initWithFrame:CGRectMake(100, 100, waveWidth, waveWidth)];
    [self.view addSubview:_wave];
    _wave.layer.cornerRadius = waveWidth/2;
    _wave.clipsToBounds = YES;
    _wave.colors = colors;
    _wave.sColors = sColors;
    _wave.percent = 0.9;
    [_wave startWave];
    
    //自定义背景渐变-圆形波浪
    _customWave = [[KTWaveView alloc]initWithFrame:CGRectMake(10, 420, waveWidth, waveWidth)];
    [self.view addSubview:_customWave];
    _customWave.layer.cornerRadius = waveWidth/2;
    _customWave.clipsToBounds = YES;
    _customWave.colors = colors;
    _customWave.sColors = sColors;
    _customWave.percent = 0.4;
    _customWave.delegate = self;
    [_customWave startWave];
    
    
    //方形波浪
    _rectWave = [[KTWaveView alloc]initWithFrame:CGRectMake(200, 420, 140, 160)];
    [self.view addSubview:_rectWave];
    _rectWave.colors = colors;
    _rectWave.sColors = sColors;
    _rectWave.percent = 0.7;
    _rectWave.delegate = self;
    [_rectWave startWave];
    
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    startBtn.frame = CGRectMake(80, 300, 50, 40);
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    resetBtn.frame = CGRectMake(220, 300, 50, 40);
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(resetClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetBtn];
    
    UIButton *pauseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    pauseBtn.frame = CGRectMake(80, 360, 50, 40);
    [pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [pauseBtn addTarget:self action:@selector(stopClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseBtn];
    
    UIButton *goOnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    goOnBtn.frame = CGRectMake(220, 360, 50, 40);
    [goOnBtn setTitle:@"继续" forState:UIControlStateNormal];
    [goOnBtn addTarget:self action:@selector(goOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goOnBtn];

    
}

- (void)startClicked:(id)sender {
    [_wave startWave];
    [_rectWave startWave];
    [_customWave startWave];
}

- (void)resetClicked:(id)sender {
    [_wave reset];
    [_rectWave reset];
    [_customWave reset];
}

- (void)stopClicked:(id)sender {
    [_wave stopWave];
}

- (void)goOnClicked:(id)sender {
    [_wave goOnWave];
}


//自定义背景渐变
- (void)drawBgGradient:(KTWaveView *)waveView context:(CGContextRef)context {
    
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    CGFloat compoents[8]={
        1.0,1.0,1.0,1.0,
        166/255.0,240/255.0,255.0/255.0,1
    };
    
    CGFloat locations[2]={0,0.7};
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 2);
    
    CGFloat width = CGRectGetWidth(waveView.frame);
    CGFloat height = CGRectGetHeight(waveView.frame);
    CGPoint center = CGPointMake(width/2, height/2);
    
    if (waveView == _rectWave) {
        //线性渐变
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(width, height), kCGGradientDrawsAfterEndLocation);
    } else {
        //径向渐变
        CGContextDrawRadialGradient(context, gradient, center,0, center, width/2, kCGGradientDrawsAfterEndLocation);
    }
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
