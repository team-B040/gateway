# Etapa 1: Compilación (Build)
FROM maven:3.9.6-eclipse-temurin-21-alpine AS build
WORKDIR /app

# Copiamos solo el pom y descargamos dependencias (optimiza caché)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiamos el código fuente y compilamos
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Ejecución (Runtime)
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copiamos solo el JAR resultante de la etapa anterior
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8762

ENTRYPOINT ["java", "-jar", "app.jar"]