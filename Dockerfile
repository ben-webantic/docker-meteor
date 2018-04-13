ARG NODE_VERSION=8.11.1
FROM node:${NODE_VERSION} as meteor
ARG METEOR_VERSION=1.6.1.1
ENV METEOR_VERSION=${METEOR_VERSION}
RUN curl https://install.meteor.com/?release=${METEOR_VERSION} | sh
RUN npm -g install node-gyp
