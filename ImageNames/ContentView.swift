//
//  ContentView.swift
//  ImageNames
//
//  Created by Kristoffer Eriksson on 2021-04-23.
//

import SwiftUI

struct ContentView: View {
    
    enum screens {
        case addView, listView, detailView
    }
    
    @State private var viewLook = screens.addView
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Picture.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var Pictures : FetchedResults<Picture>
    
    @State private var showingAddPicture = false
    
    var body: some View {
        
        NavigationView{
            List{
                ForEach(Pictures, id: \.self){ picture in
                    //Load list of pictures
                    NavigationLink(destination: PictureDetailView(picture: picture)){
                        HStack {
                            Spacer()
                            self.loadUserImage(uuid: picture.pictureId!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            
                            Spacer()
                            
                            Text(picture.name!)
                                .font(.headline)
                                
                            Spacer()
                        }
                    }
                }
                .onDelete(perform: deleteImage)
            }
            .navigationBarTitle(Text("Image names"))
            .navigationBarItems(trailing: Button(action: {
                self.showingAddPicture.toggle()
            }) {
                Image(systemName: "plus")
                    .foregroundColor(Color.black)
            })
            .sheet(isPresented: $showingAddPicture){
                PictureView()
            }
        }
    }
    
    func deleteImage(at offsets: IndexSet){
        for offset in offsets{
            let image = Pictures[offset]
            moc.delete(image)
            self.deleteFromDirectory(name: Pictures[offset].pictureId?.uuidString ?? "")
        }
        
        try? moc.save()
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
    
    func deleteFromDirectory(name: String){
        
        let url = getDocumentsDirectory().appendingPathComponent(name)
        try? FileManager.default.removeItem(atPath: String(contentsOf: url))
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
