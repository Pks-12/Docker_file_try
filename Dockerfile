# FROM nginx:latest

# COPY protfolio /usr/share/nginx/html

# Create a new build stage from a base image
FROM python:3.9

# Specify the author of the image
LABEL maintainer="Pawan Kumar Singh <singhpk120901@gmail.com>"

# Set build-time variables
ARG APP_HOME=/app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Change the working directory
WORKDIR $APP_HOME

# Add metadata to the image
LABEL description="A simple Flask web application"

# Copy files and directories from the local filesystem to the container
COPY . $APP_HOME

COPY schema.sql $APP_HOME/schema.sql

# Add remote files and directories (for example, download a file)
# ADD https://raw.githubusercontent.com/pallets/flask/main/examples/tutorial/flaskr/flaskr/schema.sql $APP_HOME/schema.sql
# Add remote files and directories (for example, download a file)
ADD https://raw.githubusercontent.com/pallets/flask/main/examples/tutorial/flaskr/flaskr/schema.sql /app/schema.sql

# Execute build commands
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Set the default shell for the container
SHELL ["/bin/bash", "-c"]

# Describe which ports your application is listening on
EXPOSE 5000

# Create volume mounts
VOLUME ["/data"]

# Specify the system call signal for exiting the container
STOPSIGNAL SIGTERM

# Check a container's health on startup
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail http://localhost:5000/health || exit 1

# Specify default commands
CMD ["flask", "run", "--host=0.0.0.0"]

# Specify default executable
ENTRYPOINT ["python", "app.py"]

# Set user and group ID
USER root

# Specify instructions for when the image is used in a build
ONBUILD RUN echo "This will run when the image is used as a base for another build"

