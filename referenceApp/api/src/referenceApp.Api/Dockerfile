FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["src/referenceApp.Api/referenceApp.Api.csproj", "src/referenceApp.Api/"]
RUN dotnet restore "src\referenceApp.Api\referenceApp.Api.csproj"
COPY . .
WORKDIR "/src/src/referenceApp.Api"
RUN dotnet build "referenceApp.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "referenceApp.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "referenceApp.Api.dll"]
