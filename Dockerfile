FROM mcr.microsoft.com/dotnet/ccore/aspnet:3.1-buster-slim
LABEL maintainer="tanishakapoor"
COPY app/release ./
ENTRYPOINT ["dotnet","WebApplication4.dll"]
EXPOSE 80