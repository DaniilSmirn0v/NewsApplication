//
//  ImageLoaderService.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 27.01.2023.
//

import UIKit

final class ImageLoaderService: ImageLoaderServiceProtocol {
    
    //MARK: - Private Properties
    static let shared = ImageLoaderService()
    private var images: [String: UIImage] = [:]
    private lazy var fileManager = FileManager.default
    private let placeholderImage = UIImage(named: "notFoundBlack")
    
    //MARK: - Initialize
    private init() {}
    
    //MARK: - ImageLoaderServiceProtocol methods
    func image(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let image = images[urlString] {
            completion(image)
        } else if let image = getImageFromDisk(url: urlString) {
            completion(image)
        } else {
            loadImageFromNet(urlString: urlString) { image in
                completion(image)
            }
        }
    }
}

// MARK: - Private Methods
extension ImageLoaderService {
    private func getCachFolderPath() -> URL? {
        guard let docsDirectory = fileManager.urls(for: .documentDirectory,
                                                   in: .userDomainMask).first else {
            return nil
        }
        
        let url = docsDirectory.appendingPathComponent("Images", isDirectory: true)
        
        if !fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.createDirectory(at: url,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                print(error)
            }
        }
        return url
    }
    
    private func getImagePath(url: String) -> String? {
        guard let folderurl = getCachFolderPath() else { return nil }
        let fileName = url.split(separator: "/").last ?? ""
        
        return folderurl.appendingPathComponent(String(fileName)).path
    }
    
    private func saveImageToDisk(url: String, image: UIImage) {
        guard let filePath = getImagePath(url: url),
              let data = image.pngData()
        else { return }
        
        fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
    }
    
    private func getImageFromDisk(url: String) -> UIImage? {
        guard let filePath = getImagePath(url: url),
              let image = UIImage(contentsOfFile: filePath) else {
            return nil
        }
        
        images[url] = image
        return image
    }
    
    private func loadImageFromNet(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: urlString)
        var urlRequest = URLRequest(url: url ?? URL(fileURLWithPath: ""))
        urlRequest.timeoutInterval = 10
        URLSession.shared.dataTask(with: urlRequest) {[weak self] data, response, error in
            guard error == nil,
                  let data = data,
                  let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  let imageData = UIImage(data: data)?.compress(to: 100),
                  let image = UIImage(data: imageData),
                  let self = self else {
                completion(self?.placeholderImage)
                return
            }
            self.saveImageToDisk(url: urlString, image: image)
            completion(image)
            self.images[urlString] = image
        }.resume()
    }
}
