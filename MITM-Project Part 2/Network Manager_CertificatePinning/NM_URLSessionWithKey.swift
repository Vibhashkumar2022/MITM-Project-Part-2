//
//  NM_URLSessionWithKey.swift
//  MITM-Alamofire
//
//  Created by Vibhash Kumar on 28/03/24.
//
import Foundation
import CommonCrypto

final class NetworkManagerWithPublicKeys : NSObject {
    static let shared = NetworkManagerWithPublicKeys()
    private var session : URLSession!
    
    static let localPublicKey = "u/joKCLcfT2khmv/jPpWcsbUx1mBQ1PY0QXYg5cHonE="

    private let rsa2048Asn1Header:[UInt8] = [
            0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
            0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
   
    private override init() {
        super.init()
        session = URLSession.init(configuration: .ephemeral,delegate: self, delegateQueue: nil)
    }
    
    // MARK: Certificate pinning by URL Session
    
    func request<T:Decodable>(url:URL?,expecting:T.Type, completion:@escaping(_ data:T?, _ error : Error?)->()){
        guard let url else {
            print("cannot form url")
            return
        }
        Task{
            self.session.dataTask(with: url) { data, response, error in
                if let error {
                    completion(nil,error)
                }
                guard let data else {
                    print("something went wrong")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(T.self, from: data)
                    completion(response,nil)
                }catch{
                    completion(nil,error)
                }
            }.resume()
        }
    }
    
    private func sha256(data : Data) -> String {
        var keyWithHeader = Data.init(rsa2048Asn1Header) //Data(bytes: rsa2048Asn1Header)
        keyWithHeader.append(data)
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        keyWithHeader.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(keyWithHeader.count), &hash)
        }
        return Data(hash).base64EncodedString()
    }
    
}
    
//MARK: URLSessionDelegate
extension NetworkManagerWithPublicKeys : URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        /// Create a server trust
        guard let serverTrust = challenge.protectionSpace.serverTrust , let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else  {
            return
        }
     
        // MARK:  Now Start Public key Pinning
        /// Server public key
        /// Server public key Data
        if let serverPublicKey = SecCertificateCopyKey(serverCertificate),
           let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey, nil) {
         
            let data : Data = serverPublicKeyData as Data
           
            /// Server Hash key
            let serverHashKey = sha256(data: data)
            
            /// Local Hash Key
            let publickKeyLocal = type(of: self).localPublicKey
           
            /// comparing server and local hash key
           
            if serverHashKey == publickKeyLocal {
                print("Public key pinning is successfull")
                completionHandler(.useCredential, nil)
            } else {
                print("Public key pinning is failed")
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }
    }
}
