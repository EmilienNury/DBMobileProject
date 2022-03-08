//
//  MapAnnotation.swift
//  BDMobileProject
//
//  Created by lpiem on 08/03/2022.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
  let landmark: Landmark
  let title: String?
  let desc: String?
  let coordinate: CLLocationCoordinate2D

  init(
    landmark: Landmark,
    title: String?,
    desc: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.landmark = landmark
    self.title = title
    self.desc = desc
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? {
    return desc
  }
}
