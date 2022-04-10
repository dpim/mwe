//
//  CameraInterfaceView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI

struct CameraInterfaceView: View, CameraActions {
    
    @ObservedObject var events: UserEvents
    var onCancel: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Button {
                        onCancel()
                    } label: {
                        Image(systemName: "x.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }.padding()
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
