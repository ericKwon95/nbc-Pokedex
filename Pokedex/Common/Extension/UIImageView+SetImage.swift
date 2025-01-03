//
//  UIImageView+.swift
//  Pokedex
//
//  Created by 권승용 on 1/2/25.
//

import UIKit

extension UIImageView {
    func setImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}
