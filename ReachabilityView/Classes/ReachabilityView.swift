//
//  StatusView.swift
//  TSS-iOS
//
//  Created by Powell, Mark W (397M) on 9/17/18.
//  Copyright © 2018 JPL. All rights reserved.
//

import UIKit

@IBDesignable public class ReachabilityView: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var imageView: UIImageView!
    
    @IBInspectable public var size:CGFloat = 48 {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable public var statusOn: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    //initWithFrame to init view from code
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    //initWithCode to init view from xib or storyboard
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
   
    func setup() {
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        if containerView == nil {
            let bundle = Bundle(for: ReachabilityView.self)
            bundle.loadNibNamed("ReachabilityView", owner: self, options: nil)
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
    
    public override func layoutIfNeeded() {
        super.layoutIfNeeded()
        updateAppearance()
    }
    
    //custom views should override this to return true if
    //they cannot layout correctly using autoresizing.
    //from apple docs https://developer.apple.com/documentation/uikit/uiview/1622549-requiresconstraintbasedlayout
    override public class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: size, height: size)
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        updateAppearance()
    }
    
    public func updateAppearance() {
        backgroundColor = UIColor.clear
        let imageName = statusOn ? "connected" : "disconnected"
        let bundle = Bundle(for: ReachabilityView.self)
        let newImage = UIImage(named: imageName, in: bundle, compatibleWith: traitCollection)
        imageView.image = newImage
    }

}
