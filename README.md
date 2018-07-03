# Webantic NodeJS + Meteor

This image is for building Meteor based projects.
As they output the relevant code on building there's no need to use this for deployment.

## Deployment

### Docker-Compose

```yaml
services:
  core:
    build:
      context: core
      target: build
      args:
        - NPM_TOKEN
    command: ["meteor", "-s", "settings.json", "--port", "3000", "--inspect=0.0.0.0:9229"]
    environment:
      DEBUG: project*
      MONGO_URL: mongodb://mongo/meteor
    ports:
      - "3000:3000" # HTTP port
      - "9229:9229" # Node debug port
    volumes:
      - ./core:/home/node/app
      - core-meteor-local:/home/node/app/.meteor/local
      - core-meteor-packages:/home/node/.meteor/packages
      - core-node-modules:/home/node/app/node_modules
```

### Dockerfile

```Dockerfile
# Build Image

FROM webantic/meteor:8 as build
USER node
ARG NPM_TOKEN
COPY --chown=node .npmrc.deploy /home/node/.npmrc
WORKDIR /home/node/app
COPY --chown=node package*.json ./
RUN npm set progress=false && npm install -s --no-progress
VOLUME ["/home/node/app/node_modules/"]
EXPOSE 4229

# Predeploy Image

FROM build as predeploy
USER node
WORKDIR /home/node/app
COPY --chown=node . ./
RUN meteor build . --directory
RUN cd bundle/programs/server && npm set progress=false && npm install -s --no-progress --production

# Deployment Image

FROM node:8-slim as deploy

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

USER node
WORKDIR /home/node/app
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin
RUN npm -g install forever
COPY --chown=node --from=predeploy /home/node/app/bundle ./
EXPOSE 80

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
