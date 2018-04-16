ARG NODE_VERSION=8.11.1
FROM node:${NODE_VERSION} as meteor
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ARG METEOR_VERSION=1.6.1.1
ENV METEOR_VERSION=${METEOR_VERSION}
RUN curl https://install.meteor.com/?release=${METEOR_VERSION} | sh
RUN npm -g install node-gyp
USER node
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin
RUN mkdir /home/node/app && meteor || :
