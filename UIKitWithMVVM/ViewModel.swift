//
//  ViewModel.swift
//  UIKitWithMVVM
//
//  Created by Jerry Uhm on 2023/02/20.
//

import Foundation
import Combine

// Model
struct PostModel: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class ViewModel: ObservableObject {
    @Published var posts: [PostModel] = []
    // RxSwift의 diposableBag과 같은 
    var disposeBag = Set<AnyCancellable>()
    
    init() {
        print("ViewModel - Initialize")
    }
    
    func getPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        // combine dataTaskPublisher 를 이용한 데이타 published
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .sink(receiveValue: { [weak self] rcvPosts in
                self?.posts = rcvPosts
            })
            .store(in: &disposeBag)
    }
}
