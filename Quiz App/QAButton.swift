//
//  QAButton.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2017-04-19.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import CSKitUniversal

class QAButton: CSButton {
    
    init(image: UIImage, target: Selector) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setBackgroundImage(image, for: .normal)
        self.cornerRadius = 5
        self.addTarget(nil, action: target, for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
