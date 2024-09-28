//
//  MoreInfo.swift
//  BusinessWallet
//
//  Created by elice75 on 9/28/24.
//

import SwiftUI

struct MoreInfo: View {
    
    @State var repoDetail: GitRepo?
    let owner: String
    let repo: String

    
    var body: some View {
        VStack{
            Text(repoDetail?.name ?? "")
                .font(.title)
            Text("\(repoDetail?.stargazers_count ?? 99)")
        }.task{
            self.repoDetail = try? await getRepositoryData(owner: owner, repo: repo)
        }
    }
    
    
    func getRepositoryData(owner: String, repo: String) async throws -> GitRepo {
        guard let url = URL(string: "https://api.github.com/repos/\(owner)/\(repo)") else {
            throw URLError(.badURL)}
        
        let (data, response) = try await URLSession.shared.data(from:url)
        
        guard
            let response = response as? HTTPURLResponse,
            response.statusCode == 200
        else { throw URLError(.badServerResponse)}
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(GitRepo.self, from:data)
    }
}

#Preview {
    MoreInfo(owner: "seunggyun-jeong", repo: "Dittle")
}

struct GitRepo: Codable {
    let name: String
    let stargazers_count: Int
}
