# Use Maven 3.9.9 and Java 19 base image for the build phase
FROM maven:3.8.5-openjdk-17 AS build
# Output Maven and Java versions for tracking
RUN mvn -v && java -version
# Copy project files to the container
COPY . .
# Build the project and skip tests
RUN mvn clean package -DskipTests
# List contents of the target directory for verification
RUN ls /target

# Use OpenJDK 17 for the runtime environment
FROM openjdk:17-slim
# Output Java version for tracking
RUN java -version
# Copy the JAR file from the build stage to the runtime stage
COPY --from=build /target/ecommerce-0.0.1-SNAPSHOT.jar ecommerce.jar
# Expose port 8080 for the application
EXPOSE 8080
# Run the application
ENTRYPOINT ["java", "-jar", "ecommerce.jar"]
