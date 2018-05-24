//
//  Book.swift
//  Biblio
//
//  Created by Developer on 27/04/2018.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation

class Book: Codable {
    var title: String
    var authors: [String]
    var publisher: String
    var publishedDate: Date
    var description: String
    var categories: [String]
    var language: String
    var imageLinks: ImageLinks
}

struct ImageLinks: Codable {
    var thumbnail: String
}
