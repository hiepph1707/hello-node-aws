sudo docker build -t ${DOCKER_IMAGE}:${BUILD_ID} .
sudo docker tag ${DOCKER_IMAGE}:${BUILD_ID} ${ECR_REPO}:${BUILD_ID}

