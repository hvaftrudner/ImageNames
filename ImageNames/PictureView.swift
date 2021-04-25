//
//  PictureView.swift
//  ImageNames
//
//  Created by Kristoffer Eriksson on 2021-04-23.
//

import SwiftUI
import CoreImage

struct PictureView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @State var picture: Picture?
    
    @State private var isShowingImagePicker = false
    
    @State private var newImage: UIImage?
    @State private var image: Image?
    
    let context = CIContext()
    
    @State private var pictureName = ""
    
    @State private var isShowingFailAlert = false
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 300, height: 300, alignment: .center)
                        .padding()
                    
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300, alignment: .center)
                    } else {
                        Text("tap to import picture")
                    }
                }
                .onTapGesture {
                    self.isShowingImagePicker = true
                }
                
                VStack(alignment: .center){
                    TextField( "Input name for picture: ", text: $pictureName)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.black)
                        .padding()
                    
                    Button("Save"){
                        if self.newImage != nil && self.pictureName != ""{
                            //save image + name combo
                            let newPicture = Picture(context: self.moc)
                            newPicture.pictureId = UUID()
                            let pictureID = newPicture.pictureId
                            newPicture.name = self.pictureName
                            
                            //saving photo to disk here
                            try? self.moc.save()
                            self.saveImageToDisk(image: newImage!, name: pictureID?.uuidString ?? "")
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            self.isShowingFailAlert = true
                        }
                    }
                    .foregroundColor(Color.red)
                    .padding()
                }
            }
        }
        .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage){
            ImagePicker(image: self.$newImage)
        }
        .alert(isPresented: $isShowingFailAlert){
            Alert(title: Text("Image Error"), message: Text("No imported image or image name chosen"), dismissButton: .default(Text("ok"))
            )
        }
    }
    
    func loadImage(){
        guard let newImage = newImage else {return}
        image = Image(uiImage: newImage)
    }
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveImageToDisk(image: UIImage, name: String){
        guard let data = image.jpegData(compressionQuality: 0.8) else {return}
        let url = getDocumentsDirectory().appendingPathComponent(name)
        do {
            try data.write(to: url, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct PictureView_Previews: PreviewProvider {
    static var previews: some View {
        PictureView()
    }
}
