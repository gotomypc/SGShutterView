//
//  SGViewController.m
//  ShutterTest
//
//  Created by Justin Williams on 6/17/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "SGViewController.h"
#import "SGShutterView.h"

@interface SGViewController ()

@property (nonatomic, strong) UIView *captureView;
@property (nonatomic, strong) SGShutterView *shutterView;
@end

@implementation SGViewController

#pragma mark -
#pragma mark View Lifecycle
// +--------------------------------------------------------------------
// | View Lifecycle
// +--------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.captureView];
    [self.captureView addSubview:self.shutterView];

    [self setupConstraints];
}

#pragma mark -
#pragma mark IBAction Methods
// +--------------------------------------------------------------------
// | IBAction Methods
// +--------------------------------------------------------------------

- (IBAction)shoot:(id)sender
{
    [self.shutterView animate];
}

#pragma mark -
#pragma mark Dynamic Accessor Methods
// +--------------------------------------------------------------------
// | Dynamic Accessor Methods
// +--------------------------------------------------------------------

- (UIView *)captureView
{
    if (_captureView == nil)
    {
        _captureView = [[UIView alloc] initWithFrame:CGRectZero];
        _captureView.translatesAutoresizingMaskIntoConstraints = NO;
        _captureView.backgroundColor = [UIColor redColor];
    }
    return _captureView;
}

- (SGShutterView *)shutterView
{
    if (_shutterView == nil)
    {
        _shutterView = [[SGShutterView alloc] initWithFrame:CGRectZero];
        _shutterView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _shutterView;
}

#pragma mark -
#pragma mark Private/Convenience Methods
// +--------------------------------------------------------------------
// | Private/Convenience Methods
// +--------------------------------------------------------------------

- (void)setupConstraints
{
    NSDictionary *views = @{ @"capture" : self.captureView,
                             @"shutter" : self.shutterView
                             };
    
    // Set the capture view to be the width of the view
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[capture]|" options:0 metrics:nil views:views]];
    
    // Set the capture view's height to be between 300 and 600pt
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[capture(>=300,<=600)]" options:0 metrics:nil views:views]];
    
    // Make the shutter view fill out it's parent view: the capture view.
    [self.captureView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[shutter]|" options:0 metrics:nil views:views]];
    [self.captureView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[shutter]|" options:0 metrics:nil views:views]];
}

@end
