import Vapor
import S3

func routes(_ app: Application) throws {
    app.get { req -> String in
        switch app.environment {
            case .development: return "It works in local"
            case .testing: return "It works in test"
            case .production: return "It works in prod"
            default: return "It works!"
        }
    }

    app.get("hello") { req -> EventLoopFuture<String> in
        let response = req.client.get("https://dog.ceo/api/breeds/image/random").map { "\($0)" }
        return response
    }
    
    let bucket = "my-bucket"

    let s3 = S3(accessKeyId: "Your-Access-Key", secretAccessKey: "Your-Secret-Key", region: .uswest2)

    func createBucketPutGetObject() {
        // Create Bucket, Put an Object, Get the Object
        let createBucketRequest = S3.CreateBucketRequest(bucket: bucket)

        s3.createBucket(createBucketRequest)
            .flatMap { response -> EventLoopFuture<S3.PutObjectOutput> in
                // Upload text file to the s3
                let bodyData = "hello world".data(using: .utf8)!
                let putObjectRequest = S3.PutObjectRequest(acl: .publicRead, body: bodyData, bucket: bucket, contentLength: Int64(bodyData.count), key: "hello.txt")
                return s3.putObject(putObjectRequest)
            }
            .flatMap { response -> EventLoopFuture<S3.GetObjectOutput> in
                let getObjectRequest = S3.GetObjectRequest(bucket: bucket, key: "hello.txt")
                return s3.getObject(getObjectRequest)
            }
            .whenSuccess { response in
                if let body = response.body {
                    print(String(data: body, encoding: .utf8)!)
                }
        }
    }
}
