FROM docker.io/steamcmd/steamcmd:ubuntu-26

ARG WINETRICKS_VERSION=20260125

ENV DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386

# winetricks is fetched from GitHub rather than apt, so its runtime dependencies
# (binutils, cabextract, unzip, 7zip, xz-utils) are installed explicitly here
RUN apt update && apt install -y --no-install-recommends \
  locales \
  tzdata \
  wget \
  gpg \
  winbind \
  xwayland \
  weston \
  xauth \
  binutils \
  cabextract \
  unzip \
  7zip \
  xz-utils \
  && rm -rf /var/lib/apt/lists/*

# WineHQ's repo tracks upstream stable, the Ubuntu archive lags a major version behind
RUN . /etc/os-release \
  && mkdir -pm755 /etc/apt/keyrings \
  && wget -qO - https://dl.winehq.org/wine-builds/winehq.key \
    | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key \
  && wget -qNP /etc/apt/sources.list.d/ \
    "https://dl.winehq.org/wine-builds/ubuntu/dists/${VERSION_CODENAME}/winehq-${VERSION_CODENAME}.sources"

# something in --install-recommends is required... bloatware :(, will look into to reduce
# overall image size as 5GB is crazy
RUN apt update && apt install -y --install-recommends \
  winehq-stable \
  && rm -rf /var/lib/apt/lists/*

RUN wget -qO /usr/local/bin/winetricks \
    "https://raw.githubusercontent.com/Winetricks/winetricks/${WINETRICKS_VERSION}/src/winetricks" \
  && chmod +x /usr/local/bin/winetricks

ENV USER=ubuntu
USER $USER

ENV HOME=/home/$USER
WORKDIR $HOME

ENV WINEPREFIX=$HOME/.wine
ENV WINEDLLOVERRIDES="mscoree=n,b;mshtml=n,b;winhttp=n,b"
ENV WINEDEBUG=fixme-all,err-d3d_shader
ENV XDG_RUNTIME_DIR=/tmp/$USER
ENV DISPLAY=:0

RUN winetricks -q dotnet48
RUN mkdir -p ".wine/drive_c/users/$USER/Documents/"

RUN mkdir /tmp/$USER /tmp/.X11-unix && chmod 0700 /tmp/$USER

COPY --chown=${USER}:${USER} --chmod=755 run-game.sh /

ENTRYPOINT [ "/run-game.sh" ]

# Labels & metadata
LABEL org.opencontainers.image.source=https://github.com/crowz-fx/headless-game-server-steam
LABEL org.opencontainers.image.description="Run your steam games headless when a multiplayer server is required (like Dyson Sphere)"
LABEL org.opencontainers.image.licenses=MIT
