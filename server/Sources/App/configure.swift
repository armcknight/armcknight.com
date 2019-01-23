import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    try configureProviders(config: &config, services: &services)
    try configureRoutes(services: &services)
    configureDatabase(services: &services)
    configureMiddleware(services: &services)
}

func configureProviders(config: inout Config, services: inout Services) throws {
    try services.register(FluentPostgreSQLProvider())
}

func configureRoutes(services: inout Services) throws {
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
}

func configureDatabase(services: inout Services) {
    // Configure database service
    let pgConfig: PostgreSQLDatabaseConfig
    if let configuredDatabaseURL = ProcessInfo.processInfo.environment["DATABASE_URL"] {
        pgConfig = PostgreSQLDatabaseConfig(url: configuredDatabaseURL, transport: .cleartext)!
        print("configuring database for production")
    } else {
        pgConfig = PostgreSQLDatabaseConfig(hostname: "localhost", port: 5432, username: "andrew", database: "vapor_pg_test", password: nil, transport: .cleartext)
        print("configuring database for local development")
    }
    let postgres = PostgreSQLDatabase(config: pgConfig)
    var databases = DatabasesConfig()
    databases.add(database: postgres, as: .psql)
    services.register(databases)
    
    // Configure database migrations
    var migrations = MigrationConfig()
    migrations.add(model: Wit.self, database: .psql)
    services.register(migrations)
}

func configureMiddleware(services: inout Services) {
    var middlewares = MiddlewareConfig()
    
    let corsConfiguration: CORSMiddleware.Configuration
    if let debugging = ProcessInfo.processInfo.environment["DEBUG"]?.bool, debugging {
        print("configuring CORS for local debugging")
        corsConfiguration = CORSMiddleware.Configuration(
            allowedOrigin: .all,
            allowedMethods: [.GET],
            allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
        )
    } else {
        print("configuring CORS for production")
        corsConfiguration = .default()
    }
    
    let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
    middlewares.use(corsMiddleware)
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
}
