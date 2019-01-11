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
    var imageView = UIImageView(frame: .zero)
    private var didSetupConstraints = false
    
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
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        setupImageView()
        setNeedsUpdateConstraints()
        initReachability()
    }
    
    fileprivate func setupImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsForImageView()
    }
    
    fileprivate func addConstraintsForImageView() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 48),
            imageView.heightAnchor.constraint(equalToConstant: 48),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
    }
    
    open override func updateConstraints() {
        if !didSetupConstraints {
            addConstraintsForImageView()
        }
        super.updateConstraints()
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
        let imageName = statusOn ? "connectedIcon48" : "disconnectedIcon48"
        let bundle = Bundle(for: ReachabilityView.self)
        let image = UIImage(named: imageName, in: bundle, compatibleWith: traitCollection)
        imageView.image = image
    }

}
