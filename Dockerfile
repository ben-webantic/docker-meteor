FROM node:8 as meteor
RUN curl https://install.meteor.com/ | sh
RUN npm -g install node-gyp
