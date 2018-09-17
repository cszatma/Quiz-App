//
//  TinyContraintsAdditions.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2018-09-16.
//  Copyright © 2018 Christopher Szatmary. All rights reserved.
//

import TinyConstraints

public func updateConstraint(_ constraint: inout Constraint, to newConstraint: Constraint) {
    constraint.isActive = false
    constraint = newConstraint
    constraint.isActive = true
}
