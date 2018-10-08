//
//  ThumbnailHeaderImageView.swift
//  ThumbnailNavigationBar
//
//  Created by Robin Malhotra on 07/10/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol ScrollingResponsiveHeader where Self: ASDisplayNode {
    func respondToScrollOffset(_ scrollOffset: CGFloat)
}

class ThumbnailHeaderImageView: UIView {

    var scrollOffset: CGFloat = 0.0 {
        didSet {
            if scrollOffset == oldValue {
                return
            }
            self.setNeedsLayout()
        }
    }
    var shadowHidden: Bool {
        didSet {
            if shadowHidden == oldValue {
                return
            }
            self.gradientView.isHidden = shadowHidden
            self.setNeedsLayout()
        }
    }
    var shadowAlpha: CGFloat {
        didSet {
            if shadowAlpha == oldValue {
                return
            }
            self.shadowIsDirty = true
        }
    }
    var shadowHeight: CGFloat = 110.0 {
        didSet {
            if shadowHeight == oldValue {
                return
            }
            self.shadowIsDirty = true
        }
    }

    private let embeddedView: UIView
    private let gradientView: UIImageView
    private var shadowIsDirty: Bool


    init(embeddedView: UIView, height: CGFloat) {
        self.embeddedView = embeddedView
        self.shadowHidden = true
        self.shadowAlpha = 0.2
        self.shadowIsDirty = true

        self.gradientView = UIImageView(image: nil)

        super.init(frame: CGRect(x: 0, y: 0, width: 320, height: height))
        self.contentMode = .scaleAspectFill
        self.embeddedView.clipsToBounds = true

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {

        self.embeddedView.contentMode = .scaleAspectFill
        self.embeddedView.clipsToBounds = true
        self.embeddedView.backgroundColor = .black
        self.addSubview(embeddedView)

        self.gradientView.layer.magnificationFilter = .nearest
        self.gradientView.isHidden = true
        self.embeddedView.addSubview(self.gradientView)
    }


    // MARK: view lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        var frame = CGRect(origin: .zero, size: self.bounds.size)
        if self.scrollOffset < 0 {
            let offset = abs(self.scrollOffset)
            frame.origin.y = -offset
            frame.size.height += offset
        }
        self.embeddedView.frame = frame

        if self.shadowHidden {
            return
        }

        if self.shadowIsDirty {
            self.gradientView.image = ThumbnailHeaderImageView.shadowImageForHeight(shadowHeight, alpha: shadowAlpha)
            self.shadowIsDirty = false
        }

        frame = self.gradientView.frame
        frame.size.height = self.shadowHeight
        frame.size.width = self.bounds.size.width
        frame.origin.y = (self.scrollOffset < 0.0) ? 0.0 : abs(self.scrollOffset)
        frame.origin.x = 0.0
        self.gradientView.frame = frame
    }

    // MARK: View Layout

    func setBackgroundColor(_ backgroundColor: UIColor) {
        super.backgroundColor = backgroundColor
        self.embeddedView.backgroundColor = backgroundColor
    }

    func setContentMode(_ contentMode: ContentMode) {
        super.contentMode = contentMode
        self.embeddedView.contentMode = contentMode
    }

    static func shadowImageForHeight(_ shadowHeight: CGFloat, alpha: CGFloat) -> UIImage {
        return UIImage.init()
    }

}
