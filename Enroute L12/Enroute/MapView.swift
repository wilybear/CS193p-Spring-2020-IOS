//
//  MapView.swift
//  Enroute
//
//  Created by 김현식 on 2021/02/09.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit

struct MapView: UIViewRepresentable {
    let annotations: [MKAnnotation]
    @Binding var selection: MKAnnotation?
    
    func makeUIView(context: Context) -> MKMapView{
        let mkMapView = MKMapView()
        mkMapView.delegate =  context.coordinator
        mkMapView.addAnnotations(annotations)
        return mkMapView
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let annotation = selection{
            let town = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            uiView.setRegion(MKCoordinateRegion(center: annotation.coordinate,span: town), animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selection: $selection)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        @Binding var selection: MKAnnotation?
        
        init(selection: Binding<MKAnnotation?>) {
            _selection = selection
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "MapViewAnnotation") ??
            MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MapViewAnnotation")
            view.canShowCallout = true
            return view
        }
        // this method is called whenever one of these pin Views is touched on
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation {
                selection = annotation
            }
        }
    }
}
	
