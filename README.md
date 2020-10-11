# iOS - Network Util for API

This is the example for Network Util that used for API.
For the response, you should use Decodable data model object.

example
```swift
struct Response: Codable {
    let variableOne: String
    let variableTwo: Int
    
    enum CodingKeys: String, CodingKey {
        case variableOne = "variable_one"
        case varibaleTwo = "variable_two"
    }
}
```
