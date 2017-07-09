//
//  MenuController.swift
//  ProductHuntClient
//
//  Created by Vadim on 7/7/17.
//  Copyright © 2017 Vadim Prosviryakov. All rights reserved.
//

import UIKit

final class MenuController : UIViewController {
    
    @IBOutlet fileprivate var dimmingView: UIView!
    @IBOutlet fileprivate var menuView: UIView!
    @IBOutlet fileprivate var menuLeftConstraint: NSLayoutConstraint!
    @IBOutlet private var extraButtons: [UIButton] = []
    
    @IBOutlet weak var tech: UIButton!
    @IBOutlet weak var games: UIButton!
    @IBOutlet weak var books: UIButton!
    @IBOutlet weak var podcasts: UIButton!
    @IBOutlet weak var developer: UIButton!
    @IBOutlet weak var home: UIButton!
    
    fileprivate lazy var interactiveTransitioning = UIPercentDrivenInteractiveTransition()
    fileprivate var interactiveDismiss: Bool = false
    fileprivate var dismiss: Bool = false
    fileprivate var fromViewSuperview: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gr = UITapGestureRecognizer(target: self, action: #selector(close))
        dimmingView.addGestureRecognizer(gr)
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    func close() {
        dismiss(animated: true)
    }
    
    @IBAction func selectTech() {
        let newVc = storyboard!.instantiateViewController(withIdentifier: "select") as! ProductListController
        let nc = NavigationController(rootViewController: newVc)
        present(nc, animated: true) {
            newVc.title = (self.tech.titleLabel?.text)!
            newVc.category = (self.tech.titleLabel?.text)!
        }
    }
    
    @IBAction func selectGames() {
        let newVc = storyboard!.instantiateViewController(withIdentifier: "select") as! ProductListController
        let nc = NavigationController(rootViewController: newVc)
        present(nc, animated: true) {
            newVc.title = (self.games.titleLabel?.text)!
            newVc.category = (self.games.titleLabel?.text)!
        }
    }
    
    @IBAction func selectBooks() {
        let newVc = storyboard!.instantiateViewController(withIdentifier: "select") as! ProductListController
        let nc = NavigationController(rootViewController: newVc)
        present(nc, animated: true) {
            newVc.title = (self.books.titleLabel?.text)!
            newVc.category = (self.books.titleLabel?.text)!
        }
    }
    
    @IBAction func selectPodcasts() {
        let newVc = storyboard!.instantiateViewController(withIdentifier: "select") as! ProductListController
        let nc = NavigationController(rootViewController: newVc)
        present(nc, animated: true) {
            newVc.title = (self.podcasts.titleLabel?.text)!
            newVc.category = (self.podcasts.titleLabel?.text)!
        }
    }
    
    
    
}

// MARK: - UIViewControllerTransitioningDelegate

extension MenuController : UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard presented == self else { return nil }
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard dismissed == self else { return nil }
        return self
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard animator === self && interactiveDismiss else { return nil }
        return interactiveTransitioning
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning

extension MenuController : UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        if !dismiss {
            fromViewSuperview = fromVC.view.superview
            containerView.addSubview(fromVC.view)
            containerView.addSubview(toVC.view)
            dimmingView.alpha = 0
            toVC.view.frame = containerView.bounds
            menuLeftConstraint.constant = -menuView.frame.width
            view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
                self.dimmingView.alpha = 1
                self.menuLeftConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) { finish in
                transitionContext.completeTransition(true)
                self.dismiss = true
            }
        } else {
            containerView.addSubview(toVC.view)
            containerView.addSubview(fromVC.view)
            UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState], animations: {
                self.dimmingView.alpha = 0
                self.menuLeftConstraint.constant = -self.menuView.frame.width
                self.view.layoutIfNeeded()
            }) { finish in
                self.fromViewSuperview.addSubview(toVC.view)
                transitionContext.completeTransition(true)
            }
        }
        
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        
    }
    
}
