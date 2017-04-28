//
//  QAController.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2017-04-25.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import Foundation

///A QAController is a template for a ViewController that stores the value of the user currently logged in.
protocol QAController: class {
    
    var user: User! { get set }
    
}
