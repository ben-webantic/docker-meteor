ARG NODE_VERSION=10.13.0
FROM node:${NODE_VERSION} as meteor
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ARG NPM_VERSION=6.4.1
ENV NPM_VERSION=${NPM_VERSION}
RUN npm -g install npm@${NPM_VERSION}
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
USER node
WORKDIR /home/node/app
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin:/home/node/.meteor
RUN npm -g install node-gyp
ARG METEOR_VERSION=1.8
ENV METEOR_VERSION=${METEOR_VERSION}
RUN curl https://install.meteor.com/?release=${METEOR_VERSION} | sh && meteor || :
