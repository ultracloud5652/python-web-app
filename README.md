# **Python Web App Deployment on AWS with Terraform**

#### This project demonstrates how to deploy a Python web application (using Flask) on AWS using Terraform for infrastructure provisioning, Docker for containerization, and CI/CD for automated deployment with GitHub Actions.

## **Project Overview**

#### This project automates the deployment of a simple Python Flask web application on AWS, provisioning infrastructure using Terraform. It includes the following components:

- AWS EC2: The server running the Python Flask application inside a Docker container.
- AWS S3: Optional, used for storing static files.
- VPC, Subnets, Security Groups: To configure networking and access.
- Docker: Containerizing the Python web application.
- Terraform: Infrastructure as Code (IaC) to manage the resources.
- GitHub Actions: CI/CD pipeline to automate Docker image building and deployment.

## **Features**

- **Infrastructure** Provisioning with Terraform: Automatically provisions resources like EC2, VPC, Subnets, S3, etc.
- **Dockerizatio**: The Python web application is containerized using Docker for consistent deployment.
- **CI/CD Pipeline**: GitHub Actions to automate Docker image build and deployment.
- **Public Access**: The EC2 instance is in a public subnet, making it accessible from the internet.
- **Security**: Configured Security Groups to allow SSH and HTTP access.

## Prerequisites

- **AWS Account**: Set up your AWS account if you don't already have one.
- **Terraform**: Install Terraform. You can follow the instructions [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
- **Docker**: Install Docker for containerization. Follow the installation guide [here](https://docs.docker.com/engine/install/ubuntu/).
- **GitHub Account**: For hosting the repository and setting up GitHub Actions.

## **Project Structure**

```
├── .github/
│   └── workflows/
│       └── ci-cd.yml           # GitHub Actions CI/CD pipeline file
├── Dockerfile                  # Dockerfile for containerizing the Flask app
├── main.tf                     # Terraform configuration to manage AWS resources
├── requirements.txt            # Python dependencies
├── .gitignore                  # Git ignore file
├── README.md                   # Project documentation
└── app.py                       # Python Flask application code
```

## **Setup and Installation**

### **1. Clone the Repository**

#### Clone the repository to your local machine:
```
git clone https://github.com/<github-username>/python-web-app.git
cd python-web-app
```

### **2. Install Terraform**

#### Install Terraform using the [official instructions](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

### **3. Configure AWS CLI**

#### Configure your AWS credentials using the AWS CLI:

```
aws configure
```

#### Enter your AWS Access Key, Secret Key, and Region when prompted.

### **4. Initialize Terraform**

#### Run the following command to initialize Terraform and download the necessary provider plugins:

```
terraform init
```
### **5. Apply Terraform Configuration**

#### Run the following command to apply the Terraform configuration and provision the AWS resources:

```
terraform apply
```

### **6. Build and Run the Docker Container**

#### After Terraform provisions the resources, you can build and run the Docker container locally to test it:
```
docker build -t python-web-app .
docker run -p 80:80 python-web-app
```

### **7. Set Up GitHub Actions (CI/CD)**

#### 1. Go to your GitHub repository, and in the Settings > Secrets, add your Docker Hub credentials:
- `DOCKER_USERNAME`: Your Docker Hub username.
- `DOCKER_PASSWORD`: Your Docker Hub password or access token.

#### 2. GitHub Actions will automatically trigger a build and push the Docker image to Docker Hub on every push to the main branch. The workflow file is located in .github/workflows/ci-cd.yml.

### **8. Access the Web Application**

#### After the EC2 instance is up and running, you can access the Flask application through the EC2 instance's Public IP or DNS.

### **9. (Optional) Set Up S3 Bucket for Static Files**

#### If you're using the S3 bucket for storing static files, make sure the permissions and access policies are set correctly in the Terraform configuration.

## **Application Code**

#### The application is a simple Python Flask web app that serves static content. The code is in the app.py file, and the web app can be run locally using Docker.

### **How to Run Locally**

- Install dependencies: `pip install -r requirements.txt`
- Start the application: `python app.py`

#### The application listens on port 80 by default and will be accessible at http://localhost:80.

## **Terraform Code**

#### The infrastructure is managed using Terraform, which provisions the following AWS resources:

- EC2 instance to run the Flask application
- VPC and subnets for networking
- Security groups to control access
- S3 bucket (optional) for static file storage

### **How to Deploy Infrastructure**

- Initialize Terraform: `terraform init`
- Apply Terraform configuration: `terraform apply`

#### This will automatically provision the resources required to deploy the Flask app on AWS.

## **CI/CD Configuration**

#### The project uses GitHub Actions for automating the Docker image build and deployment process. The CI/CD pipeline is defined in `.github/workflows/ci-cd.yml`.

### **Pipeline Steps:**


- **Checkout Code**: Fetches the latest code from the GitHub repository.
- **Docker Login**: Logs in to Docker Hub using stored secrets.
- **Build and Push Image**: Builds the Docker image from the `Dockerfile` and pushes it to Docker Hub.

## **Technologies Used**

- **Terraform**: Infrastructure as Code for provisioning AWS resources.
- **AWS**: Cloud provider for hosting the EC2 instance and S3 storage.
- **Docker**: Containerization of the Python Flask application.
- **Python Flask**: Web framework for creating the web application.
- **GitHub Actions**: CI/CD pipeline to automate Docker image building and deployment.

## **Future Enhancements**

- **Multi-tier Architecture**: Split the application into multiple layers (e.g., frontend, backend) with separate services like RDS for the database.
- **Auto Scaling**: Implement auto-scaling for EC2 instances based on traffic.
- **Monitoring & Logging**: Integrate AWS CloudWatch for application logging and monitoring.
- **Security Enhancements**: Implement better security practices such as using IAM roles and security groups with tighter restrictions.

## **Contributing**

#### Feel free to fork this repository and submit pull requests. Contributions, bug reports, and suggestions are welcome!

## **License**

#### This project is licensed under the MIT License.


