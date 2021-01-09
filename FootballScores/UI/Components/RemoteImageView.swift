//
//  RemoteImageView.swift
//  FootballScores
//
//  Created by Michal on 28/12/2020.
//

import SwiftUI

// struct RemoteImage: View {
//    private enum LoadState {
//        case loading, success, failure
//    }
//
//    private class Loader: ObservableObject {
//        var data = Data()
//        var state = LoadState.loading
//
//        init(url: String) {
//            guard let parsedURL = URL(string: url) else {
//                fatalError("Invalid URL: \(url)")
//            }
//
//            URLSession.shared.dataTask(with: parsedURL) { data, _, _ in
//                if let data = data, data.count > 0 {
//                    self.data = data
//                    self.state = .success
//                } else {
//                    self.state = .failure
//                }
//
//                DispatchQueue.main.async {
//                    self.objectWillChange.send()
//                }
//            }.resume()
//        }
//    }
//
//    @StateObject private var loader: Loader
//    var loading: Image
//    var failure: Image
//
//    var body: some View {
//        selectImage()
//            .resizable()
//    }
//
//    init(url: String, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName: "multiply.circle")) {
//        _loader = StateObject(wrappedValue: Loader(url: url))
//        self.loading = loading
//        self.failure = failure
//    }
//
//    private func selectImage() -> Image {
//        switch loader.state {
//        case .loading:
//            return loading
//        case .failure:
//            return failure
//        default:
//            if let image = UIImage(data: loader.data) {
//                return Image(uiImage: image)
//            } else {
//                return failure
//            }
//        }
//    }
// }

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
