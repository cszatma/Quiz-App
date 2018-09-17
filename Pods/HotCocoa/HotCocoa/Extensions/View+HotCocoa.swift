//    Copyright (c) 2017 Christopher Szatmary <cs@christopherszatmary.com>
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

public extension HCView {
    
    // - MARK: Properties
    
    /// The cornerRadius of the view.
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            #if os(macOS)
            guard let layer = layer else { return -1 }
            #endif
            
            return layer.cornerRadius
        }
        set {
            #if os(macOS)
            guard let layer = layer else { return }
            #endif
            
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    
    /// The width of the view.
    public var frameWidth: CGFloat {
        get { return frame.width }
        set { frame.size.width = newValue }
    }
    
    /// The height of the view.
    public var frameHeight: CGFloat {
        get { return frame.height }
        set { frame.size.height = newValue }
    }
    
    // - MARK: Methods
    
    /// Sets the width and color of the layer's border.
    public func setBorder(width: CGFloat, color: HCColor) {
        #if os(macOS)
        guard let layer = layer else { return }
        #endif
        
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}
