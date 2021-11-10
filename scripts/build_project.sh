#!/usr/bin/env bash

usage() { echo "Usage: $0 -p <project directory> -r <zephyr-rust> -w <zephyr-rust-wrappers> [-b <board>]" 1>&2; exit 1; }


CONTAINER="kdvkrs/zephyr-container-rust:latest"

while getopts "p:b:r:w:" o; do
    case "${o}" in
		b)
			board=${OPTARG}
			;;
		p)
			p=${OPTARG}
			;;
		r)
			r=${OPTARG}
			;;
        w)
            w=${OPTARG}
            ;;
		*)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${board}" ]; then
    board="thingy52_nrf52832"
fi

if  [ -z "${p}" ] || [ -z "${r}" ] || [ -z "${w}" ] || [ -z "${board}" ]; then
    usage
fi

# check if podman or docker is installed
if [ -x "$(command -v podman)" ]; then
    echo 'Found podman installation' >&2
    CMD=podman
elif [ -x "$(command -v docker)" ]; then
    echo 'Found docker installation' >&2
    CMD=docker
else 
    echo 'Found neither docker nor podman installation' >&2
    exit 1
fi

$CMD run --rm -it --name iot-build-container -v /dev/usb:/dev/usb -v /run/udev:/run/udev:ro \
	 --network host --privileged -v ${p}:/workingdir/project -v ${r}:/workingdir/zephyr-rust --workdir /workingdir/project \
     -v ${w}:/workingdir/zephyr-rust-wrappers $CONTAINER bash -lc "west build -p -b ${board} ."
