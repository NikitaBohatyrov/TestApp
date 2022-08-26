//
//  Parser.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 23.08.2022.
//

import Foundation

protocol ParsingProtocol {
    static func parse(completion: @escaping (([Device]) -> ()))
}

final class Parser:ParsingProtocol{
   static func parse(completion:@escaping ([Device])->()) {
        let url = URL(string: "http://storage42.com/modulotest/data.json")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error != nil {
                print(error?.localizedDescription  ?? "error in parsing results")
                return
            }
            do{
                let result = try JSONDecoder().decode(Root.self, from: data!)
                completion(result.devices)
            }catch {
                print("error")
            }
        }.resume()
    }
}
