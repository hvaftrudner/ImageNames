//
//  PictureDetailView.swift
//  ImageNames
//
//  Created by Kristoffer Eriksson on 2021-04-24.
//

import SwiftUI

struct PictureDetailView: View {
    
    @State var picture: Picture
    
    var body: some View {
        ZStack{
            VStack{
                
                self.loadUserImage(uuid: picture.pictureId!)
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                Spacer()
                
                Text(picture.name ?? "")
                    .padding()
                    .font(.largeTitle)
                
                Spacer()
            }
        }
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
