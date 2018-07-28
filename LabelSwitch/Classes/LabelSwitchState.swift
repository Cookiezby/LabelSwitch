//
//  LabelSwitchState.swift
//  LabelSwitch
//
//  Created by cookie on 2018/7/28.
//

import Foundation

struct LabelSwitchPartState {
    var backMaskFrame: CGRect = .zero
}

struct LabelSwitchUIState {
    var backgroundColor: UIColor = .clear
    var circleFrame:CGRect = .zero
    var leftPartState  = LabelSwitchPartState()
    var rightPartState = LabelSwitchPartState()
}
