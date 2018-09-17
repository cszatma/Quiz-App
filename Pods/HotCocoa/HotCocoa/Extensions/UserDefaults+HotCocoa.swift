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

import Foundation

public extension UserDefaults {
    /**
     Returns the codable object associated with the specified key.
     - parameter type: The type of the object being returned.
     - parameter forKey: They key associated with the data.
     - returns: The object associated with the specified key, or nil if the key was not found.
     - throws: An error if the data throws an error during decoding.
    */
    public func get<T: Codable>(type: T.Type, forKey key: String) throws -> T? {
        guard let data = object(forKey: key) as? Data else { return nil }
        
        return try PropertyListDecoder().decode(type, from: data)
    }
    
    /**
     Sets the value of the specified key.
     - parameter object: The object to store in the defaults database.
     - parameter forKey: They key associated with the data.
     - throws: An error if the object throws an error during encoding.
     */
    public func set<T: Codable>(object: T, forKey key: String) throws {
        set(try PropertyListEncoder().encode(object), forKey: key)
    }
}
