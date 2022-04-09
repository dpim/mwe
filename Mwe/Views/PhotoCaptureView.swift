//
//  PhotoCaptureView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI

struct PhotoCaptureView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var photo: UIImage?
    @ObservedObject var events = UserEvents()
    @ObservedObject var output = CameraOutput()
    
    func photoHandler(_ photo: UIImage) {
        self.photo = photo
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        ZStack {
            ProgressView()
            CameraView(events: events, onPhoto: photoHandler, applicationName: "Mwe", preferredStartingCameraType: .builtInWideAngleCamera)
            CameraInterfaceView(events: events)
        }
    }
}

struct PhotoCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCaptureView(photo: .constant(UIImage()))
    }
}
