# VU_InternetOfThings_Container

This repository is a fork from https://github.com/LehrChristoph/VU_InternetOfThings_Container and was
expanded to include the rust toolchain required to use Rust with Zephyr.

The image is available at https://hub.docker.com/repository/docker/kdvkrs/zephyr-container-rust

# Helper Scripts:

A set of scripts is located inside the `scripts` folder.

`setup.sh` : Installs the required udev rules and pulls the container from docker hub.

`open_shell.sh` : Starts the container with the usb devices mounted as well as the project folder. The project you want to work on will be mounted under `/workingdir/project`, which is also the entry point of the container.

`open_x11_shell.sh` : Does the same as `open_shell.sh`, but additionally provides the possibility of openen GUI applications, e.g. for the segger RTT Viewer.

`build_project.sh` : Uses west to build the project provided `-p` flag. The `-b` sets to board, for the lecture this can be omited the default value is `thingy52_nrf5283`.

`flash_board.sh` : Flashes the board using `west flash`

`open_RTT_viewer.sh` : Opens the segger JLink RTT Viewer for debugging.

# Building the container

The Dockerfile inside `container` is self-contained and the image can be built by using `docker build .` inside the directory.
