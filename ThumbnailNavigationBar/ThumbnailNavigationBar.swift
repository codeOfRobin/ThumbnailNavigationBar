//
//  ThumbnailNavigationBar.swift
//  ThumbnailNavigationBar
//
//  Created by Robin Malhotra on 05/10/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import UIKit

class ThumbnailNavigationBar: UINavigationBar {

    private let backgroundView: UIVisualEffectView
    private let separatorView: UIView
    private let separatorHeight: CGFloat
    private var contentView: UIView?
    private var preferredTintColor: UIColor?
    private var backgroundHidden: Bool = false

    private var titleTextLabel: UILabel? {
        for subview in self.contentView?.subviews ?? [] {
            //TODO: This depends on sequence of subviews
            if subview.isKind(of: UILabel.self) {
                return subview as? UILabel
            }
        }
        return nil
    }


    var preferredBarStyle = UIBarStyle.black {
        didSet {
            if oldValue == preferredBarStyle {
                return
            }
            self.updateContentViewsForBarStyle()
        }
    }

    var targetScrollView: UIScrollView? {
        didSet {
            if oldValue == targetScrollView {
                return
            }
            oldValue?.removeObserver(self, forKeyPath: "contentOffset")
            targetScrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
        }
    }
    var scrollViewMinimumOffset: CGFloat = 0

    func setTargetScrollView(_ scrollView: UIScrollView, minimumOffset: CGFloat) {
        self.targetScrollView = scrollView
        self.scrollViewMinimumOffset = minimumOffset
    }

    func setPreferredBarStyle(_ barStyle: UIBarStyle) {
        if preferredBarStyle == barStyle {
            return
        }
        self.preferredBarStyle = barStyle

    }

    required init?(coder aDecoder: NSCoder) {
        self.backgroundView = UIVisualEffectView.init(effect: nil)
        self.separatorView = UIView(frame: .zero)
        self.separatorHeight = 1.0/UIScreen.main.scale
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        self.backgroundView = UIVisualEffectView.init(effect: nil)
        self.separatorView = UIView(frame: .zero)
        self.separatorHeight = 1.0/UIScreen.main.scale
        super.init(frame: frame)
    }


    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        //TODO: Check with UIIMage.new() or whatever
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()

