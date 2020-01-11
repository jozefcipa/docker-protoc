source ./vars.sh

for lang in "${SUPPORTED_LANGUAGES[@]}"; do
    target="protoc-${lang}"
    name="${DOCKER_NAMESPACE}/${target}:${DOCKER_TAG}"
    echo -e "\033[0;32mPushing ${name}\n\033[0m";
    docker push "${name}"
done
