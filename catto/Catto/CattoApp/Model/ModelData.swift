//
//  ModelData.swift
//  Catto
//
//  Created by Cris Messias on 24/10/24.
//

import Foundation
import SwiftUI

@Observable
class ModelData {
    var cattoPost: [Catto] = load("cattoData.json")
    var profile = Profile.default
    var showingProfile = false
    
    var filteredCattos: [Catto] {
        cattoPost.filter(\.isFavorite)
    }
    
    func getCattoBinding(for catto: Catto) -> Binding<Catto> {
        .init(
            get: {
                guard let index = self.getCattoIndex(for: catto) else { return catto }
                return self.cattoPost[index]
            },
            set: {
                guard let index = self.getCattoIndex(for: catto) else { return }
                self.cattoPost[index] = $0
            }
        )
    }

    func getCattoIndex(for catto: Catto) -> Int? {
        return cattoPost.firstIndex(where: { $0.id == catto.id })
    }

    func onNewCommentAdded(comment: String) -> Void {
        let index = cattoPost.count - 1
        let user = Catto.CattoUser(username: "Cris Messias", userImageUrl: "https://avatars.githubusercontent.com/u/6744444?v=4")
        let caption = Catto.CattoCaption(id: 1, user: user, caption: comment, vote: 1, isMostVoted: false)
        cattoPost[index].captionList.append(caption)
    }
    
    func onSwipeOut() -> Void {
        cattoPost.removeLast()
    }
}


func load<T: Decodable>(_ filename: String) -> T {
    let data: Data


    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }


    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }


    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
