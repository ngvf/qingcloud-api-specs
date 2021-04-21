FROM openjdk:8-jre-slim
WORKDIR /app
COPY ./openapi-diff-cli-*-all.jar /app/openapi-diff.jar
ENTRYPOINT ["java", "-jar", "/app/openapi-diff.jar"]
CMD ["--help"]