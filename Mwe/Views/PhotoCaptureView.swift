//
//  PhotoCaptureView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI

struct PhotoCaptureView: View {
    @ObservedObject var events = UserEvents()
    
    var body: some View {
        CameraView(events: events, applicationName: "Mwe", preferredStartingCameraType: .builtInWideAngleCamera)

    }
}

struct PhotoCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCaptureView()
    }
}
