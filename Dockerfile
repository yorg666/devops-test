FROM  mhart/alpine-node:12
# Create app directory
WORKDIR /usr/src/app
# Install app dependencies

COPY . .
RUN npm install
COPY . .
EXPOSE 3000

CMD ["npm", "start"]
