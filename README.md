# Webantic NodeJS + Meteor

This image can be used for building Meteor based projects. As they output the relevent code on building there's no need to use this for deployment.

## Deployment

### Dockerfile

```Dockerfile
FROM webantic/meteor:8 as build
WORKDIR /usr/src/app
ARG NPM_TOKEN
COPY .npmrc.deploy .npmrc
COPY package*.json ./
RUN npm install
COPY . ./
RUN meteor build . --directory --allow-superuser
RUN cd bundle/programs/server && npm install --production

FROM node:8-slim as deploy
WORKDIR /usr/src/app
RUN npm -g install forever
COPY --from=build /usr/src/app/bundle ./

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