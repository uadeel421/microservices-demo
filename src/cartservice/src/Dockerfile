# Stage 1: Build the application
# Use the .NET 8.0 SDK (LTS version) for better stability in multi-arch builds
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# Set the working directory to /app
WORKDIR /app

# The cartservice.csproj is in the 'src' subdirectory of the context.
# We copy it in first to leverage Docker's build cache.
COPY ["src/cartservice.csproj", "src/"]
# Restore dependencies for the cartservice project.
# This must happen before copying the rest of the source code.
RUN dotnet restore "src/cartservice.csproj"

# Copy the rest of the source code into the container.
COPY . .

# Publish the application for release.
# We specify the project file path relative to the WORKDIR.
# The --no-restore flag is correct here as we already restored.
RUN dotnet publish "src/cartservice.csproj" -c Release -o /app/publish --no-restore

# Stage 2: Create the final runtime image
# Use the .NET 8.0 ASP.NET runtime (LTS version)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final

# ==> THIS IS THE FIX <==
# Install the gRPC health probe to resolve the CrashLoopBackOff error
# This command is correct and doesn't need changes.
RUN apt-get update && apt-get install -y wget && \
    GRPC_HEALTH_PROBE_VERSION=v0.4.24 && \
    ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
      wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 ; \
    elif [ "$ARCH" = "aarch64" ]; then \
      wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-arm64 ; \
    else \
      echo "Unsupported architecture: $ARCH" && exit 1 ; \
    fi && \
    chmod +x /bin/grpc_health_probe

# Set the final working directory for the application
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build /app/publish .

# Copy the SSL certificate into the container
COPY ./ssl/DigiCertGlobalRootCA.crt.pem /ssl/DigiCertGlobalRootCA.crt.pem

# Set the entry point for the application
ENTRYPOINT ["dotnet", "cartservice.dll"]
