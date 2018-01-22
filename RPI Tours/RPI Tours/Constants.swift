//
//  Constants.swift
//  RPI Tours
//
//  Created by John Behnke on 10/8/17.
//  Copyright © 2017 RPI Web Tech. All rights reserved.
//

import Foundation
import UIKit

struct Constants{
    struct URLS {
        private struct Domains {
            static let prod = "http://ru-webtech01.union.rpi.edu:9000"
            static let local =  "http://localhost:9000"
        }
        private struct Routes {
            static let basePath = "/api/v1"
            static let categories = "/categories"
            static let tours = "/tours"
        }
        
        private static let Domain = Domains.local
        
        static var allCategoriesPath : String {
            return Domain + Routes.basePath + Routes.categories
        }
        static func toursFor(categoryId: Int) -> String {
            return Domain + Routes.basePath + Routes.categories + "/\(categoryId)" + Routes.tours
        }
        
    }
    struct Colors {
        struct UI{
            static let background = UIColor(red:0.87, green:0.28, blue:0.32, alpha:1.0)
        }
        struct Mapbox{
            static let pathColor = UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1)
        }
        
    }
    struct CellHeights{
        struct InfoHeights{
            static let tall = 500
            static let short = 300
        }
    }
}
