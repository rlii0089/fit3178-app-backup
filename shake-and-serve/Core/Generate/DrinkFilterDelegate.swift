//
//  DrinkFilterDelegate.swift
//  shake-and-serve
//
//  Created by Raymond Ruimin Li on 9/5/2024.
//

import Foundation
import UIKit

protocol DrinkFilterDelegate: AnyObject {
    func didSelectFilters(filters: [String], filterType: String)
}
