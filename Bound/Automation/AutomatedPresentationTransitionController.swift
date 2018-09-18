//
//  AutomatedModalPresentationTransitionController.swift
//  Transition
//
//  Created by muukii on 8/15/18.
//  Copyright © 2018 eure. All rights reserved.
//

import UIKit

@available(iOS 10, *)
public final class AutomatedPresentationTransitionController : AutomatedTransitionControllerBase, UIViewControllerAnimatedTransitioning {

  public override init(
    fallbackTransitionController: UIViewControllerAnimatedTransitioning = BasicModalPresentationTransitionController(operation: .presentation),
    setupAnimation: @escaping (Animator, NotifyTransitionCompleted) -> Void
    ) {

    super.init(
      fallbackTransitionController: fallbackTransitionController,
      setupAnimation: setupAnimation
    )
  }

  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0
  }

  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

    let containerView = transitionContext.containerView

    guard
      let fromViewController = transitionContext.viewController(forKey: .from),
      let toView = transitionContext.view(forKey: .to) else {
        preconditionFailure("Something went wrong on UIKit")
    }

    fromViewController.beginAppearanceTransition(false, animated: true)

    let animator = Animator()

    setupAnimation(animator, {
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      fromViewController.endAppearanceTransition()
    })

    animator.addErrorHandler { (error) in
      self.fallbackTransitionController.animateTransition(using: transitionContext)
    }

    animator.run(in: transitionContext)

  }
}
