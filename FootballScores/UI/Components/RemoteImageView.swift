//
//  RemoteImageView.swift
//  FootballScores
//
//  Created by Michal on 28/12/2020.
//

import SwiftUI

struct RemoteImage: View {
    @ObservedObject var imageUrl: LoadUrlImage

    init(url: String) {
        imageUrl = LoadUrlImage(imageURL: url)
    }

    var body: some View {
        Image(uiImage: UIImage(data: self.imageUrl.data) ?? UIImage())
            .resizable()
            .clipped()
    }
}

class LoadUrlImage: ObservableObject {
    @Published var data = Data()
    init(imageURL: String) {
        let cache = URLCache.shared
        let request = URLRequest(url: URL(string: imageURL)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60.0)
        if let data = cache.cachedResponse(for: request)?.data {
            self.data = data
        } else {
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, _ in
                if let data = data, let response = response {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        self.data = data
                    }
                }
            }).resume()
        }
    }
}
