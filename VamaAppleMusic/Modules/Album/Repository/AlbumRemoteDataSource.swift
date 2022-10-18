//
//  AlbumRemoteDataSource.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 18/10/22.
//

import Foundation

class AlbumRemoteDataSource {
    
    /// fetchAlbumFeed
    /// - Parameters:
    ///   - success: success with AlbumFeed
    ///   - failure: failure with error message
    func fetchAlbumFeed(success: @escaping ((AlbumFeed) -> Void), failure: @escaping ((String) -> Void)) {
        HTTPManager.shared.getNetworkCall(strEndpoint: Constants.APPURL.APIEndPoint.albums, params: [String:Any]()) { (result) in
            do {
                let responseJson = try JSONDecoder().decode(AlbumResponse.self, from: result.data)
                guard let albumFeed = responseJson.feed else {
                    failure(Constants.Message.noRecord)
                    return
                }
                success(albumFeed)
            } catch {
                failure(Constants.Message.unknownError)
            }
        } failure: { (error) in
            failure(error.msg)
        }
    }
}
