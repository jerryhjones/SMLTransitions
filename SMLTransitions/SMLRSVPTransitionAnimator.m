//
//  SMLRSVPTransitionAnimator.m
//  Repartee
//
//  Created by Jerry Jones on 9/26/13.
//  Copyright (c) 2013 Spaceman Labs. All rights reserved.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "SMLRSVPTransitionAnimator.h"

static CGFloat kDimmingAlpha = 0.3f;

@interface SMLRSVPTransitionAnimator ()

@property (nonatomic) UIView *realSuperview;

@end

@implementation SMLRSVPTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
	return self.presenting ? 0.9f : 0.3f;
}

- (void)animatePresentingTransition
{
	self.presentingViewController.view.userInteractionEnabled = NO;
	
	CGFloat offset = 30.0f;
	
	// Set our ending frame. We'll modify this later if we have to
	CGRect presentedFrame = [[UIScreen mainScreen] bounds];
	presentedFrame.origin.y += offset;
	presentedFrame.size.height -= offset;
	
	CGRect startingFrame = presentedFrame;
	startingFrame.origin.y = CGRectGetMaxY(presentedFrame);

	self.presentedViewController.view.frame = startingFrame;
	self.presentedViewController.view.layer.cornerRadius = 2.0f;
	self.presentedViewController.view.clipsToBounds = YES;

	UIView *dimmingView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	dimmingView.backgroundColor = [UIColor blackColor];
	dimmingView.alpha = 0.0f;
	
	[self.transitionContext.containerView addSubview:dimmingView];
	[self.transitionContext.containerView addSubview:self.presentedViewController.view];
	
	CGFloat delay = 0.15f;
	
	[UIView animateWithDuration:[self transitionDuration:self.transitionContext] - delay
						  delay:0.0f
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:0.0f
						options:0
					 animations:^{
						 self.presentingViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
						 self.presentingViewController.view.transform = CGAffineTransformMakeScale(0.92f, 0.92f);
						 dimmingView.alpha = kDimmingAlpha;
					 } completion:^(BOOL finished) {
					 }];
	

	[UIView animateWithDuration:[self transitionDuration:self.transitionContext] - (delay)
						  delay:delay
		 usingSpringWithDamping:0.9f
		  initialSpringVelocity:0.0f
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 self.presentedViewController.view.frame = presentedFrame;
					 } completion:^(BOOL finished) {
						 [self.transitionContext completeTransition:YES];
					 }];
}

- (void)animateDismissingTransition
{
	// Set our ending frame. We'll modify this later if we have to
	CGRect dismissedFrame = self.presentedViewController.view.frame;
	dismissedFrame.origin.y = CGRectGetMaxY([[UIScreen mainScreen] bounds]);
	
	self.presentingViewController.view.userInteractionEnabled = YES;
	
	UIView *dimmingView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	dimmingView.backgroundColor = [UIColor blackColor];
	dimmingView.alpha = kDimmingAlpha;
	
	self.presentingViewController.view.transform = CGAffineTransformMakeScale(0.92f, 0.92f);
	[self.transitionContext.containerView addSubview:dimmingView];
	[self.transitionContext.containerView addSubview:self.presentedViewController.view];
	
	[UIView animateWithDuration:[self transitionDuration:self.transitionContext] animations:^{
		self.presentingViewController.view.transform = CGAffineTransformIdentity;
		self.presentingViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
		self.presentedViewController.view.frame = dismissedFrame;
		dimmingView.alpha = 0.0f;
	} completion:^(BOOL finished) {
		[self.transitionContext completeTransition:YES];
	}];
}

@end
