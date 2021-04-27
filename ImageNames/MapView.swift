//
//  MapView.swift
//  ImageNames
//
//  Created by Kristoffer Eriksson on 2021-04-27.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    var annotations: [MKPointAnnotation]
    
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool
    
    class Coordinator: NSObject, MKMapViewDelegate{
        var parent: MapView
        
        init(_ parent: MapView){
            self.parent = parent
        }
        
        func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
            mapView.setCenter(mapView.annotations[0].coordinate, animated: true)
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            
            //parent.centerCoordinate = mapView.centerCoordinate
            //print(parent.centerCoordinate)
        
        }
        
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Placemark"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            
            guard let placemark = view.annotation as? MKPointAnnotation else {return}
            parent.selectedPlace = placemark
            parent.showingPlaceDetails = true
            parent.centerCoordinate = placemark.coordinate
        }
    }
    
   
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        print("updating")
        if annotations.count != view.annotations.count {
            view.removeAnnotations(annotations)
            view.addAnnotations(annotations)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to 2012 summer olympics"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(centerCoordinate: .constant(MKPointAnnotation.example.coordinate), annotations: [MKPointAnnotation.example], selectedPlace: .constant(MKPointAnnotation.example), showingPlaceDetails: .constant(false))
    }
}
