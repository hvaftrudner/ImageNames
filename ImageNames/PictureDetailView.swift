//
//  PictureDetailView.swift
//  ImageNames
//
//  Created by Kristoffer Eriksson on 2021-04-24.
//

import SwiftUI
import MapKit

struct PictureDetailView: View {
    
    @State var picture: Picture
    
    //mapview And Location
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    

    var body: some View {
        ZStack{
            //add geo for better window solution/ fit all screens
            VStack{
                Text(picture.name ?? "")
                    .padding()
                    .font(.largeTitle)
                    .frame(width: 280, height: 40, alignment: .center)
                    .border(Color.black, width: 2)
                
                Spacer()
                
                self.loadUserImage(uuid: picture.pictureId!)
                    .resizable()
                    .scaledToFit()
                    .border(Color.black, width: 2)
                
                Spacer()
                
                ZStack{
                    
                    MapView(centerCoordinate: $centerCoordinate, annotations: locations, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails)
                    Circle()
                        .fill(Color.red)
                        .opacity(0.2)
                        .frame(width: 10, height: 10)
                }
                .border(Color.black, width: 2)
                
                
            }
        }
        .onAppear(perform: {
            self.populateMapView()
        })
    }
    
    func populateMapView(){
        
        guard picture == picture else { return }
        
        self.centerCoordinate = CLLocationCoordinate2D(latitude: picture.latitude, longitude: picture.longitude)
        print(centerCoordinate)
        
        let newLocation = CodableMKPointAnnotation()
        newLocation.title = "New location"
        newLocation.coordinate = self.centerCoordinate
        self.locations.append(newLocation)
                    
        self.selectedPlace = newLocation

        //self.showingEditScreen = true
        
    }
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadPhoto(withName name: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(name)
        if let loadedImageData = try? Data(contentsOf: url) {
            return UIImage(data: loadedImageData)
        }
        return nil
    }
    func loadUserImage(uuid: UUID) -> Image {
        if let uiImage = loadPhoto(withName: uuid.uuidString){
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "person.crop.circle.fill")
        }
    }
}
//
//struct PictureDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PictureDetailView()
//    }
//}
