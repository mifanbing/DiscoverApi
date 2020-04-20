extension Environment {
    static var local: Environment {
        .custom(name: "local")
    }
    
    static var test: Environment {
        .custom(name: "test")
    }
    
    static var prod: Environment {
        .custom(name: "prod")
    }
}
