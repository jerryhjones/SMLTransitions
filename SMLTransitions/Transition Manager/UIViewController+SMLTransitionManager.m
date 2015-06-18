//
//  UIViewController+SMLTransitionManager.m
//  Repartee
//
//  Created by Jerry Jones on 9/27/13.
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

#import "UIViewController+SMLTransitionManager.h"
#import <objc/runtime.h>

static char *SMLTransitionManagerAnimatorKey = "SMLTransitionManagerAnimatorKey";

@implementation UIViewController (SMLTransitionManager)

- (void)setTransitionAnimator:(id<UIViewControllerAnimatedTransitioning>)transitionAnimator
{
	objc_setAssociatedObject(self, SMLTransitionManagerAnimatorKey, transitionAnimator, OBJC_ASSOCIATION_RETAIN);
	
	if (nil == transitionAnimator && self.transitioningDelegate == [SMLTransitionsManager sharedManager]) {
		self.transitioningDelegate = nil;
		self.modalPresentationStyle = UIModalPresentationFullScreen;
	}
	
	if (transitionAnimator) {
		self.transitioningDelegate = [SMLTransitionsManager sharedManager];
		self.modalPresentationStyle = UIModalPresentationCustom;
	}
}

- (id<UIViewControllerAnimatedTransitioning>)transitionAnimator
{
	return objc_getAssociatedObject(self, SMLTransitionManagerAnimatorKey);
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent
					 animated:(BOOL)flag
				animatorClass:(Class)animatorClass
				   completion:(void (^)(void))completion
{
    id animatorInstance = [[animatorClass alloc] init];
    [self presentViewController:viewControllerToPresent animated:flag animator:animatorInstance completion:completion];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent
					 animated:(BOOL)flag
					 animator:(id<UIViewControllerAnimatedTransitioning>)animator
				   completion:(void (^)(void))completion
{
	viewControllerToPresent.transitionAnimator = animator;
	[self presentViewController:viewControllerToPresent animated:flag completion:completion];
}


@end
