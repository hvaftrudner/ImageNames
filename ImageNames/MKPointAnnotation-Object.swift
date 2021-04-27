//
//  MKPointAnnotation-Object.swift
//  ImageNames
//
//  Created by Kristoffer Eriksson on 2021-04-27.
//

import Foundation
import MapKit

extension MKPointAnnotation: ObservableObject{
    public var wrappedTitle: String {
        get {
            self.title ?? "unknown value"
        }
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "unknown value"
        }
        set {
            subtitle = newValue
        }
    }
    
}
