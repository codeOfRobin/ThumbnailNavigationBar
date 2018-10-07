//
//  ThumbnailHeaderImageView.swift
//  ThumbnailNavigationBar
//
//  Created by Robin Malhotra on 07/10/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import UIKit

class ThumbnailHeaderImageView: UIView {

    var image: UIImage {
        didSet {
            if image == oldValue {
                return
            }
            self.imageView.image = image
        }
    }
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

    private let imageView: UIImageView
    private let gradientView: UIImageView
    private var shadowIsDirty: Bool


    init(image: UIImage, height: CGFloat) {
        self.image = image
        self.shadowHidden = true
        self.shadowAlpha = 0.2
        self.shadowIsDirty = true

        self.imageView = UIImageView(image: image)
        self.gradientView = UIImageView(image: nil)

        super.init(frame: CGRect(x: 0, y: 0, width: 320, height: height))
        self.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {

        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.imageView.backgroundColor = .black
        self.addSubview(imageView)

        self.gradientView.layer.magnificationFilter = .nearest
        self.gradientView.isHidden = true
        self.imageView.addSubview(self.gradientView)
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
        self.imageView.frame = frame

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
        self.imageView.backgroundColor = backgroundColor
    }

    func setContentMode(_ contentMode: ContentMode) {
        super.contentMode = contentMode
        self.imageView.contentMode = contentMode
    }

    static func shadowImageForHeight(_ shadowHeight: CGFloat, alpha: CGFloat) -> UIImage {
        return UIImage.init()
    }

}
