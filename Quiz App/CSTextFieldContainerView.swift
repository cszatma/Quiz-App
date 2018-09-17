//
//  CSTextFieldContainerView.swift
//  CSKit
//
//  Created by Christopher Szatmary on 2017-09-25.
//  Copyright © 2017 Christopher Szatmary. All rights reserved.
//

import UIKit
import TinyConstraints

open class CSTextFieldContainerView: UIView {
    
    private var _textFields: [UITextField] = []
    private var heightConstraints: Constraints = []
    private var visibleTextFieldsCount = 0
    
    open var textFields: [UITextField] {
        return _textFields
    }
    
    /// Returns the number of text _textFields currently in the container.
    open var numberOfTextFields: Int {
        return _textFields.count
    }
    
    ///A Boolean value that determines whether the font size of each TextField should be adjusted to maintain a ratio with the size of the view. This property is true by default.
    ///Setting it to false will always keep the font at the defaultFontSize.
    open var shouldAdjustFontSizeToContainer: Bool = true {
        willSet {
            if newValue == false {
                shouldResizeFontWhenHidden = false
            }
        }
    }
    
    ///A Boolean value that determines whether the font size of each TextField should be adjusted when one of the TextFields is hidden. This property is true by default.
    ///Setting this property to false will keep the font at
    open var shouldResizeFontWhenHidden: Bool = true {
        willSet {
            if newValue == true {
                shouldAdjustFontSizeToContainer = true
            }
        }
    }
    
    open var defaultFontSize: CGFloat = 17 {
        willSet {
            if shouldAdjustFontSizeToContainer == false {
                setFontSize(newValue)
            } else {
                layoutSubviews()
            }
        }
    }
    
    /**
     Initializes and returns a newly allocated text field container view.
     
     - parameters:
         - numberOfTextFields: The number of text _textFields the view should have.
         - withPlaceholders: An array of strings containing the placeholders each text field should have. If the length of the array is less than the **numberOfTextFields** then no placeholder will be added to the text field.
         - frame: The frame rectangle for the view, measured in points.
     */
    public init(numberOfTextFields: Int, withPlaceholders: [String], frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)) {
        super.init(frame: frame)
        guard numberOfTextFields > 0 else {
            return
        }
        
        for i in 0..<numberOfTextFields {
            let textField = UITextField()
            textField.placeholder = i < withPlaceholders.count ? withPlaceholders[i] : ""
            textField.autocapitalizationType = .none
            _textFields.append(textField)
        }
        setupConstraints()
        visibleTextFieldsCount = _textFields.count
    }
    
    open override func layoutSubviews() {
        let ratio = 50/defaultFontSize
        //Called when a textfield is hidden
        if visibleTextFieldsCount != numberOfTextFields && shouldResizeFontWhenHidden {
            setFontSize((bounds.height/CGFloat(visibleTextFieldsCount))/ratio)
        } else if shouldAdjustFontSizeToContainer && visibleTextFieldsCount == numberOfTextFields { //Called after initialization
            setFontSize((bounds.height/CGFloat(numberOfTextFields))/ratio)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupConstraints() {
        
        for i in 0..<_textFields.count {
            addSubview(_textFields[i])
            _textFields[i].left(to: self, offset: 12)
            if i == 0 {
                _textFields[i].top(to: self)
            } else if i == _textFields.count - 1 {
                _textFields[i].bottom(to: self)
            } else {
                _textFields[i].topToBottom(of: _textFields[i - 1])
            }
            _textFields[i].width(to: self)
            let constraint = _textFields[i].height(to: self, multiplier: 1/CGFloat(_textFields.count))
            heightConstraints.append(constraint)
            
            if i != _textFields.count - 1 {
                let separator = UIView()
                separator.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
                
                addSubview(separator)
                separator.left(to: self)
                separator.topToBottom(of: _textFields[i])
                separator.width(to: self)
                separator.height(1)
            }
        }
    }
    
    public func toggleTextFieldVisibility(index: Int, isHidden: Bool) {
        
        guard index > -1 && index < _textFields.count else {
            fatalError("No such TextField at that index.")
        }
        
        _textFields[index].isHidden = isHidden
        visibleTextFieldsCount = isHidden == true ? visibleTextFieldsCount - 1 : visibleTextFieldsCount + 1
        
        for i in 0..<_textFields.count {
            if i == index {
                updateConstraint(&heightConstraints[i], to: _textFields[i].height(to: self, multiplier: isHidden == true ? 0 : 1/CGFloat(visibleTextFieldsCount), isActive: false))
                continue
            }
            updateConstraint(&heightConstraints[i], to: _textFields[i].height(to: self, multiplier: 1/CGFloat(visibleTextFieldsCount), isActive: false))
        }
    }
    
    public func setFontSize(_ size: CGFloat) {
        for i in 0..<_textFields.count {
            _textFields[i].font = _textFields[i].font?.withSize(size)
        }
    }
}
