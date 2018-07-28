//
//  Model.swift
//  ContentsSwitch
//
//  Created by cookie on 20/02/2018.
//  Copyright © 2018 cookie. All rights reserved.
//

import Foundation
import UIKit


public struct LabelSwitchConfig {
    struct GradientBack {
        var colors: [CGColor]
        var startPoint: CGPoint
        var endPoint: CGPoint
    }

    var text: String
    var textColor: UIColor
    var font: UIFont
    var backgroundColor: UIColor
    var backGradient: GradientBack?
    var backImage: UIImage?
    
    public init(text: String, textColor: UIColor, font: UIFont, backgroundColor: UIColor) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.backgroundColor = backgroundColor
    }
    
    public init(text: String, textColor: UIColor, font: UIFont, gradientColors: [CGColor], startPoint: CGPoint, endPoint: CGPoint) {
        self.init(text: text, textColor: textColor, font: font, backgroundColor: .white)
        self.backGradient = GradientBack(colors: gradientColors, startPoint: startPoint, endPoint: endPoint)
    }
    
    public init(text: String, textColor: UIColor, font: UIFont, image: UIImage?) {
        self.init(text: text, textColor: textColor, font: font, backgroundColor: .white)
        self.backImage = image
    }
    
    public static let defaultLeft = LabelSwitchConfig(text: "Left",
                                                 textColor: .white,
                                                      font: .boldSystemFont(ofSize: 20),
                                           backgroundColor: UIColor.red)
    
    public static let defaultRight = LabelSwitchConfig(text: "Right",
                                                  textColor: .white,
                                                       font: .boldSystemFont(ofSize: 20),
                                            backgroundColor: UIColor.blue)
}

public enum LabelSwitchState {
    case L
    case R
}



