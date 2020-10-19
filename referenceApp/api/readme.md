

## Use Microsoft SQL Server on Linux for Docker Engine
1. install docker
2. install latest sql distro
```
docker pull mcr.microsoft.com/mssql/server:2019-latest
```
3. start sql server instance
```
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=yourStrong(!)Password' -p 1433:1433 -d mcr.microsoft.com/mssql/server:2019-latest
```
4. Update connection string in appsettings.Development.json