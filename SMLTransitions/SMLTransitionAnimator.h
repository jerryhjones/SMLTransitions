//
//  SMLTransitonAnimator.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SMLTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic, getter = isPresenting) BOOL presenting;
@property (weak, nonatomic) id <UIViewControllerContextTransitioning> transitionContext;

@property (weak, nonatomic) UIViewController *fromViewController;
@property (weak, nonatomic) UIViewController *toViewController;

@property (weak, nonatomic) UIViewController *presentingViewController;
@property (weak, nonatomic) UIViewController *presentedViewController;


- (void)transitionSetup; // Do not call directly, intended for subclasses to implement
- (void)animateTransition;
- (void)animatePresentingTransition;
- (void)animateDismissingTransition;


@end
