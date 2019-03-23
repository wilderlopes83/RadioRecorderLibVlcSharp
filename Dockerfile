FROM ubuntu:18.04
LABEL Maintainer="Wilder Lopes <wilderlopes83@gmail.com>"
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && \
    apt-get -qq -y install software-properties-common && \
    apt-get -qq -y install libxext-dev && \
    apt-get -qq -y install libvlc-dev && \
    apt-get -qq -y install vlc && \
    apt-get -qq -y install wget && \
    wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    add-apt-repository universe && \
    apt-get -qq -y install apt-transport-https && \
    apt-get update && \
    apt-get -qq -y install dotnet-sdk-2.2

WORKDIR /
COPY *.csproj ./
#RUN dotnet restore RadioRecorderLibVlcSharp.csproj
RUN dotnet restore
COPY . ./out
WORKDIR /out
#RUN dotnet build -c Release -o out
RUN dotnet publish -c Release -o out

ENTRYPOINT ["dotnet", "out/RadioRecorderLibVlcSharp.dll"]

