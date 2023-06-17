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
