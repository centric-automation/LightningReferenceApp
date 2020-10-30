
## Ensure dotnet format is installed
```
dotnet tool install -g dotnet-format
```

Before you commit, execute ```dotnet format``` to ensure your code meets all standards and formatting conventions. This same command is executed as part of the build process.

## Use Microsoft SQL Server on Linux for Docker Engine
1. install docker
2. install latest sql distro
```
docker pull mcr.microsoft.com/mssql/server:2019-latest
```
3. start sql server instance
```
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=yourStrong(!)Password' -p 1433:1433 --name mssql -d mcr.microsoft.com/mssql/server:2019-latest
```
4. Update connection string in your favorite way to store development secrets:
   * appsettings.Development.json
   * UserSecrets
   * Environment Variables