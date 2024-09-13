# Use Maven 3.9.9 and Java 19 base image
FROM maven:3.9.9-openjdk-19 AS build
# Output Maven and Java versions for tracking
RUN mvn -v && java -version
# Copy project files to the container
COPY . .
# Build the project and skip tests
RUN mvn clean package -DskipTests

# Use the OpenJDK 19 runtime image for the final stage
FROM openjdk:19-slim
# Output Java version for tracking
RUN java -version
# Copy the built JAR file from the build stage
COPY --from=build /target/demo-0.0.1-SNAPSHOT.jar demo.jar
# Expose port 8080 for the application
EXPOSE 8080
# Run the application
ENTRYPOINT ["java", "-jar", "demo.jar"]
