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
        labelSwitch.curState = .R
        labelSwitch.circleShadow = false
        labelSwitch.fullSizeTapEnabled = true
        // Do any additional setup after loading the view, typically from a nib.


        // Set the default state of the switch,
        
        let ls2 = LabelSwitchConfig(text: "Left",
                              textColor: .white,
                                   font: .boldSystemFont(ofSize: 20),
                         gradientColors: [UIColor.red.cgColor, UIColor.purple.cgColor], startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
        
        let rs2 = LabelSwitchConfig(text: "Right",
                              textColor: .white,
                                   font: .boldSystemFont(ofSize: 20),
                         gradientColors: [UIColor.yellow.cgColor, UIColor.orange.cgColor], startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
        
        let gradientLabelSwitch = LabelSwitch(center: CGPoint(x: view.center.x, y: view.center.y + 100), leftConfig: ls2, rightConfig: rs2, defaultState: .L)
        view.addSubview(gradientLabelSwitch)
        
        let ls3 = LabelSwitchConfig(text: "Fire",
                                    textColor: .white,
                                    font: .boldSystemFont(ofSize: 20),
                                    image: UIImage(named: "fire.jpg"))
        
        let rs3 = LabelSwitchConfig(text: "Water",
                                    textColor: .white,
                                    font: .boldSystemFont(ofSize: 20),
                                    image: UIImage(named: "water.jpg"))
        
        let imageLabelSwitch = LabelSwitch(center: CGPoint(x: view.center.x, y: view.center.y + 200), leftConfig: ls3, rightConfig: rs3, defaultState: .L)
        view.addSubview(imageLabelSwitch)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: LabelSwitchDelegate {
    func switchChangToState(_ state: LabelSwitchState) {
        switch state {
        case .L: print("circle on left")
        case .R: print("circle on right")
        }
    }
}

