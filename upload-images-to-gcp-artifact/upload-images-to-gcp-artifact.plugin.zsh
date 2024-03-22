#!/bin/bash

ERROR_LOG_FILE=/tmp/artifact_pusher_errors.log


download_images() {
    chart_name=$(basename $1)
    echo "Chart name is: $chart_name"
    if [[ $# -ge 4 ]]; then
        values_file=$4
        container_images=$(helm template $chart_name my_repo/$chart_name --values $values_file| grep -oE 'image:\s*[^[:space:]]+' | sed 's/image:\s*//' | sort -u)
    else
        container_images=$(helm template $chart_name my_repo/$chart_name | grep -oE 'image:\s*[^[:space:]]+' | sed 's/image:\s*//' | sort -u)
    fi
    
    while IFS= read -r image; do
        image=$(echo "$image" | tr -d '"')
        # Remove the digest and everything after the @ sign
        if [[ $image == *"@"* ]]; then
            image="${image%%@*}"
        fi
        image="${image#"${image%%[![:space:]]*}"}"
        echo "Pulling image $image"
        docker pull $image
        if [[ $? -ne 0 ]]; then
            echo "==========================================================================="
            echo "ERROR: Failed to pull $image. Run command manually for verification"
            echo "docker pull $image"
            return
            echo "==========================================================================="
        fi
        echo "==========================================================================="
        echo "Tagging image $image to me-west1-docker.pkg.dev/$2/$3/$(basename $image)"
        docker tag $image me-west1-docker.pkg.dev/$2/$3/$(basename $image)
        # echo "To push to GCP artifact use the following command: "
        echo "==========================================================================="
        echo "Pushing image $(basename $image) to GCP Artifact me-west1-docker.pkg.dev/$2/$3/"
        # echo "docker push me-west1-docker.pkg.dev/$2/$3/$(basename $image)"
	    docker push me-west1-docker.pkg.dev/$2/$3/$(basename $image)
        docker rmi -f $image
    done <<< "$container_images"
}


upload_images_to_gcp_artifact() {
    if [[ $# -le 3 ]] || [[ $# -ge 6 ]]; then
        echo "=========================================================================================="
        echo "This scripts used for pushing container images to GCP Artifact Registr based on Helm-Chart"
        echo "=========================================================================================="
        echo "Usage: $0 <repo_url> <chart_name> <project_id> <artifact_repository>"
        echo "Optional arguments: <values_file>"
        echo "=========================================================================================="
        echo "Examples:"
        echo "$0 https://charts.external-secrets.io external-secrets test-project external-secrets-images"
        echo "$0 https://charts.external-secrets.io external-secrets test-project external-secrets-images values.yaml"
        echo "=========================================================================================="
        echo ""
        return
    fi

    repo_url=$1
    chart_name=$2
    project_id=$3
    artifact_repository=$4
    values_file=$5

    helm repo add my_repo $repo_url > /dev/null 2>&1
    helm repo update > /dev/null 2>&1
    download_images my_repo/$chart_name $project_id $artifact_repository $values_file
    helm repo remove my_repo > /dev/null 2>&1
}
