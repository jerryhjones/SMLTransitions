//
//  TransitionAnimator.m

#import "TransitionAnimator.h"

static CGFloat kDimmingAlpha = 0.6f;

// Dismissal Values
static CGFloat kAttachmentInsetRatio = 4.0f;
static CGFloat kGravityMagnitude = 3.8;

@interface TransitionAnimator ()
@property (nonatomic) UIView *realSuperview;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@end

@implementation TransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return self.presenting ? 0.6f : 1.33f;
}

- (void)animatePresentingTransition
{
    self.presentingViewController.view.userInteractionEnabled = NO;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(30.0f, 10.0f, 30.0f, 10.0f);
    CGRect presentedFrame = [[UIScreen mainScreen] bounds];
    presentedFrame = UIEdgeInsetsInsetRect(presentedFrame, insets);
    
    CGRect startingFrame = presentedFrame;
    startingFrame.origin.y = CGRectGetMaxY(presentedFrame);
    
    self.presentedViewController.view.frame = startingFrame;
    self.presentedViewController.view.layer.cornerRadius = 6.0f;
    self.presentedViewController.view.clipsToBounds = YES;
    
    [self.transitionContext.containerView addSubview:self.dimmingView];
    [self.transitionContext.containerView addSubview:self.presentedViewController.view];
    
    CGFloat delay = 0.00f;
    
    [UIView animateWithDuration:[self transitionDuration:self.transitionContext] - delay
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:0
                     animations:^{
                         self.presentingViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
//                         self.presentingViewController.view.transform = CGAffineTransformMakeScale(0.92f, 0.92f);
                         self.dimmingView.alpha = kDimmingAlpha;
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
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.presentedViewController.view.window];
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] init];
    gravityBehavior.magnitude = kGravityMagnitude;
    self.gravity = gravityBehavior;
    [self.animator addBehavior:gravityBehavior];

    [self dropView:self.presentedViewController.view];

    [UIView animateWithDuration:[self transitionDuration:self.transitionContext] animations:^{
        self.presentingViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        self.dimmingView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.presentingViewController.view.userInteractionEnabled = YES;
        [self.transitionContext completeTransition:YES];
    }];
}

- (UIView *)dimmingView
{
    if (nil != _dimmingView) {
        return _dimmingView;
    }
    
    _dimmingView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _dimmingView.backgroundColor = [UIColor blackColor];
    _dimmingView.alpha = 0.0f;
    
    return _dimmingView;
}

- (void)dropView:(UIView *)view
{
    CGRect frame = view.frame;
    
    view.frame = frame;
    [view.superview setNeedsLayout];
    [view.superview layoutIfNeeded];
    
    [self.gravity addItem:view];
    
    // Randomize which side we attach first
    BOOL attachLeft = arc4random_uniform(2) < 1;
    CGFloat attachmentOffsetDirection = attachLeft ? -1.0f : 1.0f;
    CGPoint attachmentPoint;
    
    CGFloat xOffsetFromCenter = CGRectGetWidth(frame) / kAttachmentInsetRatio * attachmentOffsetDirection;
    xOffsetFromCenter = 10.0f;
    CGFloat attachmentPointOffset = xOffsetFromCenter * -1.0f;
    UIOffset attachmentOffset = UIOffsetMake(xOffsetFromCenter, CGRectGetHeight(frame) / -2.0f);
    
    if (attachLeft) {
        attachmentPoint = CGPointMake(CGRectGetMinX(frame) + attachmentPointOffset, 0.0f);
    } else {
        attachmentPoint = CGPointMake(CGRectGetMaxX(frame) + attachmentPointOffset, 0.0f);
    }
    
    
    UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:view
                                                                 offsetFromCenter:attachmentOffset
                                                                 attachedToAnchor:attachmentPoint];
    [self.animator addBehavior:attachment];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.035 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.animator removeBehavior:attachment];
    });
}


@end
