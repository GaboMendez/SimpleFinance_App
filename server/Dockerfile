# Use Node.js official LTS image
FROM node:18

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the application code
COPY . .

# Expose the port the server listens on
EXPOSE 3000

# Start the server
CMD ["node", "server.js"]
