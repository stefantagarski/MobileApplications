//
//  Comment.swift
//  MenuApp
//
//  Created by Stefan Tagarski on 27.3.26.
//

import Foundation

struct Comment: Identifiable {
    let id = UUID()
    let author: String
    let text: String
    let date: Date
}
