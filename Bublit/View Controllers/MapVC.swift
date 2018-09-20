//
//  MainVC.swift
//  Bublit
//
//  Created by Jake Smith on 28/12/2017.
//  Copyright © 2017 Nebultek. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import Firebase

class MapVC: UIViewController,GMSMapViewDelegate,UserMapDelegate {
    
    let marker = GMSMarker()
    var mapView = GMSMapView()
    var messagebox = UIView()
    weak var delegate: MapVCDelegate?
    var userMap = UserMap()
    
    override func viewDidLoad() {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        delegate?.userTapped()
    }
    
   /* func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoView = UINib(nibName: "messageView", bundle: Bundle.main)
            let view = infoView.instantiate(withOwner: self, options: nil).first as! UIView
            view.frame.size.width = self.view.frame.width*0.60
            view.frame.size.height = self.view.frame.height*0.18
        return view
    }*/
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        userMap.scaleUserIcons()
    }
    
    
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        view = mapView
        do {
            mapView.mapStyle = try GMSMapStyle(jsonString: MapData.mapStyle)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        userMap = UserMap(map: mapView)
        userMap.delegate = self
        userMap.startTracking()
        userMap.fetchNearby()
        userMap.addDeviceMarker()
    }
    
    
}

protocol MapVCDelegate: class {
    func userTapped()
}

extension UIImage {
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    var breadth:     CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


