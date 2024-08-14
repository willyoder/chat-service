# Use the official .NET 7.0 SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Set a custom working directory in the container
WORKDIR /BlazorServerCorr

# Copy the .csproj file and restore any dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application code
COPY . ./

# Build the application
RUN dotnet publish -c Release -o out

# Use the official .NET 7.0 runtime image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:7.0

# Set the custom working directory in the final container
WORKDIR /BlazorServerCorr

# Copy the built application from the build stage
COPY --from=build /BlazorServerCorr .

# Expose ports (HTTP and/or HTTPS)
EXPOSE 80
EXPOSE 443  # Uncomment if using HTTPS

# Set environment variables (if needed)
ENV ASPNETCORE_ENVIRONMENT=Production

# Define the entry point for the container
ENTRYPOINT ["dotnet", "BlazorServerCorr.dll"]
