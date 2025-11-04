
#Contruimos el proyecto con maven
FROM maven:3.9.1-eclipse-temurin-17 AS build

#Establecemos el directorio de trabajo del contenedor
WORKDIR /app

#Copiamos el archivo pom.xml
COPY pom.xml .

#Descargamos las dependencias
RUN mvn dependency:go-offline -B 

#Copiamos el codigo fuente
COPY src ./src

#Compilamos y empacamos omitiendo los tests para acelerar
RUN mvn clean package -DskipTests

#Ejecutamos la aplicacion
FROM eclipse-temurin:17-jre-alpine

#Creamos el directorio de trabajo
WORKDIR /app

#Copiamos el archivo jar que se genero
COPY --from=build /app/target/*.jar app.jar

#Exponemos el puerto de la aplicacion
EXPOSE 8080

#Declaramos el comando de inicio de la aplicacion
ENTRYPOINT ["java", "-jar", "app.jar"]