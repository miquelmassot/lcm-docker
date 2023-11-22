FROM debian:bookworm-slim AS runtime-base

# Set arguments
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Set environment variables
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8
ENV TZ=Europe/London

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    build-essential \
    cmake \
    make \
    g++ \
    libglib2.0-dev \
    python3-dev \
    byobu \
    bash \
    sudo \
    locales \
    tzdata \
    #    default-jdk \
    #    libjchart2d-java \
    #    liblua5.3-dev \
    #    lua5.3 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the Kernel UDP buffer size to 10MB
RUN echo 'net.core.rmem_max=10485760' >> /etc/sysctl.conf
RUN echo 'net.core.rmem_default=10485760' >> /etc/sysctl.conf

# Remove timezone warnings
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set locales
RUN locale-gen en_UK.UTF-8 && dpkg-reconfigure locales

#FROM runtime-base AS build
ENV LCM_VERSION '1.5.0'

# Install LCM
RUN \
    # Pull lcm
    wget https://github.com/lcm-proj/lcm/archive/refs/tags/v$LCM_VERSION.zip && \
    # Open up the source
    unzip v$LCM_VERSION.zip && \
    # Configure, build, install, and configure LCM
    cd lcm-$LCM_VERSION && mkdir build && cd build && cmake ../ && make -j install

# Delete source code
RUN cd / && rm -rf v$LCM_VERSION.zip lcm-$LCM_VERSION

# Configure pkgconfig to find LCM
ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$LCM_INSTALL_DIR/pkgconfig

# Create the user
RUN addgroup --gid $USER_GID --system $USERNAME \
    && adduser --uid $USER_UID --gid $USER_GID --shell /bin/bash --disabled-password --home /home/$USERNAME --system $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Save bash history between sessions
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R $USERNAME /commandhistory \
    && echo "$SNIPPET" >> "/home/$USERNAME/.bashrc"

# Set the default user.
USER $USERNAME

# Setup shell
SHELL ["/bin/bash", "-c"]
ENTRYPOINT [ "/bin/bash" ]