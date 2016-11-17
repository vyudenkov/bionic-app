
/*

Converts A class to a dictionary, used for serializing dictionaries to JSON

Supported objects:
- Serializable derived classes (sub classes)
- Arrays of Serializable
- NSData
- String, Numeric, and all other NSJSONSerialization supported objects

*/

import Foundation



public class Serializable: NSObject {

    public func formatKey(key: String) -> String {
        return key
    }
    
    public func formatValue(value: Any?, forKey: String) -> Any? {
        return value
    }
    
    func setValue(dictionary: NSDictionary, value: Any?, forKey: String) {
        dictionary.setValue(formatValue(value: value, forKey: forKey), forKey: formatKey(key: forKey))
    }
    
    /**
    Converts the class to a dictionary.

    - returns: The class as an NSDictionary.
    */
    public func toDictionary() -> NSDictionary {
        
        let propertiesDictionary = NSMutableDictionary()
        let mirror = Mirror(reflecting: self)
        
        let properties = mirror.toDictionary(withSuperClass: false)
        for (propName, propValue) in properties {
            if let propValue: Any = self.unwrap(any: propValue) {
                if let serializablePropValue = propValue as? Serializable {
                    setValue(dictionary: propertiesDictionary, value: serializablePropValue.toDictionary(), forKey: propName)
                } else if let arrayPropValue = propValue as? [Serializable] {
                    let subArray = arrayPropValue.toNSDictionaryArray()
                    setValue(dictionary: propertiesDictionary, value: subArray as Any?, forKey: propName)
                } else if propValue is Int || propValue is Double || propValue is Float || propValue is Bool {
                    setValue(dictionary: propertiesDictionary, value: propValue as Any?, forKey: propName)
                } else if let dataPropValue = propValue as? Data {
                    setValue(dictionary: propertiesDictionary,
                        value: dataPropValue.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters) as Any?, forKey: propName)
                } else if let datePropValue = propValue as? Date {
                    setValue(dictionary: propertiesDictionary, value: datePropValue.timeIntervalSince1970 as Any?, forKey: propName)
                } else if let uuidPropValue = propValue as? UUID {
                    setValue(dictionary: propertiesDictionary, value: uuidPropValue.uuidString as Any?, forKey: propName)
                } else {
                    setValue(dictionary: propertiesDictionary, value: propValue as Any?, forKey: propName)
                }
            } else if let propValue: Int8 = propValue as? Int8 {
                setValue(dictionary: propertiesDictionary, value: propValue as Any?, forKey: propName)
            } else if let propValue: Int16 = propValue as? Int16 {
                setValue(dictionary: propertiesDictionary, value: propValue as Any?, forKey: propName)
            } else if let propValue: Int32 = propValue as? Int32 {
                setValue(dictionary: propertiesDictionary, value: propValue as Any?, forKey: propName)
            } else if let propValue: Int64 = propValue as? Int64 {
                setValue(dictionary: propertiesDictionary, value: propValue as Any?, forKey: propName)
            } else if let propValue: UInt8 = propValue as? UInt8 {
                setValue(dictionary: propertiesDictionary, value: propValue as Any?, forKey: propName)
            } else if let propValue: UInt16 = propValue as? UInt16 {
                setValue(dictionary: propertiesDictionary, value: propValue as Any?, forKey: propName)
            } else if let propValue: UInt32 = propValue as? UInt32 {
                setValue(dictionary: propertiesDictionary, value: propValue as Any?, forKey: propName)
            } else if let propValue: UInt64 = propValue as? UInt64 {
                setValue(dictionary: propertiesDictionary, value: propValue as Any?, forKey: propName)
            } else if isEnum(any: propValue) {
                setValue(dictionary: propertiesDictionary, value: "\(propValue)" as Any?, forKey: propName)
            }
        }

        return propertiesDictionary
    }

    /**
    Converts the class to JSON.

    - returns: The class as JSON, wrapped in NSData.
    */
    public func toJson(prettyPrinted: Bool = false) -> Data? {
        let dictionary = self.toDictionary()

        if JSONSerialization.isValidJSONObject(dictionary) {
            do {
                let json = try JSONSerialization.data(withJSONObject: dictionary, options: (prettyPrinted ? .prettyPrinted: JSONSerialization.WritingOptions()))
                return json
            } catch let error as NSError {
                print("ERROR: Unable to serialize json, error: \(error)")
            }
        }

        return nil
    }

    /**
    Converts the class to a JSON string.

    - returns: The class as a JSON string.
    */
    public func toJsonString(prettyPrinted: Bool = false) -> String? {
        if let jsonData = self.toJson(prettyPrinted: prettyPrinted) {
            return String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        }
        return nil
    }
    
    
    /**
    Unwraps 'any' object. See http://stackoverflow.com/questions/27989094/how-to-unwrap-an-optional-value-from-any-type

    - returns: The unwrapped object.
    */
    func unwrap(any: Any) -> Any? {
        let mi = Mirror(reflecting: any)
        if mi.displayStyle != .optional {
            return any
        }
        
        if mi.children.count == 0 { return nil }
        let (_, some) = mi.children.first!
        return some
    }
    
    func isEnum(any: Any) -> Bool {
        return Mirror(reflecting: any).displayStyle == .enum
    }
    
    /*convenience init(jsonString: String) {
        self.init()
        if let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false) {
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any?]
                for (key, value) in json {
                    let keyName = key as String
                    if (self.responds(to: NSSelectorFromString(keyName))) {
                        self.setValue(value, forKey: keyName)
                    }
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }*/
    
    static func fromJson<T: Serializable>(jsonString: String, createFunction: (Dictionary<String, Any>) -> T) -> T? {
        if let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false) {
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! Dictionary<String, Any>
                return createFunction(json)
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    static func jsonDictionary(jsonString: String) -> Dictionary<String, Any>? {
        if let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false) {
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! Dictionary<String, Any>
                return json
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func fromJson<T: Serializable>(jsonString: String, createFunction: (Dictionary<String, Any>) -> T?) -> [T] {
        
        if let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false) {
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any?] {
                    var result : [T] = []
                    for item in json {
                        if let item = item as? Dictionary<String, Any>, let a = createFunction(item) {
                            result.append(a)
                        }
                    }
                    return result
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        return []
    }


    
    static func initialize(obj: AnyObject, jsonString: String) {
    
        if let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false) {
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! Dictionary<String, Any>
                for (key, value) in json {
                    let keyName = key as String
                    if (obj.responds(to: NSSelectorFromString(keyName))) {
                        obj.setValue(value, forKey: keyName)
                    }
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

