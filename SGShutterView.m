//The MIT License (MIT)
//
//Copyright (c) <year> <copyright holders>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.
//
//
//  SGShutterView.m
//
//  Created by Justin Williams on 6/17/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "SGShutterView.h"

enum {
    SGShutterViewUpperLeftQuadrant = 0,
    SGShutterViewUpperRightQuadrant,
    SGShutterViewLowerLeftQuadrant,
    SGShutterViewLowerRightQuadrant
};

@interface SGShutterView ()
@property (nonatomic, strong) UIView *quadrant1;
@property (nonatomic, strong) UIView *quadrant2;
@property (nonatomic, strong) UIView *quadrant3;
@property (nonatomic, strong) UIView *quadrant4;
@property (nonatomic, strong) NSMutableArray *shutterConstraints;
@end

@implementation SGShutterView

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        _shutterConstraints = [[NSMutableArray alloc] init];
        
        [self addSubview:self.quadrant1];
        [self addSubview:self.quadrant2];
        [self addSubview:self.quadrant3];
        [self addSubview:self.quadrant4];
        
        [self setupConstraints];
    }
    return self;
}


- (void)setupConstraints
{
    NSArray *quadrants = @[self.quadrant1,
                           self.quadrant2,
                           self.quadrant3,
                           self.quadrant4];
    
    [quadrants enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        // Set the shutter quadrants to be 25% of its superview.
        NSLayoutConstraint *horizontalConstraint = [NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:0];
        NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:0];
        [self addConstraints:@[horizontalConstraint, verticalConstraint]];
        [self.shutterConstraints addObjectsFromArray:@[horizontalConstraint, verticalConstraint]];
        
        // Set the hugging constraints
        NSString *horizontalHuggingFormat = @"";
        NSString *verticalHuggingFormat = @"";
        switch (idx)
        {
            case SGShutterViewUpperLeftQuadrant:
                horizontalHuggingFormat = @"H:|[quad]";
                verticalHuggingFormat = @"V:|[quad]";
                break;
            case SGShutterViewUpperRightQuadrant:
                horizontalHuggingFormat = @"H:[quad]|";
                verticalHuggingFormat = @"V:|[quad]";
                break;
            case SGShutterViewLowerLeftQuadrant:
                horizontalHuggingFormat = @"H:|[quad]";
                verticalHuggingFormat = @"V:[quad]|";
                break;
            case SGShutterViewLowerRightQuadrant:
                horizontalHuggingFormat = @"H:[quad]|";
                verticalHuggingFormat = @"V:[quad]|";
                break;
        }
        
        NSDictionary *views = @{ @"quad" : obj };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalHuggingFormat options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalHuggingFormat options:0 metrics:nil views:views]];
    }];
}

#pragma mark -
#pragma mark Instance Methods
// +--------------------------------------------------------------------
// | Instance Methods
// +--------------------------------------------------------------------

- (void)animate
{
    [self updateConstraintsWithMultiplier:0.5f constant:1.0f];
        
    [UIView animateWithDuration:0.12f animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self animateOut];
    }];
}

- (void)animateOut
{
    [self updateConstraintsWithMultiplier:0.0f constant:0.0f];

    [UIView animateWithDuration:0.12f animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark -
#pragma mark Dynamic Accessor Methods
// +--------------------------------------------------------------------
// | Dynamic Accessor Methods
// +--------------------------------------------------------------------

- (UIView *)quadrant1
{
    if (_quadrant1 == nil)
    {
        _quadrant1 = [self createQuadrant];
    }
    return _quadrant1;
}

- (UIView *)quadrant2
{
    if (_quadrant2 == nil)
    {
        _quadrant2 = [self createQuadrant];
    }
    return _quadrant2;
}

- (UIView *)quadrant3
{
    if (_quadrant3 == nil)
    {
        _quadrant3 = [self createQuadrant];
    }
    return _quadrant3;
}

- (UIView *)quadrant4
{
    if (_quadrant4 == nil)
    {
        _quadrant4 = [self createQuadrant];
    }
    return _quadrant4;
}

- (UIView *)createQuadrant
{
    UIView *quadrant = [[UIView alloc] initWithFrame:CGRectZero];
    quadrant.translatesAutoresizingMaskIntoConstraints = NO;
    quadrant.backgroundColor = [UIColor blackColor];
    
    return quadrant;
}

#pragma mark -
#pragma mark Private/Convenience Methods
// +--------------------------------------------------------------------
// | Private/Convenience Methods
// +--------------------------------------------------------------------

- (void)updateConstraintsWithMultiplier:(CGFloat)multiplier constant:(CGFloat)constant
{
    // Update the constraints
    NSMutableArray *updatedConstraints = [[NSMutableArray alloc] init];
    [self.shutterConstraints enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLayoutConstraint *constraint = (NSLayoutConstraint *)obj;
        NSLayoutAttribute attribute = constraint.firstAttribute;
        
        [self removeConstraint:constraint];
        NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem attribute:attribute relatedBy:NSLayoutRelationEqual toItem:self attribute:attribute multiplier:multiplier constant:constant];
        [self addConstraint:newConstraint];
        [updatedConstraints addObject:newConstraint];
    }];
    
    self.shutterConstraints = updatedConstraints;
    
    [self setNeedsUpdateConstraints];
}

@end
