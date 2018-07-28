//
//  LabelSwitch.swift
//  LabelSwitch
//
//  Created by cookie on 20/02/2018.
//  Copyright © 2017 cookie. All rights reserved.
//

import Foundation
import UIKit

public protocol  LabelSwitchDelegate : class {
    func switchChangToState(_ state: LabelSwitchState) -> Void
}

private class LabelSwitchPart {
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = .clear
        return label
    }()
    
    let back: LabelSwitchBackView = {
        let view = LabelSwitchBackView()
        return view
    }()
    
    lazy var mask: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        label.layer.mask = layer
        return layer
    }()
    
    func setConfig(_ config: LabelSwitchConfig) {
        back.backgroundColor = config.backgroundColor
        label.textColor = config.textColor
        label.text = config.text
        label.font = config.font
        label.sizeToFit()
        
        if let gradient = config.backGradient {
            back.gradientLayer.colors = gradient.colors
            back.gradientLayer.startPoint = gradient.startPoint
            back.gradientLayer.endPoint = gradient.endPoint
            back.gradientLayer.isHidden = false
        }
        
        if let image = config.backImage {
            back.imageView.image = image
            back.imageView.isHidden = false
        }
    }
    
    func setState(_ state: LabelSwitchPartState) {
        mask.frame = state.backMaskFrame
        back.frame = state.backMaskFrame
    }
}

@IBDesignable public class LabelSwitch: UIView {
    
