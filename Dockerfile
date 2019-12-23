FROM linkyard/docker-atlassian-plugin-sdk
LABEL maintainer="Sebastian Knopp <sebastian.knopp@fkie.fraunhofer.de>"

WORKDIR /
ADD ./runAtlasMvn.sh .
WORKDIR /home/

# install required selenium dependencies
RUN apt update \
    && apt install -y firefox xvfb xsel xclip \
    && rm -rf /var/lib/apt/lists/*

# build maven dependency cache
RUN echo "com.tmp\ntmpProject\n" | atlas-create-bamboo-plugin \
    && cd tmpProject && atlas-mvn integration-test -Dserver='127.0.0.1' \
    && cp -r target/testlibs /
    && cd .. && rm -rf tmpProject

ENV DISPLAY=:99
WORKDIR /app

ENTRYPOINT ["../runAtlasMvn.sh"]
