//
//  CameraInterfaceView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI

struct CameraInterfaceView: View, CameraActions {
    @ObservedObject var events: UserEvents
    
    var body: some View {
        VStack {
            HStack {
                Button("Rotate") {
                    self.rotateCamera(events: events)
                }
                Spacer()
                Button("Flash") {
                    self.changeFlashMode(events: events)
                }
            }
            Spacer()
            Button("Photo") {
                self.takePhoto(events: events)
            }
        }
    }
}
