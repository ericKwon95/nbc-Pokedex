//
//  NetworkManager.swift
//  Pokedex
//
//  Created by 권승용 on 12/27/24.
//

import Foundation
import RxSwift

enum NetworkError: LocalizedError {
    case invalidURL
    case dataFetchFail
    case decodingFail
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL 입니다."
        case .dataFetchFail:
            return "데이터 가져오기에 실패했습니다."
        case .decodingFail:
            return "데이터 디코딩에 실패했습니다."
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let session = URLSession.shared
    
    private init() {}
    
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single.create { observer in
            let session = URLSession.shared
            session.dataTask(with: URLRequest(url: url)) { data, response, error in
                
                if let error = error {
                    observer(.failure(error))
                    return
                }
                
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    observer(.failure(NetworkError.dataFetchFail))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(decodedData))
                } catch let error{
                    observer(.failure(error))
                }
            }.resume()
            
            return Disposables.create()
        }
    }
}
