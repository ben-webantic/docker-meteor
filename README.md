# Webantic NodeJS + Meteor

This image is for building Meteor based projects.
As they output the relevant code on building there's no need to use this for deployment.

## Deployment

### Dockerfile

```Dockerfile
# Build Image

FROM webantic/meteor:8 as build
USER node
WORKDIR /home/node/app

ARG NPM_TOKEN
COPY --chown=node .npmrc.deploy .npmrc
COPY --chown=node package*.json ./
RUN npm install

COPY --chown=node . ./
RUN meteor build . --directory
RUN cd bundle/programs/server && npm install --production

# Deployment Image

FROM node:8-slim as deploy

ENV TINI_VERSION v0.17.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

USER node
WORKDIR /home/node/app
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin
RUN npm -g install forever
COPY --chown=node --from=build /home/node/app/bundle ./

EXPOSE 80
CMD ["forever", "--minUptime", "5000", "--spinSleepTime", "500", "main.js"]

```

### .npmrc.deploy

    //registry.npmjs.org/:_authToken=${NPM_TOKEN}

## Building

### Customising the image

* The `NODE_VERSION` build argument can be used to select which version of node to build from.

      --build-arg NODE_VERSION=8.10.0

* The `METEOR_VERSION` environment variable can be used to install a different version of meteor.

      --build-arg METEOR_VERSION=1.6.1

### Building the image

    docker build (--build-arg foo=bar...) -t webantic/meteor:8.10.0 -t webantic/meteor:8.10 -t webantic/meteor:8 -t webantic/meteor:latest .

* Note that the version numbers for the tags should match the major/minor/build, major/minor, major numbering of the `NODE_VERSION` variable

### Pushing to Docker Hub

As the image is tagged as webantic/meteor it will automagically go to the right place

    docker push webantic/meteor
