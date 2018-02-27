//
//  Model.swift
//  ContentsSwitch
//
//  Created by cookie on 20/02/2018.
//  Copyright © 2018 cookie. All rights reserved.
//

import Foundation
import UIKit

public struct LabelSwtichSetting {
    public var text: String
    public var textColor: UIColor
    public var font: UIFont
    public var backgroundColor: UIColor
    
    public init(text: String, textColor: UIColor, font: UIFont, backgroundColor: UIColor) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.backgroundColor = backgroundColor
    }
    
    public static let defaultLeft = LabelSwtichSetting(text: "Left",
                                                  textColor: .white,
                                                  font: UIFont.boldSystemFont(ofSize: 20),
                                                  backgroundColor: .green)
    
    public static let defaultRight = LabelSwtichSetting(text: "Right",
                                               textColor: .white,
                                               font: UIFont.boldSystemFont(ofSize: 20),
                                               backgroundColor: .red)
}

public enum SwitchState {
    case L
    case R
}



