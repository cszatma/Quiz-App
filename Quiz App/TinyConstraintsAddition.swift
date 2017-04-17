//
//  TinyConstraintsAddition.swift
//  Quiz App
//
//  Created by Christopher Szatmary on 2017-04-16.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

//Adding methods to TinyConstraints that allow use of multiplier until they are made part of the framework. Hopefully that will happen soon.

import TinyConstraints

extension Constrainable {
    @discardableResult
    public func widthWithMultiplier(to view: UIView, _ dimension: NSLayoutDimension? = nil, offset: CGFloat = 0, multiplier: CGFloat = 0, priority: ConstraintPriority = .required, isActive: Bool = true) -> Constraint {
        var constraint: Constraint

        if offset != 0 && multiplier != 0 {
            constraint = widthAnchor.constraint(equalTo: dimension ?? view.widthAnchor, multiplier: multiplier, constant: offset).with(priority)
        } else if multiplier != 0 {
            constraint = widthAnchor.constraint(equalTo: dimension ?? view.widthAnchor, multiplier: multiplier).with(priority)
        } else {
            constraint = widthAnchor.constraint(equalTo: dimension ?? view.widthAnchor, constant: offset).with(priority)
        }
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func heightWithMultiplier(to view: UIView, _ dimension: NSLayoutDimension? = nil, offset: CGFloat = 0, multiplier: CGFloat = 0, priority: ConstraintPriority = .required, isActive: Bool = true) -> Constraint {
       var constraint: Constraint

        if offset != 0 && multiplier != 0 {
            constraint = heightAnchor.constraint(equalTo: dimension ?? view.heightAnchor, multiplier: multiplier, constant: offset).with(priority)
        } else if multiplier != 0 {
            constraint = heightAnchor.constraint(equalTo: dimension ?? view.heightAnchor, multiplier: multiplier).with(priority)
        } else {
            constraint = heightAnchor.constraint(equalTo: dimension ?? view.heightAnchor, constant: offset).with(priority)
        }
        constraint.isActive = isActive
        return constraint
    }
}
