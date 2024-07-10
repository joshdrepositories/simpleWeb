# Use the official Node.js image
FROM node:18

# Set the working directory
WORKDIR /src

# Copy required project files to the container
COPY ../package*.json ./

COPY ../src ./src
COPY ../public ./public

COPY .. .

# Install  Node.js dependencies
RUN npm install

# Expose the port the app runs on
EXPOSE 3000

# Command to run web app using Node.js
CMD ["npm", "run", "start"]