# Cloud-Based Automated CI/CD Pipeline

**MCA Final Year Project**
**Student:** Abhishek Parmar (151014)
**Institution:** DPG School of Technology & Management

---

## Project Overview

This project implements a fully automated CI/CD pipeline that deploys a Node.js application to AWS EC2 using Docker containers. When code is pushed to this repository, the pipeline automatically tests, builds, and deploys the application — with zero manual steps.

**Live Dashboard:** https://6a1c0c3c9a3b3f31875bfc3c--magical-cascaron-49544b.netlify.app

---

## Pipeline Stages

| Stage | Tool | Description |
|---|---|---|
| Source Checkout | Git | Pull latest code from GitHub |
| Install Dependencies | npm ci | Install Node.js packages |
| Lint | ESLint | Static code analysis |
| Unit Tests | Jest | Run 18 automated tests |
| Docker Build | Docker | Build multi-stage container image |
| Push to ECR | AWS ECR | Push image to container registry |
| Deploy to EC2 | SSH + Docker | Deploy container to AWS servers |
| Health Check | curl | Verify deployment success |

---

## Technologies Used

- **GitHub** — Source code version control
- **Jenkins** — CI/CD pipeline automation
- **Docker** — Application containerization
- **AWS EC2** — Cloud compute instances (t3.small)
- **AWS ECR** — Docker image registry
- **AWS ALB** — Application Load Balancer
- **AWS Auto Scaling** — Automatic server scaling
- **AWS CloudWatch** — Monitoring and alerting
- **Node.js + Express** — Application runtime
- **Jest** — Unit testing framework
- **ESLint** — Code quality analysis

---

## Key Results

- Deployment time reduced from 4-8 hours to under 5 minutes
- Docker image size reduced from 912 MB to 118 MB (multi-stage build)
- 18/18 unit tests passing automatically on every commit
- 15/15 system test cases passed — 100% pass rate
- Auto Scaling response: 2 min 15 sec (target: 3 min)
- System uptime: 99.97%

---

## Project Structure

```
cicd-pipeline/
├── src/
│   ├── server.js
│   ├── routes/api.js
│   └── __tests__/
│       ├── auth.test.js
│       ├── api.test.js
│       └── utils.test.js
├── Dockerfile
├── Jenkinsfile
├── deploy.sh
├── package.json
└── README.md
```