    private lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.5
        addSubview(view)
        return view
    }()
    
    private lazy var leftPart: LabelSwitchPart = {
        let part = LabelSwitchPart()
        addSubview(part.back)
        addSubview(part.label)
        return part
    }()
    
    private lazy var rightPart: LabelSwitchPart = {
        let part = LabelSwitchPart()
        addSubview(part.back)
        addSubview(part.label)
        return part
    }()
    
    private var switchConfigL: LabelSwitchConfig! {
        didSet {
            stateL.backgroundColor     = switchConfigL.backgroundColor
            leftPart.setConfig(switchConfigL)
        }
    }
    private var switchConfigR: LabelSwitchConfig! {
        didSet {
            stateR.backgroundColor    = switchConfigR.backgroundColor
            rightPart.setConfig(switchConfigR)
        }
    }
    
    private var edge: CGFloat = 0
    private let circlePadding: CGFloat
    private let minimumSize: CGSize
    
    private var stateL = LabelSwitchUIState()
    private var stateR = LabelSwitchUIState()
    
    private var fullSizeTapGesture: UITapGestureRecognizer?
    
    public weak var delegate: LabelSwitchDelegate?
    public var curState: LabelSwitchState {
        didSet{
            switch curState {
            case .L: updateUIState(stateL)
            case .R: updateUIState(stateR)
            }
        }
    }
    
    public var circleShadow: Bool = true {
        didSet{
            circleView.layer.shadowOpacity = circleShadow ? 0.5 : 0.0
        }
    }
    
    public var circleColor: UIColor = .white {
        didSet{
            circleView.backgroundColor = circleColor
        }
    }
    
    public var fullSizeTapEnabled: Bool = false {
        didSet{
            if fullSizeTapEnabled {
                fullSizeTapGesture = UITapGestureRecognizer(target: self, action: #selector(switchTaped(sender:)))
                addGestureRecognizer(fullSizeTapGesture!)
            } else {
                fullSizeTapGesture?.removeTarget(self, action: #selector(switchTaped(sender:)))
                fullSizeTapGesture = nil
            }
        }
    }
    
    private var calculatedSize: CGSize = .zero {
        didSet {
            bounds = CGRect(origin: .zero, size: calculatedSize)
            layer.cornerRadius = calculatedSize.height / 2
            setupTextMask()
            setupLabel()
            setupCircle()
        }
    }

    public init(center: CGPoint,
            leftConfig: LabelSwitchConfig,
           rightConfig: LabelSwitchConfig,
         circlePadding: CGFloat = 1,
           minimumSize: CGSize = .zero,
          defaultState: LabelSwitchState = .L) {

        self.circlePadding = circlePadding
        self.minimumSize = minimumSize
        self.curState = defaultState
        
        super.init(frame: .zero)
        self.center = center
        clipsToBounds = true
        setConfig(left: leftConfig, right: rightConfig)
        updateUI()
    }

    private func updateUI() {
        calculateSize()
        switch curState {
        case .L: updateUIState(stateL)
        case .R: updateUIState(stateR)
        }
    }
    
    /// Calculate the bounds of the switch accourding to the label's text and font size
    private func calculateSize () {
        let circleMinimumSize = minimumSize.height - 2 * circlePadding
        let circleSize = max(circleMinimumSize, max(switchConfigL.font.pointSize, switchConfigR.font.pointSize) * 2)
        edge = circleSize * 0.2
       
        let width = max(minimumSize.width, max(leftPart.label.bounds.width, rightPart.label.bounds.width) + 2 * edge + circleSize + 2 * circlePadding)
        calculatedSize = CGSize(width: width, height: circleSize + 2 * circlePadding)
    }

    /// Calculate the left frame and right frame for the circle
    private func setupCircle() {
        let diameter = bounds.height - 2 * circlePadding
        circleView.layer.cornerRadius = diameter / 2
        circleView.layer.shadowRadius = bounds.height * 0.05
        let circleSize = CGSize(width: diameter, height: diameter)
        
        stateL.circleFrame = CGRect(origin: CGPoint(x: circlePadding, y: circlePadding),
                                      size: circleSize)
        
        stateR.circleFrame = CGRect(origin: CGPoint(x: bounds.width - diameter - circlePadding, y: circlePadding),
                                      size: circleSize)
        /// Add the touch event to the circle view
        circleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchTaped(sender:))))
    }
    
    /// Set the label's frame and color
    private func setupLabel() {
        leftPart.label.center = CGPoint(x: (bounds.width - bounds.height + edge) / 2,
                                        y: bounds.height / 2)
        
        rightPart.label.center = CGPoint(x: (bounds.width + bounds.height - edge) / 2,
                                         y: bounds.height / 2)
    }
    
    /// Set the frame for the text mask
    private func setupTextMask() {
        stateL.leftPartState.backMaskFrame = bounds.offsetBy(dx: -bounds.width, dy: 0)
        stateL.rightPartState.backMaskFrame = bounds

        stateR.leftPartState.backMaskFrame = bounds
        stateR.rightPartState.backMaskFrame = bounds.offsetBy(dx: bounds.width, dy: 0)
    }
    
    private func setConfig(left: LabelSwitchConfig, right: LabelSwitchConfig) {
        switchConfigL = left
        switchConfigR = right
    }
    
    /// Called when the circle is touched
    @objc
    func switchTaped(sender: Any) {
        UIView.animate(withDuration: 0.3) {
            switch self.curState {
            case .L:
                self.delegate?.switchChangToState(.R)
                self.curState = .R
            case .R:
                self.delegate?.switchChangToState(.L)
                self.curState = .L
            }
        }
    }
    
    ///  Update view's frame by UI state
    private func updateUIState(_ state: LabelSwitchUIState) {
        leftPart.setState(state.leftPartState)
        rightPart.setState(state.rightPartState)
        circleView.frame  = state.circleFrame
        backgroundColor = state.backgroundColor
    }
    
 
    ///  For InterfaceBuilder
    @IBInspectable var lBackColor: UIColor = .white {
        didSet{
            switchConfigL.backgroundColor = lBackColor
        }
    }
    
    @IBInspectable var rBackColor: UIColor = .white {
        didSet{
            switchConfigR.backgroundColor = rBackColor
        }
    }
    
    @IBInspectable var lTextColor: UIColor = .white {
        didSet{
            switchConfigL.textColor = lTextColor
        }
    }
    
    @IBInspectable var rTextColor: UIColor = .white {
        didSet{
            switchConfigR.textColor = rTextColor
        }
    }
    
    @IBInspectable var lText: String = "" {
        didSet{
            switchConfigL.text = lText
        }
    }
    
    @IBInspectable var rText: String = "" {
        didSet{
            switchConfigR.text = rText
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 10 {
        didSet{
            switchConfigL.font = .systemFont(ofSize: fontSize)
            switchConfigR.font = .systemFont(ofSize: fontSize)
        }
    }
    
    private var widthLayout: NSLayoutConstraint?
    private var heightLayout: NSLayoutConstraint?
    
    required public init?(coder aDecoder: NSCoder) {
        self.switchConfigL = LabelSwitchConfig.defaultLeft
        self.switchConfigR = LabelSwitchConfig.defaultRight
        self.circlePadding = 1
        self.minimumSize = .zero
        self.curState = .L
        super.init(coder: aDecoder)
        clipsToBounds = true
        updateUI()
        updateLayoutConstraint()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
        updateLayoutConstraint()
    }
    
    //if text switch is init through interface builder, we
    // need to add the width and height constarints according to the text and font
    private func updateLayoutConstraint() {
        if widthLayout != nil {
            removeConstraint(widthLayout!)
        }
        
        if heightLayout != nil {
            removeConstraint(heightLayout!)
        }
       
        widthLayout = NSLayoutConstraint(item: self,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: bounds.width)
        
        
        heightLayout = NSLayoutConstraint(item: self,
                                          attribute: .height,
                                          relatedBy: .equal,
                                          toItem: nil,
                                          attribute: .notAnAttribute,
                                          multiplier: 1.0,
                                          constant: bounds.height)
        addConstraint(widthLayout!)
        addConstraint(heightLayout!)
    }
}
