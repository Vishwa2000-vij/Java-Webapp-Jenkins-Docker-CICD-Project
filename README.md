## Featured Project

### Automated Java Application CI/CD Pipeline Using Jenkins, Docker and Ansible

An end-to-end multi-server CI/CD implementation that automates the complete workflow from a GitHub source-code push to a running Java application container on AWS.

### Architecture

The project uses three AWS EC2 instances:

* **Jenkins Server:** Builds the application, creates Docker images and coordinates the CI/CD pipeline.
* **Ansible Control Server:** Manages configuration and application deployment.
* **Docker Application Server:** Runs the deployed Java application container.

### CI/CD Workflow

```text
Developer Push
      ↓
GitHub Repository
      ↓
GitHub Webhook
      ↓
Jenkins Pipeline
      ↓
Maven WAR Build
      ↓
Docker Image Build
      ↓
Docker Hub
      ↓
Jenkins Deployment Script
      ↓
Ansible Control Server
      ↓
Ansible Playbook
      ↓
Docker Application Server
      ↓
Java Application on Port 8080
```

### Technologies

* AWS EC2
* Jenkins
* Maven
* Docker
* Docker Hub
* Ansible
* Git and GitHub
* GitHub Webhooks
* Apache Tomcat
* Ubuntu Linux
* Bash
* YAML
* SSH

### What I Implemented

* Designed a three-server AWS architecture separating build automation, configuration management and application runtime.
* Developed a Jenkins declarative pipeline for source-code checkout, Maven packaging and Docker image creation.
* Created versioned Docker image tags using Jenkins build numbers.
* Stored Docker Hub credentials securely using Jenkins Credentials.
* Configured Jenkins to trigger the Ansible control server through a protected deployment script.
* Created an Ansible inventory for managing the Docker application server.
* Developed an idempotent playbook to install and configure Docker Engine.
* Developed a deployment playbook to pull the latest image and create or update the Java application container.
* Configured private-IP SSH communication between the Ansible and Docker servers.
* Configured GitHub webhooks for automatic pipeline execution.
* Troubleshot SSH, YAML, Docker repository, Jenkins credential and disk-space issues.

### Ansible Components

```text
ansible/
├── ansible.cfg
├── inventory/
│   └── hosts.ini.example
└── playbooks/
    ├── install-docker.yml
    └── deploy-java-app.yml
```

### Pipeline Stages

1. Verify environment
2. Check out source code
3. Build the Java application
4. Verify the WAR artifact
5. Build Docker images
6. Authenticate to Docker Hub
7. Push versioned Docker images
8. Trigger Ansible deployment
9. Verify deployment

### Repository

github.com/Vishwa2000-vij/Automated Java Application CI/CD Pipeline Using Jenkins, Docker and Ansible-Project
