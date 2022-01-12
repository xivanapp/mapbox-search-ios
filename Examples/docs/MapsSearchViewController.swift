import UIKit
import Mapbox
import MapboxSearch
import MapboxSearchUI

class MapsSearchViewController: UIViewController {
    var searchController = MapboxSearchController()
    var mapView: MapView?
    var annotationManager: PointAnnotationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search setup
        searchController.delegate = self
        let panelController = MapboxPanelController(rootViewController: searchController)
        addChild(panelController)
        
        // Map setup
        let mapView = MapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.mapView = mapView
        view.addSubview(mapView)
        
        annotationManager = mapView.annotations.makePointAnnotationManager()
    }
    
    func showResults(_ results: [SearchResult]) {
        let annotations = results.map { searchResult -> PointAnnotation in
            var annotation = PointAnnotation(coordinate: searchResult.coordinate)
            annotation.textField = searchResult.name
            annotation.textOffset = [0, -2]
            annotation.textColor = StyleColor(.red)
            annotation.image = .init(image: UIImage(named: "red_pin")!, name: "red_pin")
            return annotation
        }
        
        annotationManager?.annotations = annotations
        if let point = annotations.first?.point {
            let options = CameraOptions(center: point.coordinates)
            mapView?.mapboxMap.setCamera(to: options)
        }
    }
}

extension MapsSearchViewController: SearchControllerDelegate {
    func categorySearchResultsReceived(results: [SearchResult]) {
        showResults(results)
    }
    
    func searchResultSelected(_ searchResult: SearchResult) {
        showResults([searchResult])
    }
    
    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        showResults([userFavorite])
    }
}