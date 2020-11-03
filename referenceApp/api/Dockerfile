FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app

COPY . ./

RUN dotnet restore

WORKDIR /app/src/referenceApp.Api
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
USER ContainerAdministrator
WORKDIR /app
COPY --from=build /app/src/referenceApp.Api/out ./

# Make the filesystem read-only to the application.
# Directories that the app needs read-write rights should be added explicitly
# Rationale: (1) It discourages people from storing data in ephemeral containers and
# (2) Limits the damage a compromise to the application can precipitate
RUN icacls \ /grant:r "NT AUTHORITY\Authenticated Users":(RX) \
	&& icacls \ /grant:r "NT AUTHORITY\Authenticated Users":(OI)(CI)(IO)(GR,GE)

USER ContainerUser
ENTRYPOINT ["dotnet", "referenceApp.Api.dll"]
EXPOSE 5000/tcp
EXPOSE 5001/tcp
