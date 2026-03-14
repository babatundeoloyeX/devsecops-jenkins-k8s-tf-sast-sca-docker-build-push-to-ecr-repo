FROM maven:3.8-jdk-8 AS builder
WORKDIR /usr/src/easybuggy
COPY . .
RUN mvn -B package

FROM eclipse-temurin:8-jre
WORKDIR /app
COPY --from=builder /usr/src/easybuggy/target/ROOT.war easybuggy.jar

CMD ["java","-jar","easybuggy.jar"]
