import Moya

class SkyengAPIProvider: MoyaProvider<SkyengAPI> {
    
    static let shared: SkyengAPIProvider = {
        var plugins: [PluginType] = []
        
        #if DEBUG
        let networkLogger = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))
        plugins.append(networkLogger)
        #endif
        
        return SkyengAPIProvider(plugins: plugins)
    }()
    
}
