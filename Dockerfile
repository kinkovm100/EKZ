# Базовый образ для .NET 9.0
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 5032/tcp

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["ImageGallery.csproj", "./"] 
RUN dotnet restore "ImageGallery.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "ImageGallery.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ImageGallery.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ImageGallery.dll"]