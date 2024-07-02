# Use the official Node.js image
FROM node:18

# Set the working directory
WORKDIR /src

# Copy package.json and package-lock.json
COPY ../package*.json ./

COPY ../src ./src
COPY ../public ./public

COPY .. .

# Install dependencies
RUN npm install

# Expose the port your app runs on
EXPOSE 3000

# Command to run your app using Node.js
CMD ["npm", "run", "start"]