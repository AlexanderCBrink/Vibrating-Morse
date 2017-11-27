//
//  ViewController.swift
//  Vibrating Morse
//
//  Created by Alexander Christiaan Brink on 2017/11/27.
//  Copyright © 2017 Andile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var connectionsLabel: UILabel!
    
    let colorService = ColorServiceManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        colorService.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var change: UIButton!
    @IBAction func changePressed(_ sender: Any) {
        print("YO")
        colorService.send(colorName: "yellow")
        
    }
    
}

extension ViewController : ColorServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: ColorServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            print("Connections: \(connectedDevices)")
        }
    }
    
    func colorChanged(manager: ColorServiceManager, colorString: String) {
        OperationQueue.main.addOperation {
            switch colorString {
            case "red":
                NSLog("%@", "Unknown color value received: \(colorString)")
            case "yellow":
                NSLog("%@", "Unknown color value received: \(colorString)")
            default:
                NSLog("%@", "Unknown color value received: \(colorString)")
            }
        }
    }
}
