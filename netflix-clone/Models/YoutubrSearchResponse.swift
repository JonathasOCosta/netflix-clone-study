//
//  YoutubrSearchResponse.swift
//  netflix-clone
//
//  Created by user210401 on 3/10/22.
//

import Foundation


struct YoutubeSearchResponse: Codable {
    
    let items: [VideoElement]
    
}

struct VideoElement: Codable {
    
    let id: IdVideoElement
    
}

struct IdVideoElement: Codable {
    
    let kind: String
    let videoId: String
    
}
