FROM ubuntu:20.04

ARG ZSDK_VERSION=0.13.1
ARG GCC_ARM_NAME=gcc-arm-none-eabi-10-2020-q4-major
ARG CMAKE_VERSION=3.20.5
ARG RENODE_VERSION=1.12.0
ARG LLVM_VERSION=12
ARG BSIM_VERSION=v1.0.3
ARG WGET_ARGS="-q --show-progress --progress=bar:force:noscroll --no-check-certificate"

ARG UID=1000
ARG GID=1000

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && \
	apt-get -y update && \
	apt-get -y upgrade && \
	apt-get install --no-install-recommends -y \
	gnupg \
	ca-certificates && \
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
	echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
	apt-get -y update && \
	apt-get install --no-install-recommends -y \
	software-properties-common \
	lsb-release \
	autoconf \
	automake \
	bison \
	build-essential \
	ccache \
	chrpath \
        clang \
	cpio \
	curl \
	device-tree-compiler \
	dfu-util \
	diffstat \
	dos2unix \
	doxygen \
	file \
	flex \
	g++ \
	gawk \
	gcc \
	gcc-multilib \
	g++-multilib \
	gcovr \
	git \
	git-core \
	gperf \
	gtk-sharp2 \
	help2man \
	iproute2 \
	lcov \
	libglib2.0-dev \
	libgtk2.0-0 \
	liblocale-gettext-perl \
	libncurses5-dev \
	libpcap-dev \
	libpopt0 \
	libsdl2-dev:i386 \
	libsdl1.2-dev \
	libsdl2-dev \
	libssl-dev \
	libtool \
	libtool-bin \
	locales \
	make \
	nano \
	net-tools \
	ninja-build \
	openssh-client \
	pkg-config \
	protobuf-compiler \
	python3-dev \
	python3-pip \
	python3-ply \
	python3-setuptools \
	python-is-python3 \
	qemu \
	rsync \
	screen \
	socat \
	srecord \
	sudo \
	texinfo \
	tmux \
	unzip \
	valgrind \
	wget \
	ovmf \
	vim \
	xz-utils && \
	wget ${WGET_ARGS} https://github.com/renode/renode/releases/download/v${RENODE_VERSION}/renode_${RENODE_VERSION}_amd64.deb && \
	apt install -y ./renode_${RENODE_VERSION}_amd64.deb && \
	rm renode_${RENODE_VERSION}_amd64.deb && \
	rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# install cmake 
RUN cd /tmp && wget ${WGET_ARGS} https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh && \
	chmod +x cmake-${CMAKE_VERSION}-Linux-x86_64.sh && \
	./cmake-${CMAKE_VERSION}-Linux-x86_64.sh --skip-license --prefix=/usr/local && \
	rm -f ./cmake-${CMAKE_VERSION}-Linux-x86_64.sh

# Zephyr and python dependencies

RUN pip3 install wheel pip west 
ENV PATH=/.local/bin:$PATH
RUN west init /workingdir && cd /workingdir && west update
RUN cd /workingdir && west zephyr-export && pip3 install -r /workingdir/zephyr/scripts/requirements.txt

# Install toolcahin
RUN cd /tmp && wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.13.1/zephyr-sdk-0.13.1-linux-x86_64-setup.run && \
	chmod +x zephyr-sdk-0.13.1-linux-x86_64-setup.run && ./zephyr-sdk-0.13.1-linux-x86_64-setup.run -- -d /opt/zephyr-sdk-0.13.1 && \
	rm -rf zephyr-sdk-0.13.1-linux-x86_64-setup.run

# install segger jlink
RUN cd /tmp && wget --post-data="accept_license_agreement=accepted&submit=Download&nbspsoftware" https://www.segger.com/downloads/jlink/JLink_Linux_V756b_x86_64.deb && \
	dpkg -i ./JLink_Linux_V756b_x86_64.deb && rm -rf JLink_Linux_V756b_x86_64.deb
ENV PATH=/opt/SEGGER/JLink:$PATH

# Install jlinknrf 
RUN cd /tmp && wget https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF-command-line-tools/sw/Versions-10-x-x/10-14-0/nRF-Command-Line-Tools_10_14_0_Linux64.zip &&\
	unzip nRF-Command-Line-Tools_10_14_0_Linux64.zip && dpkg -i nRF-Command-Line-Tools_10_14_0_Linux64/nrf-command-line-tools_10.14.0_amd64.deb && \
	rm -rf nRF-Command-Line-Tools_10_14_0_Linux64*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain 1.51.0 -y

WORKDIR /workingdir
