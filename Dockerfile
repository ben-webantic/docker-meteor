ARG NODE_VERSION=8.10.0
FROM node:${NODE_VERSION} as meteor
ENV METEOR_VERSION=1.6.1
RUN curl "https://install.meteor.com/?release=${METEOR_VERSION}" | sh
RUN npm -g install node-gyp
