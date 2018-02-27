//
//  ViewController.swift
//  LabelSwitch
//
//  Created by zhu.bingyi@donuts.ne.jp on 02/27/2018.
//  Copyright (c) 2018 zhu.bingyi@donuts.ne.jp. All rights reserved.
//

import UIKit
import LabelSwitch

class ViewController: UIViewController {

    @IBOutlet weak var labelSwitch: LabelSwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelSwitch.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: LabelSwitchDelegate {
    func switchChangToState(_ state: SwitchState) {
        switch state {
        case .L: print("circle on left")
        case .R: print("circle on right")
        }
    }
}

