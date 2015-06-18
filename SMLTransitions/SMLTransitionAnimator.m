//
//  SMLTransitonAnimator.m
//  Repartee
//
//  Created by Jerry Jones on 5/8/14.
//  Copyright (c) 2014 Spaceman Labs. All rights reserved.
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

#import "SMLTransitionAnimator.h"

@implementation SMLTransitionAnimator

- (id)init
{
	self = [super init];
	if (nil == self) {
		return nil;
	}
	
	[self transitionSetup];
	
	return self;
}

- (void)transitionSetup
{
	
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
	return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
	self.transitionContext = transitionContext;
	[self animateTransition];
}

- (void)animateTransition
{
	if (self.presenting) {
		[self animatePresentingTransition];
	} else {
		[self animateDismissingTransition];
	}
}

- (void)animatePresentingTransition
{
	[NSException raise:@"Invalid Transition" format:@"Subclasses of SMLTransitionAnimator must provide an implementation for animatePresentingTransition"];
}

- (void)animateDismissingTransition
{
	[NSException raise:@"Invalid Transition" format:@"Subclasses of SMLTransitionAnimator must provide an implementation for animateDismissingTransition"];
}


- (UIViewController *)fromViewController
{
	UIViewController *fromViewController = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	return fromViewController;
}

- (UIViewController *)toViewController
{
	UIViewController *toViewController = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	return toViewController;
}

- (UIViewController *)presentedViewController
{
	return self.presenting ? self.toViewController : self.fromViewController;
}

- (UIViewController *)presentingViewController
{
	return self.presenting ? self.fromViewController : self.toViewController;
}

@end
