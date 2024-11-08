//
//  ContentView.swift
//  BinBot
//
//  Created by Himani Jha on 11/4/24.
//

import SwiftUI

struct ContentView: View {
    //Load Sample Image that I added from Assets (this is where we would display the picture, the camera just saved)
    let image = "paper1"
    
    //Call the predict function to classify the image
    // var classificationLabel = predict(photo: image)
    // print(self.classificationLabel)

    var body: some View {
        CameraView()
        
        /*
         // Would need to be in a different screen
         VStack{
            //Image(photo).resizable().frame(width: 224, height: 224) //set this to default size of picture taken from camera
            Button (action: {
                self.classificationLabel = predict(photo: photo)
            }) {
                //Classify Image Button - Can be connection to action function of the camera. When the "take picture" button is clicked, the predic
                Text("Classify Image")
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .frame(width: 300, height: 50)
            }
            //Displays the classification result - needs to be in a different screen
            Text(classificationLabel)
                .font(.largeTitle)
                .padding()
        }
        .padding()*/
    }
}

#Preview {
    ContentView()
}

//Takes name of photo as input
func predict(photo: String) -> String{
    let model = MobileNetV2()
    var classificationLabel = ""
    //Image Preprocessing: Reizes the image and converts it to a CVPixelBuffer through helper functions
    guard let img = UIImage(named: photo), let resizedImage = img.resizeTo(size: CGSize(width: 224, height: 224)), let buffer = resizedImage.toBuffer() else { return ""}
    //Uses the model to classify the image
    //Output has two parts: classLabelProbs (dictionary of probabilities of categories), classLabel (String containing most likely category)
    //Replace with the model we create + Need to figure out formatting + output restrictions
    let output = try? model.prediction(image: buffer)
    if let output = output {
        classificationLabel = output.classLabel
    }
    return classificationLabel
}
