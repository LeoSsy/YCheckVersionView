//
//  ViewController.swift
//  YCheckVersionView
//
//  Created by shusy on 2017/11/2.
//  Copyright © 2017年 杭州爱卿科技. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let view = YCheckVersionView(updatedDelArray: ["1.解决了bug","1.解决了bug","1.解决了bug","1.解决了bbug","1.解决了bbug"], isForcedUpdate: false, versionStr: "1.0", updateURLString: "http://www.baidu.com")
        view.show()
    }
}

