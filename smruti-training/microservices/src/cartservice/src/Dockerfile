# Use the .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:6.0.412 AS builder

WORKDIR /usr/src/app/

# Copy the service and protobuf definitions
COPY ./microservices/src/cartservice/ ./
COPY ./microservices/pb/ ./src/protos/

# Restore dependencies
RUN \
  RUNTIME_IDENTIFIER=linux-musl-x64; \
  if [ "$(uname -m)" = "aarch64" ]; then RUNTIME_IDENTIFIER=linux-musl-arm64; fi; \
  dotnet restore ./src/cartservice.csproj -v d -r $RUNTIME_IDENTIFIER

# Build and publish the service
RUN \
  RUNTIME_IDENTIFIER=linux-musl-x64; \
  if [ "$(uname -m)" = "aarch64" ]; then RUNTIME_IDENTIFIER=linux-musl-arm64; fi; \
  dotnet publish ./src/cartservice.csproj -v d -p:PublishSingleFile=true -r $RUNTIME_IDENTIFIER \
    --self-contained true -p:PublishTrimmed=False -p:TrimMode=Link -c Release -o /cartservice --no-restore

# Runtime image
FROM mcr.microsoft.com/dotnet/runtime-deps:6.0.15-alpine3.16

WORKDIR /usr/src/app/

# Copy the published application
COPY --from=builder /cartservice/ ./

# Expose the application port
EXPOSE 50051

# Set the entrypoint
ENTRYPOINT ["./cartservice"]
