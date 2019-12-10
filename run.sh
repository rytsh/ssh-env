#!/bin/bash
###############
# Build and Run
# <eray@devusage.com>
###############

function usage() {
    cat - <<EOF
SSH-ENV container runner
Usage: $0 <OPTIONS>

OPTIONS:
    --image
        Set image name default ryts/ssh-env
    --con
        Set container name default ssh-env
    --build
        Build image if not exists
    --download
        Download image in dockerhub if not exists
    -s, --shell
        Open new shell in container
    --remove
        Remove con, image
        (--remove con --remove image)
    -h, --help
        This help page
EOF
}

while [[ "$#" -gt 0 ]]; do
    case "${1}" in
    --image)
        IMAGE_NAME="${2}"
        shift 2
        ;;
    --con)
        CONTAINER_NAME="${2}"
        shift 2
        ;;
    --build)
        BUILD="Y"
        shift 1
        ;;
    --download)
        DOWN="Y"
        shift 1
        ;;
    -s | --shell)
        SHELL="Y"
        shift 1
        ;;
    --remove)
        declare -a REMOVE
        varx="${2}"
        while true; do
            case "${varx}" in
            image)
                if [[ ! " ${REMOVE[@]} " =~ " image " ]]; then
                    REMOVE+=("${varx}")
                fi
                varx="con"
                ;;
            con)
                if [[ ! " ${REMOVE[@]} " =~ " con " ]]; then
                    REMOVE+=("${varx}")
                fi
                shift 2
                break
                ;;
            *)
                echo "With --remove option just for 'con' or 'image'"
                exit 1
                ;;
            esac
        done
        # yeah little bit confuse
        # switch/case doesn't accept without ;; between cases
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    *)
        usage >&2
        exit 1
        ;;
    esac
done

IMAGE_NAME=${IMAGE_NAME:-"ryts/ssh-env"}
CONTAINER_NAME=${CONTAINER_NAME:-"ssh-env"}

# Check image exist
output=$(docker images --format {{.Repository}} | grep ${IMAGE_NAME})
if [[ ! $output ]]; then
    if [[ ${BUILD} == "Y" ]]; then
        (
            cd ci
            docker build -t ${IMAGE_NAME} -f Dockerfile . # --rm=false for debug
        )
    elif [[ ${DOWN} == "Y" ]]; then
        docker pull ${IMAGE_NAME}
    else
        echo "Image not found: ${IMAGE_NAME}"
        exit 1
    fi
fi

# Check remove
if [[ -n "${REMOVE}" ]]; then
    if [[ " ${REMOVE[@]} " =~ " con " ]]; then
        echo "Removing container ${CONTAINER_NAME}"
        docker stop ${CONTAINER_NAME} >/dev/null 2>&1
        docker rm ${CONTAINER_NAME} >/dev/null 2>&1
    fi

    if [[ " ${REMOVE[@]} " =~ " image " ]]; then
        echo "Removing image ${IMAGE_NAME}"
        docker rmi ${IMAGE_NAME} >/dev/null 2>&1
    fi
    exit 0
fi

# Run if not exist
output=$(docker ps -a --format {{.Names}} | grep ${CONTAINER_NAME})
if [[ ! $output ]]; then
	echo "Docker Run"
	docker run -d --rm -p 2222:22 -v /:/workspace --name "${CONTAINER_NAME}" "${IMAGE_NAME}"
else
	output=$(docker ps --format {{.Names}} | grep ${CONTAINER_NAME})
	if [[ $output ]]; then
		if [[ ${SHELL} == "Y" ]]; then
			echo "Opened new shell in ${CONTAINER_NAME}"
			docker exec -i -t ${CONTAINER_NAME} /bin/sh
		fi
	else
		echo "Started ${CONTAINER_NAME}"
		docker start ${CONTAINER_NAME}
	fi
fi
