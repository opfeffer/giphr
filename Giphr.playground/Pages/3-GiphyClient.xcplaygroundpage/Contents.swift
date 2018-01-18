import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

//: GiphyClient

import Foundation
import GiphyClient

let client = GiphyClient(apiKey: "JdkpB5PzrlyqKFmoEjS5VKXsxgGWm3JB")

client.random { (result) in
    print(result)

    PlaygroundPage.current.finishExecution()
}

//client.trending { (result) in
//    print(result.value?.first)
//
//    PlaygroundPage.current.finishExecution()
//}

