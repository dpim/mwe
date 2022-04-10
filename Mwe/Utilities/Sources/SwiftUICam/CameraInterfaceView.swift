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
    let minorMenuItemSize: CGFloat = 25
    let majorMenuItemSize: CGFloat = 50
    let backgroundPadding: CGFloat = 10
    
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
                            .frame(width: minorMenuItemSize, height: minorMenuItemSize)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: minorMenuItemSize+backgroundPadding, height: minorMenuItemSize+backgroundPadding)
                    }
                }.padding()
            }
            Spacer()
            VStack {
                Button {
                    self.takePhoto(events: events)
                } label: {
                    Image(systemName: "camera.circle")
                        .resizable()
                        .scaledToFill()
                        .frame(width: majorMenuItemSize, height: majorMenuItemSize, alignment: .center)
                }.background {
                    Circle()
                        .fill(Color.white)
                        .frame(width: majorMenuItemSize+backgroundPadding, height: majorMenuItemSize+backgroundPadding)
                }
            }
        }
    }
}
