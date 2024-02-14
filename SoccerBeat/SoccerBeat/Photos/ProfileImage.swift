//
//  ProfileImage.swift
//  SoccerBeat
//
//  Created by jose Yun on 11/9/23.
//

import SwiftUI
import PhotosUI

// Render Image
struct ProfileImage: View {
    let imageState: ProfileModel.ImageState
    
    var body: some View {
        switch imageState {
        case .success(let image):
            image.resizable()
        case .loading:
            ProgressView()
        case .empty:
            Image(systemName: "person.fill")
                .font(.system(size: 40)) // Image에 폰트 적용되나요? 전 resizable + frame으로 했던 것 같아서.
                .foregroundColor(.white)
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

// Transmit Profile ViewModel
struct EditableCircularProfileImage: View {
    @ObservedObject var viewModel: ProfileModel
    let width : CGFloat
    let height : CGFloat
    var body: some View {
        ProfileImage(imageState: viewModel.imageState)
            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
            .frame(width: width, height: height)
    }
}
