FROM ubuntu:18.04
LABEL Maintainer="Wilder Lopes <wilderlopes83@gmail.com>"
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && \
    #apt-get -qq -y install libxext-dev && \
    apt-get install -y libxext-dev && \
    apt-get -qq -y install libvlc-dev && \
    apt-get -qq -y install vlc


FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /    #apt-get -qq -y install libxext-dev && \
# Copy csproj and restore as distinct layers
COPY *.csproj ./
#RUN dotnet restore RadioRecorderLibVlcSharp.csproj
RUN dotnet restore
COPY . ./out
WORKDIR /out
#RUN dotnet build -c Release -o out
RUN dotnet publish -c Release -o out

ENTRYPOINT ["dotnet", "out/RadioRecorderLibVlcSharp.dll"]
