//
//  NetworkManager.swift
//  MITM-Alamofire
//
//  Created by Vibhash Kumar on 27/03/24.
//

import Foundation
import CommonCrypto

final class NetworkManager : NSObject {
    static let shared = NetworkManager()
    private var session : URLSession!
    private override init() {
        super.init()
        session = URLSession.init(configuration: .ephemeral,delegate: self, delegateQueue: nil)
    }
    
    // MARK: Certificate pinning by URL Session
    func request<T:Decodable>(url:URL?) async throws -> T {
        guard let url else {
            throw DataError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw DataError.invalidResponse
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
    
//MARK: URLSessionDelegate
extension NetworkManager : URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // Create a server trust
        guard let serverTrust = challenge.protectionSpace.serverTrust , let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else  {
            return
        }
        //MARK: Now Start Certificate Pinning
        // SSL policy for domain check
        let policy = NSMutableArray()
        policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
        //Evaluating the certificate
        let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
        // Local and Remote certificate data
        let remoteCertificateData : NSData = SecCertificateCopyData(serverCertificate)
        guard let pathToCertifcate = Bundle.main.path(forResource: "certificate", ofType: "cer") else { return }
        guard let localCertificateData = NSData.init(contentsOfFile: pathToCertifcate) else { return }
        // compare data of both the certificate
        if isServerTrusted && remoteCertificateData.isEqual(to: localCertificateData as Data){
            let credential : URLCredential = URLCredential(trust: serverTrust)
            print("Certificate pinning is Successful")
            completionHandler(.useCredential, credential)
        }else {
            print("Certificate pinning is failed")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
