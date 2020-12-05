# Base Image
FROM python:3

# create and set working directory
RUN mkdir /app
COPY Pipfile /app
COPY start /app
COPY django_docker /app
WORKDIR /app

# Add current directory code to working directory

# set default environment variables
ENV PYTHONUNBUFFERED 1
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive


# set project environment variables
# grab these via Python's os.environ
# these are 100% optional here
ENV PORT=8000

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        tzdata \
        python3-pip \
        python3-venv \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# install environment dependencies
RUN pip3 install --upgrade pip 
RUN pip3 install pipenv
# Install project dependencies
RUN pipenv install --skip-lock --system --dev

EXPOSE 8000
#CMD gunicorn django_docker.wsgi:application --bind 0.0.0.0:$PORT
ENTRYPOINT ["./start"]
