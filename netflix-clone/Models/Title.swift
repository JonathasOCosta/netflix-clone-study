//
//  Movie.swift
//  netflix-clone
//
//  Created by user210401 on 3/9/22.
//

import Foundation

struct TrendingTitleResponse: Codable{
    
    let results: [Titles]
    
}

struct Titles: Codable{
    
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    
}
