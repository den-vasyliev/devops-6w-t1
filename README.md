# DevOps course | Week 6/Task 1

Automate the full CICD cycle for your bot service.

Use the Makefile, Dockerfile and Helm charts from your repository. Configure the Makefile and values.yaml to provide convenient automation of the image build and packaging process.

Create a Github Workflow that automatically builds your project, creates a container image, publishes it to ghcr.io, and deploys to Kubernetes using ArgoCD. Configure the Workflow to run on every push to the main code's develop branch. The new version of the tag is updated in the helm chart.

Add a graphical Workflow diagram to the readme file in the repository to make it more understandable for other developers.

Make sure your Github Workflow is working properly and test your Telegram bot.

After successful verification and testing, deploy the project to Kubernetes using ArgoCD.

The graphical diagram can look like a Workflow diagram that demonstrates the interaction of each step of the automated CI/CD process with other elements of the infrastructure to ensure automated deployment and testing of your Telegram bot.

**Task conditions:**

- CICD - GitHub Actions
- Container Registry - ghcr.io
- Deploy - ArgoCD
- Infrastructure - Kubernetes
- Event: push to the develop branch
- Platform: linux
- Architecture: amd64

The resulting container image link may look like this: ghcr.io/den-vasyliev/kbot:v1.0.0-106879e-linux-amd64,

where the specified fields correspond to the parameters of the helm chart:

- Image:
- registry: "ghcr.io"
- repository: "den-vasyliev/kbot"
- tag: "v1.0.0-106879e"
- os: linux
- arch: amd64

**Send the response as a link to the container image.**
Example response: ghcr.io/den-vasyliev/kbot:v1.0.0-106879e-linux-amd64

### Workflow process

It is pretty straightforward:

This GitHub workflow (defined as a YAML file) describes a Continuous Integration/Continuous Deployment (CI/CD) pipeline for a software application. Here's a breakdown of the main steps:

**on::** This part specifies when the workflow will be triggered. Here, it's configured to start every time a new commit is pushed to the develop branch.

**permissions::** Defines the permissions for the GITHUB_TOKEN used in the workflow. Here, the token has write access to the contents of the repository.

1. build_and_push:: This is the first job of the workflow. It has several steps:

   1.1 Checkout: This step uses a predefined action (actions/checkout@v3) to clone the code of the current repository into the runner, an ephemeral virtual machine where the job runs.

   1.2 Run tests: This step runs the make test command, which should execute your project's test suite.

   1.3 Log in to registry: Logs into the Docker registry at ghcr.io (GitHub Container Registry) using a secret stored in the repository.

   1.4 Build and push to ghcr.io: Builds the Docker image of the application and pushes it to GitHub Container Registry. The tag for the image will be the SHA of the current git commit.

   1.5 echo "VERSION=...: This command generates a version string from the latest git tag and the short commit SHA, then saves this version string in an environment variable.

   1.6 yq -i '.image.tag=strenv(VERSION)' helm/values.yaml: This uses yq, a command-line YAML processor, to update the image tag in the Helm values.yaml file to the version string.

   1.7 git config... git commit... git tag... git push...: These commands set the git user to the GitHub actions bot, commit the changes made to the Helm values file, create a new git tag with the version string, and push the new tag to the remote repository.

2. deploy:: This is the second job, which depends on the first job build_and_push. It deploys the application into a Kubernetes cluster:

   2.1 Set up k8s minikube: This step sets up a Minikube environment, which is a mini Kubernetes cluster, for the deployment. It downloads and installs Minikube, then starts it with the Docker driver.

   2.2 Install kubectl: This step downloads and installs kubectl, the Kubernetes command-line tool.

   2.3 Install ArgoCD CLI: This step creates a new namespace in the Kubernetes cluster and deploys ArgoCD into it. ArgoCD is a Continuous Delivery tool for Kubernetes.

   2.4 Deploy ArgoCD to Kubernetes: This step configures kubectl to use the argocd context, exposes the ArgoCD server service as a LoadBalancer, starts port-forwarding so that the ArgoCD CLI can access the ArgoCD server, retrieves the initial admin password, logs in to ArgoCD, sets the application image in the ArgoCD app to the new version, and synchronizes the ArgoCD app so it matches the desired state described in the app manifest.
