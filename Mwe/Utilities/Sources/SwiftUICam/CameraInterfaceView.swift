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
                Spacer()
            }
            Spacer()
            Button {
                self.takePhoto(events: events)
            } label: {
                Image(systemName: "camera.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50, alignment: .center)
            }
        }
    }
}
