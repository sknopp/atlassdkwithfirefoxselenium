FROM linkyard/docker-atlassian-plugin-sdk
LABEL maintainer="Sebastian Knopp <sebastian.knopp@fkie.fraunhofer.de>"

WORKDIR /
ADD ./runAtlasMvn.sh .
WORKDIR /home/

# install required selenium dependencies
RUN apt update \
    && apt install -y git wget firefox xvfb xsel xclip \
    && wget -O geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz \
    && tar -xvzf geckodriver.tar.gz \
    && chmod +x geckodriver \
    && rm -rf /var/lib/apt/lists/* /home/geckodriver.tar.gz

ENV PATH=$PATH:/home
ENV DISPLAY=:99

EXPOSE 6990
VOLUME /root/.m2/repository

ENV ATLAS_TARGET_DIR=/tmp/target
WORKDIR /app

ENTRYPOINT ["../runAtlasMvn.sh"]
