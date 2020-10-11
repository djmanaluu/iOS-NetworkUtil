# iOS - Network Util for API

This is the example for Network Util that used for API.
I use API from `https://dog.ceo/` as the example here, we will call random dog image (you can read the doc here `https://dog.ceo/dog-api/documentation/random`)

## Response

For the response, you should use Decodable data model object.

example
```swift
struct Response: Decodable {
    let message: String
    let status: String
}
```

## Call it by using Playground

From the documentation, we can see the Endpoint of the API is `https://dog.ceo/api/breeds/image/random`. We can see the code below here:

```swift
var response: Response?

NetworkUtil.request(from: "https://dog.ceo/api/breeds/image/random", responseType: Response.self, httpMethod: .get, parameters: nil, onSuccess: { apiResponse in
    response = apiResponse
}) { error in
    print(error.localizedDescription)
}
```

## Cancel the Request

There's a case when we need to cancel the request, for example when we requesting the API and we close the ViewController we should close the Request Process because we don't need the Response again and we should cancel the Request that run in the `Background Thread`

We can retain the `URLSessionDataTask` that return when we call `Network.request(from:responseType:httpMethod:parameters:onSuccess:onFailure:)`.

```swift
var response: Response?

let sessionDataTask: URLSessionDataTask? = NetworkUtil.request(from: "https://dog.ceo/api/breeds/image/random", responseType: Response.self, httpMethod: .get, parameters: nil, onSuccess: { apiResponse in
    response = apiResponse
}) { error in
    print(error.localizedDescription)
}


sessionDataTask?.cancel()
```
