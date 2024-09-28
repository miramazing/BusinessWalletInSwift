//
//  NameCardView.swift
//  BusinessWallet
//
//  Created by elice75 on 9/28/24.
//

import SwiftUI

struct NameCardView: View {
    @State var user : GitHubUser?
    let name: String
    
    var body: some View {
        VStack{
            //프로필 이미지
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) {
                image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                
            } placeholder: {
                Circle()
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 30)
            }
            .frame(width:150)

            
            //이름
            Text(user?.name ?? "이름 없음")
                .font(.title)
                .bold()
            
            //회사
            Text(user?.company ?? "회사 없음")
            
            NavigationLink {
                MoreInfo(owner: user?.name ?? "", repo: "BusinessWalletInSwift")
                
            } label: {
                Text("View more")
                    .padding(.horizontal, 70)
                    .padding(.vertical, 10)
                    .background {
                        Capsule()
                            .foregroundStyle(.cyan)
                    }
                    .foregroundStyle(.white)
            }
            
            .padding(.bottom, 50)
            
            HStack {
                Text(user?.htmlUrl ?? "github 없음")
                Spacer()
            }
            
            Divider()
            
            HStack{
                Text(user?.email ?? "이메일 없음")
                Spacer()
            }
        }
        .padding(.horizontal, 30)
        .task {
            self.user = try? await getUserData(name: name)
        }
    }
    
    
    func getUserData(name: String) async throws -> GitHubUser {
        guard let url = URL(string: "https://api.github.com/users/\(name)") else {
            throw URLError(.badURL)}
        
        let (data, response) = try await URLSession.shared.data(from:url)
        
        guard
            let response = response as? HTTPURLResponse,
            response.statusCode == 200
        else { throw URLError(.badServerResponse)}
    
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(GitHubUser.self, from:data)
    
    }
}

#Preview {
    NavigationStack{
        NavigationLink("미라"){
            NameCardView(name: "miramazing")
        }
        NavigationLink("미숫가루"){
            NameCardView(name: "misutgaru")
        }
        NavigationLink("규니"){
            NameCardView(name: "seunggyun-jeong")
        }
        NavigationLink("Sally"){
            NameCardView(name: "SallyPark9303")
        }
    }
}

struct GitHubUser : Codable {
    let avatarUrl: String?
    let name : String?
    let company : String?
    let email : String?
    let htmlUrl : String
    
}
