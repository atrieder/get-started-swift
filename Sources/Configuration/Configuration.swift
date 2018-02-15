//
//  Configuration.swift
//  get-started-swiftPackageDescription
//
//  Created by Aaron Liberatore on 2/13/18.
//

import Foundation

public class ConfigManager {

    public var services: [String: Any] = [:]

    public init() {
        load()
    }

    public func getCloudantCredentials() -> CloudantCredentials? {
        if let service = services["cloudantNoSQLDB"] as? [Any] {
           if let d = service[0] as? [String: Any], let credentials = d["credentials"] as? [String: Any] {
               guard let url = credentials["url"] as? String, let username = credentials["username"] as? String, let password = credentials["password"] as? String else {
                   print("Invalid Credentials", credentials)
                   return nil
               }
               print("Rretrieved Credentials")
               print(url)
               print(username)
               print(password)
               return CloudantCredentials(url: url, username: username, password: password)
           }
       }
        return nil
    }

    private func load() {
        for (path, value) in ProcessInfo.processInfo.environment {
            if path == "VCAP_SERVICES", let services = convertToDictionary(value) {
                self.services = services
                break
            }
        }
    }

    private func convertToDictionary(_ text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

public struct CloudantCredentials {
    public let url: String
    public let username: String
    public let password: String

    public init(url: String, username: String, password: String) {
        self.url = url
        self.password = password
        self.username = username
    }
}
