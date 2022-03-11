//
//  Extensions.swift
//  netflix-clone
//
//  Created by user210401 on 3/9/22.
//

import Foundation


extension String {
    
    func captalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
