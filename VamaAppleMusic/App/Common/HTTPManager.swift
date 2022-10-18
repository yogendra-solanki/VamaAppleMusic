//
//  HTTPManager.swift
//  SampleMusicApp
//
//  Created by Yogendra Solanki on 17/10/22.
//

import Foundation

/// Completion Blocks
typealias networkSuccessBlock = (NetworkResult) -> Void
typealias networkFailureBlock = (NetworkError) -> Void

class HTTPManager: NSObject {
    
    static let shared = HTTPManager() // Singleton
    /// setup url session
    var urlSession:URLSession = {
        let config = URLSessionConfiguration.default // Session Configuration
        config.timeoutIntervalForRequest = 60.0
        let session = URLSession(configuration: config)// Load configuration into Session
        return session
    }()
    
    /// - Parameters:
    ///   - strEndpoint: api endpoint
    ///   - params: dict of param
    ///   - success: success
    ///   - failure: failure
    func getNetworkCall(strEndpoint: String,params : [String : Any], success:@escaping networkSuccessBlock, failure:@escaping networkFailureBlock ) {
        
        //append endpoint in base url
        var combineUrl = Constants.APPURL.BaseURL + strEndpoint
        
        var urlRequest:URLRequest
        
        if params.count > 0 {
            combineUrl = combineUrl + params.queryString
        }
        guard let url = NSURL(string:combineUrl) else {
            return
        }
        urlRequest = URLRequest(url: url as URL)
        
        urlRequest.httpMethod = NetworkHttpMethod.get.rawValue
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil, let json = self.jsonSerializationWithData(data: data)
            else {
                var code = NSURLErrorUnknown
                
                if let errorNotNull = error {
                    code = (errorNotNull as NSError).code
                }
                
                let msg = self.prepareErrorResponce(code: code)
                failure(NetworkError(msg: msg, code: code))
                return
            }
            guard let dataNotNull =  data else {
                failure(NetworkError(msg: Constants.Message.unknownError, code: 0))
                return
            }
            success(NetworkResult(data: dataNotNull, value: json))
            return
            
        }
        task.resume()
        
    }
    
    //    /// method for JSON serialization
    ///
    /// - Parameter data: response data
    /// - Returns: key value pair
    private func jsonSerializationWithData(data:Data?) -> [String:Any]? {
        
        guard let notNullData = data else {
            return nil
        }

        do
        {
            let response = try JSONSerialization.jsonObject(with: notNullData, options: .allowFragments) as? [String:Any]
            return response
        } catch
        {
            debugPrint("error in JSONSerialization")
            debugPrint(String.init(data: data ?? Data(), encoding: .utf8) ?? "")
            
        }
        return nil
    }
    
    /// Prepare error message according to Error Code
    ///
    /// - Parameter code: code INT
    /// - Returns: Message
    private func prepareErrorResponce(code: Int) -> String {
        var msg = ""
        switch code{
        case NSURLErrorTimedOut:
            msg = Constants.Message.requestTimeOut
        case NSURLErrorNotConnectedToInternet,NSURLErrorCannotConnectToHost:
            msg = Constants.Message.noInternet
        case NSURLErrorNetworkConnectionLost:
            msg = Constants.Message.connectionLost
        default:
            msg = Constants.Message.unknownError
        }
        return msg
    }
    
}

/// Error type
struct NetworkError {
    var msg:String
    var code:Int
    /// init Eror object
    ///
    /// - Parameters:
    ///   - msg: error message
    ///   - code: error code
    ///   - type: error type (api failure response, server failed to respond)
    init(msg : String, code: Int) {
        self.code = code
        self.msg = msg
    }
}

/// define result type
struct NetworkResult {
    var data:Data
    var value:[String:Any]
    
    /// init result object
    ///
    /// - Parameters:
    ///   - data: in form of binary data
    ///   - value: key/value pair value
    init(data : Data, value: [String:Any]) {
        self.data = data
        self.value = value
    }
}

/// http method
private enum NetworkHttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            output +=  "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        output = "?" + output
        let newStr = output.replacingOccurrences(of: " ", with: "+")
        return newStr
    }
}
