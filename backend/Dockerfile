FROM node:20-alpine

WORKDIR /app

# Copy dependency specifications
COPY package*.json ./

# Install production dependencies
RUN npm ci --only=production

# Copy source files
COPY src ./src

# Expose API port
EXPOSE 3000

# Start server
CMD ["node", "src/index.js"]
