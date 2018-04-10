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
    func switchChangToState(_ state: SwitchState) -> Void
}

struct TextTypeUIState {
    var circleFrame:        CGRect = .zero
    
    var leftBgFrame:        CGRect = .zero
    var rightBgFrame:       CGRect = .zero
    
    var leftTextMaskFrame:  CGRect = .zero
    var rightTextMaskFrame: CGRect = .zero
    
    var backgroundColor:    UIColor = .clear
}

@IBDesignable public class LabelSwitch: UIView {
    
    private let circleView = UIView()
    
    private let leftTextBackground  = UIView()
    private let rightTextBackground = UIView()

    private let leftTextMask  = CALayer()
    private let rightTextMask = CALayer()

    private let leftLabel  = UILabel()
    private let rightLabel = UILabel()
    
    private var leftSetting:  LabelSwtichSetting
    private var rightSetting: LabelSwtichSetting
    
    private var edge: CGFloat = 0
    private let circlePadding: CGFloat
    
    private var leftUIState  = TextTypeUIState()
    private var rightUIState = TextTypeUIState()
    
    private var fullSizeTapGesture: UITapGestureRecognizer?
    
    public weak var delegate: LabelSwitchDelegate?
    public var curState: SwitchState {
        didSet{
            switch curState {
            case .L: updateUIState(leftUIState)
            case .R: updateUIState(rightUIState)
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
    
    @IBInspectable var lBackColor: UIColor = .white {
        didSet{
            leftSetting.backgroundColor = lBackColor
        }
    }
    @IBInspectable var rBackColor: UIColor = .white {
        didSet{
            rightSetting.backgroundColor = rBackColor
        }
    }
    
    @IBInspectable var lTextColor: UIColor = .white {
        didSet{
            leftSetting.textColor = lTextColor
        }
    }
    
    @IBInspectable var rTextColor: UIColor = .white {
        didSet{
            rightSetting.textColor = rTextColor
        }
    }

    @IBInspectable var lText: String = "" {
        didSet{
            leftSetting.text = lText
        }
    }
    
    @IBInspectable var rText: String = "" {
        didSet{
            rightSetting.text = rText
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 10 {
        didSet{
            leftSetting.font = UIFont.systemFont(ofSize: fontSize)
            rightSetting.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    private var widthLayout: NSLayoutConstraint?
    private var heightLayout: NSLayoutConstraint?

    public init(center: CGPoint, leftSetting: LabelSwtichSetting, rightSetting: LabelSwtichSetting, circlePadding: CGFloat = 1, defaultState: SwitchState = .L) {
        self.leftSetting = leftSetting
        self.rightSetting = rightSetting
        self.circlePadding = circlePadding
        self.curState = defaultState
        super.init(frame: .zero)
        self.center = center
        clipsToBounds = true
        addSubview(leftTextBackground)
        addSubview(rightTextBackground)
        addSubview(leftLabel)
        addSubview(rightLabel)
        addSubview(circleView)
        updateUI()
    }

    private func updateUI() {
        setupBounds()
        setupTextMask()
        setupTextBackground()
        setupBackgroundColor()
        setupText()
        setupCircle()
        
        switch curState {
        case .L: updateUIState(leftUIState)
        case .R: updateUIState(rightUIState)
        }
    }
    
    /// Calculate the bounds of the switch accourding to the label's text and font size
    private func setupBounds () {
        let circleSize = max(leftSetting.font.pointSize, rightSetting.font.pointSize) * 2
        edge = circleSize * 0.2
        leftLabel.text = leftSetting.text
        leftLabel.font  = leftSetting.font
        leftLabel.sizeToFit()
        rightLabel.text = rightSetting.text
        rightLabel.font = rightSetting.font
        rightLabel.sizeToFit()
        
        let width = max(leftLabel.bounds.width, rightLabel.bounds.width) + 2 * edge + circleSize + 2 * circlePadding
        bounds = CGRect(x: 0, y: 0, width: width, height: circleSize + 2 * circlePadding)
        layer.cornerRadius = bounds.height / 2
    }

    
    /// Calculate the left frame and right frame for the circle
    private func setupCircle() {
        let circleSize = bounds.height - 2 * circlePadding
        circleView.backgroundColor = .white
        circleView.layer.cornerRadius = circleSize / 2
        circleView.layer.shadowColor = UIColor.black.cgColor
        circleView.layer.shadowOffset = CGSize(width: 0, height: 2)
        circleView.layer.shadowOpacity = 0.5
        circleView.layer.shadowRadius = bounds.height * 0.05
        
        let leftFrame  = CGRect(x: circlePadding,
                                y: circlePadding,
                                width: circleSize,
                                height: circleSize)
        
        let rigthFrame = CGRect(x: bounds.width - circleSize - circlePadding,
                                y: circlePadding,
                                width: circleSize,
                                height: circleSize)
        
        leftUIState.circleFrame = leftFrame
        rightUIState.circleFrame = rigthFrame
       
        /// Add the touch event to the circle view
        circleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchTaped(sender:))))
    }
    
    
    /// Set the label's frame and color
    private func setupText() {
        leftLabel.bounds  = CGRect(x: 0,
                                   y: 0,
                                   width: leftLabel.bounds.width,
                                   height: leftLabel.bounds.height)
        
        rightLabel.bounds = CGRect(x: 0,
                                   y: 0,
                                   width: rightLabel.bounds.width,
                                   height: rightLabel.bounds.height)
        
        
        leftLabel.center  = CGPoint(x: (bounds.width - bounds.height) / 2 + edge / 2,
                                    y: bounds.height / 2)
        
        rightLabel.center = CGPoint(x: (bounds.width + bounds.height) / 2 - edge / 2,
                                    y: bounds.height / 2)
        
        
        leftLabel.textColor  = leftSetting.textColor
        rightLabel.textColor = rightSetting.textColor
        leftLabel.textAlignment = .center
        rightLabel.textAlignment = .center
    }
    
    
    /// Set the frame for the text mask
    private func setupTextMask() {
        leftUIState.leftTextMaskFrame  = CGRect(x: -bounds.width,
                                                y: 0,
                                                width: bounds.width,
                                                height: bounds.height)
        
        leftUIState.rightTextMaskFrame = CGRect(x: 0,
                                                y: 0,
                                                width: bounds.width,
                                                height: bounds.height)
        
        rightUIState.leftTextMaskFrame  = CGRect(x: 0,
                                                 y: 0,
                                                 width: bounds.width,
                                                 height: bounds.height)
        
        rightUIState.rightTextMaskFrame = CGRect(x: bounds.width,
                                                 y: 0,
                                                 width: bounds.width,
                                                 height: bounds.height)
        
        leftTextMask.backgroundColor = UIColor.black.cgColor
        rightTextMask.backgroundColor = UIColor.black.cgColor
        
        leftLabel.layer.mask  = leftTextMask
        rightLabel.layer.mask = rightTextMask
    }
    
    
    /// Set the frame for background, which has the same frame with the text mask
    private func setupTextBackground() {
        leftUIState.leftBgFrame  = leftUIState.leftTextMaskFrame
        leftUIState.rightBgFrame = leftUIState.rightTextMaskFrame
        
        rightUIState.leftBgFrame  = rightUIState.leftTextMaskFrame
        rightUIState.rightBgFrame = rightUIState.rightTextMaskFrame
        
        leftTextBackground.backgroundColor  = leftSetting.backgroundColor
        rightTextBackground.backgroundColor = rightSetting.backgroundColor
        
        leftTextBackground.layer.cornerRadius  = bounds.height / 2
        rightTextBackground.layer.cornerRadius = bounds.height / 2
    }
    
    private func setupBackgroundColor() {
        leftUIState.backgroundColor = leftSetting.backgroundColor
        rightUIState.backgroundColor = rightSetting.backgroundColor
    }

    /// Called when the circle is touched
    @objc func switchTaped(sender: Any) {
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
    private func updateUIState(_ state: TextTypeUIState) {
        circleView.frame          = state.circleFrame
        leftTextMask.frame        = state.leftTextMaskFrame
        rightTextMask.frame       = state.rightTextMaskFrame
        
        leftTextBackground.frame  = state.leftBgFrame
        rightTextBackground.frame = state.rightBgFrame
        backgroundColor = state.backgroundColor
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        self.leftSetting = LabelSwtichSetting.defaultLeft
        self.rightSetting = LabelSwtichSetting.defaultRight
        self.circlePadding = 1
        self.curState = .L
        super.init(coder: aDecoder)
        clipsToBounds = true
        addSubview(leftTextBackground)
        addSubview(rightTextBackground)
        addSubview(leftLabel)
        addSubview(rightLabel)
        addSubview(circleView)
        
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
