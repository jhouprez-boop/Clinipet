# --- Etapa 1: compilar el WAR con Maven ---
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests clean package

# --- Etapa 2: correr el WAR en Tomcat 10 (requerido por jakarta.servlet 6.0) ---
FROM tomcat:10.1-jdk17-temurin
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY --from=build /app/target/clinipet.war /usr/local/tomcat/webapps/ROOT.war

# Render/hosts gratuitos exponen el puerto vía variable de entorno PORT;
# Tomcat usa 8080 por defecto, así que lo dejamos fijo y el host lo mapea.
EXPOSE 8080

CMD ["catalina.sh", "run"]
