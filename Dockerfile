ARG NODE_VERSION=8.11.3
FROM node:${NODE_VERSION} as meteor
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ARG METEOR_VERSION=1.7.0.3
ENV METEOR_VERSION=${METEOR_VERSION}
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
USER node
WORKDIR /home/node/app
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin:/home/node/.meteor
RUN npm -g install node-gyp
RUN curl https://install.meteor.com/?release=${METEOR_VERSION} | sh && meteor || :
