# Java Web Application Jenkins Docker CI/CD

A Java web application built with Maven and deployed using Jenkins, Docker, Docker Hub and AWS EC2.

## Architecture

Developer pushes code to GitHub, which triggers Jenkins through a webhook.

 GitHub
   |
   | Webhook
   v
Jenkins Server
   |
   | Maven Build
   | Docker Build
   | Push Image
   v
Docker Hub
   |
   | Pull Image through Jenkins SSH deployment
   v
Application Server
   |
   v
Docker Container running Apache Tomcat

## Technologies

- Java 21
- Maven
- Jenkins
- Docker
- GitHub
- AWS EC2
- Apache Tomcat
- Webhook automatic build test

## CI/CD Pipeline Stages
- Checkout source code from GitHub
- Build the Java WAR file using Maven
- Build the Docker image
- Push versioned and latest images to Docker Hub
- Connect to the application server using SSH
- Replace the old container with the new version
- Verify the deployed applicatio

CI/CD webhook test completed.