        self.captureContentView()
        self.updateContentViewsForBarStyle()
        self.captureAppTintColor()
    }

    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        self.captureContentView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.insertSubview(self.backgroundView, at: 0)
        self.insertSubview(self.separatorView, at: 1)

        //TODO: Figure out this code by asking Tim
        let reference = self.bounds
        self.backgroundView.frame = CGRect(x: reference.origin.x, y: -reference.minY, width: reference.width, height: self.frame.maxY)

        //TODO: Double check to make sure this works
        self.separatorView.frame = self.bounds.divided(atDistance: self.separatorHeight, from: CGRectEdge.maxYEdge).remainder


        if let titleView = self.topItem?.titleView {
            titleView.isHidden = self.backgroundHidden
        } else {
            self.titleTextLabel?.isHidden = self.backgroundHidden
        }

        if self.backgroundHidden {
            self.updateBackgroundVisibilityForScrollView()
        }
    }

    func updateContentViewsForBarStyle() {
        // The other 3 options are all black lol
        let darkMode = self.preferredBarStyle != .default

        self.backgroundView.effect = UIBlurEffect(style: darkMode ? .dark : .light)

        if darkMode == false {
            //TODO: This depends on sequence of subviews
            self.backgroundView.subviews.last?.backgroundColor = UIColor(white: 0.97, alpha: 0.8)
        }

        let greyNess: CGFloat = darkMode ? 0.4 : 0.75
        self.separatorView.backgroundColor = UIColor(white: greyNess, alpha: 1.0)
    }


    func updateBackgroundVisibilityForScrollView() {
        guard let scrollView = self.targetScrollView else {
            return
        }
        let totalHeight = self.frame.maxY
        let barHeight = self.frame.height

        let offsetHeight = scrollView.contentOffset.y - scrollViewMinimumOffset
        // if offsetHeight is between 0 and totalHeight, we have to draw the nav bar, if it's greater, we have to show the nav bar
        let barShouldBeVisible = offsetHeight > totalHeight

        let referenceFrame = self.backgroundView.frame
        if barShouldBeVisible {
            //TODO: Make sense of this code
            self.backgroundView.frame = CGRect(x: referenceFrame.origin.x, y: barHeight - offsetHeight, width: referenceFrame.width, height: offsetHeight)
            self.backgroundView.alpha = 1.0
        } else {
            self.backgroundView.frame = CGRect(x: referenceFrame.origin.x, y: -self.frame.minY, width: referenceFrame.width, height: self.frame.maxY)
            self.backgroundView.alpha = 0.0
        }

        //TODO: Make sense of this code ^ 2
        self.separatorView.alpha = max(0.0, offsetHeight/barHeight * 2.0)
        let hidden = !barShouldBeVisible
        let alpha = max(offsetHeight - (barHeight * 0.75), 0.0) / (barHeight * 0.25)

        let titleView = self.topItem?.titleView ?? self.titleTextLabel ?? UILabel()
        titleView.isHidden = hidden
        titleView.alpha = alpha

        self.tintColor = (offsetHeight > barHeight * 0.5) ? self.preferredTintColor : UIColor.white
        self.barStyle = offsetHeight > ((totalHeight - barHeight) * 0.5) ? self.preferredBarStyle : .black
    }

    // MARK: KVO Handling

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.updateBackgroundVisibilityForScrollView()
    }

    // MARK: Transition handling

    func setBackgroundHidden(_ hidden: Bool, animated: Bool = false, for ViewController: UIViewController? = nil) {
        self.setNeedsLayout()

        if hidden == backgroundHidden {
            return
        }

        let animationBlock: (Bool) -> Void = {
            hidden in
            self.backgroundView.alpha = hidden ? 0.0 : 1.0
            self.separatorView.alpha = hidden ? 0.0 : 1.0
            self.tintColor = hidden ? UIColor.white : self.preferredTintColor

            // iOS 11 fixes
            let textColor = self.preferredBarStyle.rawValue > UIBarStyle.default.rawValue ? UIColor.white : UIColor.black
            self.titleTextAttributes = [.foregroundColor: textColor]
            self.largeTitleTextAttributes = [.foregroundColor: textColor]
        }

        let toggleBarStyleBlock: () -> Void = {
            self.barStyle = hidden ? .black : self.preferredBarStyle
        }

        backgroundHidden = hidden
        if hidden == false {
            self.targetScrollView = nil
        }

        let transitionCoordinator = ViewController?.transitionCoordinator
        //TODO: Make this easier
        if (transitionCoordinator == nil) || (transitionCoordinator?.isInteractive == true) {
            let duration = transitionCoordinator?.transitionDuration ?? 0.35

            //TODO:
            //I like having a utility `func animate(if animated: Bool, withDuration duration: TimeInterval, animations: () ->)` function
            //
            //Then you can call `UIView.animate(if: animated, withDuration: duration, animations: something)`

            if animated {
                UIView.animate(withDuration: duration) {
                    toggleBarStyleBlock()
                    animationBlock(hidden)
                }
            } else {
                toggleBarStyleBlock()
                animationBlock(hidden)
            }
        }

        toggleBarStyleBlock()
        transitionCoordinator?.animate(alongsideTransition: { _ in
            animationBlock(hidden)
        }, completion: { (context) in
            if context.isCancelled {
                animationBlock(hidden)
            }
        })

    }

    // MARK: Internal View Traversal

    // Capturing internal views
    @discardableResult func captureContentView() -> Bool {
        for subview in subviews {
            if NSStringFromClass(type(of: subview)).contains("Content") {
                self.contentView = subview
                return true
            }
        }
        return false
    }


    func captureAppTintColor() {
        if let _ = self.preferredTintColor {
            return
        }
        let view = self
        while let view = view.superview {
            if let tintColor = view.tintColor {
                self.preferredTintColor = tintColor
                break
            }
        }
    }

//    func captureAppTintColor() {
//
//        //TODO: Maybe add a preferred tint color
//    }

}

extension UIColor {
    static func colorBetween(firstColor: UIColor, secondColor: UIColor, percentage progress: CGFloat) -> UIColor {
        var r1: CGFloat = 0.0
        var r2: CGFloat = 0.0
        var g1: CGFloat = 0.0
        var g2: CGFloat = 0.0
        var b1: CGFloat = 0.0
        var b2: CGFloat = 0.0
        var a1: CGFloat = 0.0
        var a2: CGFloat = 0.0
        firstColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        secondColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        let rDelta = r2 - r1
        let gDelta = g2 - g1
        let bDelta = b2 - b1
        let aDelta = a2 - a1

        return UIColor(red: r1 + rDelta * progress,
                       green: g1 + gDelta * progress,
                       blue: b1 + bDelta * progress,
                       alpha: a1 + aDelta * progress)
    }
}



extension UINavigationController {
    var thumbnailNavigationBar: ThumbnailNavigationBar? {
        if self.navigationBar.isKind(of: ThumbnailNavigationBar.self) {
            return self.navigationBar as? ThumbnailNavigationBar
        }
        return nil
    }
}
