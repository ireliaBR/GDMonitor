//
//  GDViewController.m
//  GDMonitor
//
//  Created by 北陆 on 11/08/2021.
//  Copyright (c) 2021 北陆. All rights reserved.
//


#import "GDViewController.h"
#import <CoreServices/CoreServices.h>
@import FLEX;

@interface GDViewController ()

@property (nonatomic, strong) UIButton *defaultButton;
@property (nonatomic, strong) UIButton *imageIOButton;
@property (nonatomic, strong) UIButton *sdwebImageButton;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, copy) NSString *path;

@end

@implementation GDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = ({
        UIImageView *imageView = [UIImageView new];
        NSString *path = [NSBundle.mainBundle.bundlePath stringByAppendingPathComponent:@"48189853.JPEG"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        imageView.image = image;
        imageView.frame = self.view.bounds;
        imageView;
    });
    
    self.defaultButton = ({
        UIButton *button = [UIButton new];
        [button setTitle:@"原有方式" forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(defaultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    self.imageIOButton = ({
        UIButton *button = [UIButton new];
        [button setTitle:@"新方式" forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(imageIOButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    self.sdwebImageButton = ({
        UIButton *button = [UIButton new];
        [button setTitle:@"sdWebImage" forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(sdwebImageAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.defaultButton];
    [self.view addSubview:self.imageIOButton];
    [self.view addSubview:self.sdwebImageButton];
    
    self.defaultButton.center = CGPointMake(200, 100);
    self.imageIOButton.center = CGPointMake(200, 300);
    self.sdwebImageButton.center = CGPointMake(200, 500);
    self.path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[FLEXManager sharedManager] showExplorer];
}

- (void)defaultButtonAction:(UIButton *)btn {
    NSData *data = UIImageJPEGRepresentation(self.imageView.image, 1.0);
//    NSData *data = UIImagePNGRepresentation(self.imageView.image);
    NSError *error = nil;
    BOOL result = [data writeToFile:[self.path stringByAppendingPathComponent:@"aaa.jpg"] options:kNilOptions error:&error];
    NSLog(@"%d", result);
}

- (void)imageIOButtonAction:(UIButton *)btn {
    NSURL *url = [NSURL fileURLWithPath:[self.path stringByAppendingPathComponent:@"bbb.jpg"]];
    [self resizeImage:self.imageView.image toUrl:url withSize:CGSizeMake(1000, 1000)];
//    CFStringRef type = kUTTypeJPEG;
//    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)url, type, 1, nil);
//    CGImageDestinationAddImage(destination, self.imageView.image.CGImage, nil);
//    bool b = CGImageDestinationFinalize(destination);
//    NSLog(@"%d", b);
//    CFRelease(destination);
}

- (void)sdwebImageAction:(UIButton *)btn {
    NSMutableData *imageData = [NSMutableData data];
    CGImageDestinationRef imageDestination = CGImageDestinationCreateWithData((__bridge  CFMutableDataRef)imageData, kUTTypeJPEG, 1, NULL);
    CGImageDestinationAddImage(imageDestination, self.imageView.image.CGImage, nil);
    CGImageDestinationFinalize(imageDestination);
    CFRelease(imageDestination);
    
    NSError *error = nil;
    BOOL result = [imageData writeToFile:[self.path stringByAppendingPathComponent:@"ccc.jpg"] options:kNilOptions error:&error];
    NSLog(@"%d", result);
    
}


- (void)resizeImage:(UIImage *)image toUrl:(NSURL *)url withSize:(CGSize)size {
//    SDImageFormat format;
//    if ([SDImageCoderHelper CGImageContainsAlpha:image.CGImage]) {
//        format = SDImageFormatPNG;
//    } else {
//        format = SDImageFormatJPEG;
//    }
//    CFStringRef imageUTType = [NSData sd_UTTypeFromImageFormat:format];
    CFStringRef imageUTType = kUTTypeJPEG;
    NSDictionary *downsampleOptions = @{
        (__bridge id)kCGImageSourceShouldCache: @NO,
        (__bridge id)kCGImageSourceCreateThumbnailFromImageAlways: @YES,
        (__bridge id)kCGImageSourceShouldCacheImmediately: @YES,
        (__bridge id)kCGImageSourceCreateThumbnailWithTransform: @YES,
        (__bridge id)kCGImageSourceThumbnailMaxPixelSize: @(size.height),
    };
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)url, imageUTType, 1, (__bridge CFDictionaryRef)downsampleOptions);
    CGImageDestinationAddImage(destination, self.imageView.image.CGImage, nil);
    bool b = CGImageDestinationFinalize(destination);
    NSLog(@"%d", b);
    CFRelease(destination);
    
    NSMutableData *imageData = [NSMutableData data];
    CGImageDestinationRef imageDestination = CGImageDestinationCreateWithData((__bridge  CFMutableDataRef)imageData, kUTTypeJPEG, 1, NULL);
    CGImageDestinationAddImage(imageDestination, self.imageView.image.CGImage, nil);
    CGImageDestinationFinalize(imageDestination);
    CFRelease(imageDestination);
}


@end
