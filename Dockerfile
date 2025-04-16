FROM docker.io/steamcmd/steamcmd:ubuntu-24

ENV DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386

RUN apt-get clean autoclean -y && apt-get autoremove
RUN rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

RUN apt update && apt install -y --no-install-recommends \
  locales \
  tzdata \
  wget \
  curl \
  winbind \
  xwayland \
  weston \
  xauth \
  && rm -rf /var/lib/apt/lists/*

# something in --install-recommends is required... bloatware :(, will look into to reduce
# overall image size as 5GB is crazy
RUN apt update && apt install -y --install-recommends \
  wine \ 
  # wine32:i386 \
  winetricks \
  && ln -s /usr/bin/wine /usr/bin/wine64 \
  && rm -rf /var/lib/apt/lists/*

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
RUN mkdir -p ".wine/drive_c/users/ubuntu/Documents/"

RUN mkdir /tmp/{$USER,.X11-unix} && chmod 0700 /tmp/$USER

ADD --chown=${USER}:${USER} run-game.sh /

RUN chmod +x /run-game.sh
ENTRYPOINT [ "/run-game.sh" ]
