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

/**
 The SegueHandler protocol implements a safe way to handle segues and segue identifiers.
 Provides compile time checks of segue identifiers.
 */
public protocol SegueHandler {
    associatedtype SegueIdentifier: RawRepresentable
}

public extension SegueHandler where
Self: HCViewController, SegueIdentifier.RawValue == String {

    /**
     Initiates the segue with the specified identifier.
     - parameter withIdentifier: A SegueIdentifier type with a string raw value. Used to trigger the segue.
     - parameter sender: The object that you want to use to initiate the segue. This object is made available for informational purposes during the actual segue.
     */
    public func performSegue(withIdentifier: SegueIdentifier, sender: Any?) {
        #if os(macOS)
            let identifier = NSStoryboardSegue.Identifier(withIdentifier.rawValue)
        #else
            let identifier = withIdentifier.rawValue
        #endif
        performSegue(withIdentifier: identifier, sender: sender)
    }

    /**
     Gets the identifier of a given segue.
     - parameter forSegue: The currently triggered Segue.
     */
    public func segueIdentifier(forSegue segue: HCStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier else { fatalError("Segue does not have an identifier") }
        
        #if os(macOS)
            let id = identifier.rawValue
        #else
            let id = identifier
        #endif
        
        guard let segueIdentifier = SegueIdentifier.init(rawValue: id) else {
            fatalError("Invalid segue identifier \(String(describing: segue.identifier))")
        }
        
        return segueIdentifier
    }
}
