//
//  PhotoCaptureView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI

struct PhotoCaptureView: View {
    @ObservedObject var events = UserEvents()
    @ObservedObject var output = CameraOutput()

    var body: some View {
        ZStack {
            CameraView(events: events, output: output, applicationName: "Mwe", preferredStartingCameraType: .builtInWideAngleCamera)
            CameraInterfaceView(events: events)
            Text("\(output.image ?? UIImage())")

        }
    }
}

struct PhotoCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCaptureView()
    }
}
