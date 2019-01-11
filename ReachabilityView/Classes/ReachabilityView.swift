//
//  StatusView.swift
//  TSS-iOS
//
//  Created by Powell, Mark W (397M) on 9/17/18.
//  Copyright © 2018 JPL. All rights reserved.
//

import UIKit
import Reachability

@IBDesignable open class ReachabilityView: UIView {
    
    var reachability: Reachability?
    @IBOutlet var containerView: UIView!
    @IBOutlet var imageView: UIImageView!
    
    @IBInspectable var size:CGFloat = 48 {
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    //initWithCode to init view from xib or storyboard
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
   
    fileprivate func setup() {
        loadViewFromNib()
        initReachability()
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
    
    open override func layoutIfNeeded() {
        super.layoutIfNeeded()
        updateAppearance()
    }
    
    fileprivate func initReachability() {
        if reachability == nil {
            reachability = Reachability(hostname: "www.apple.com") //TODO get from info.plist
            reachability?.whenReachable = { reachability in
                self.statusOn = true
                self.updateAppearance()
            }
            reachability?.whenUnreachable = { reachability in
                self.statusOn = false
                self.updateAppearance()
            }
            do {
                try reachability?.startNotifier()
            } catch let err {
                debugPrint("Reachability error: \(err.localizedDescription)")
            }
        }
    }
    
    //custom views should override this to return true if
    //they cannot layout correctly using autoresizing.
    //from apple docs https://developer.apple.com/documentation/uikit/uiview/1622549-requiresconstraintbasedlayout
    override open class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: size, height: size)
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        updateAppearance()
    }
    
    func updateAppearance() {
        backgroundColor = UIColor.clear
        let imageName = statusOn ? "connected" : "disconnected"
        let bundle = Bundle(for: ReachabilityView.self)
        let newImage = UIImage(named: imageName, in: bundle, compatibleWith: traitCollection)
        imageView.image = newImage
    }

}

