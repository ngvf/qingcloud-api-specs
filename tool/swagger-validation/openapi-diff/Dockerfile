FROM openjdk:8-jre-slim
WORKDIR /app
COPY ./swagger-diff.jar /app/swagger-diff.jar
ENTRYPOINT ["java", "-jar", "/app/swagger-diff.jar"]
CMD ["--help"]