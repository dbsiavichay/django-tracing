FROM ubuntu:20.04

ENV PYTHONUNBUFFERED 1

ENV APP_ROOT /app

RUN apt update --fix-missing -y && \
    apt install -y git

# Locale
ARG DEBIAN_FRONTEND=noninteractive
RUN apt install --fix-missing -y locales \
    && sed -i -e 's/# es_EC.UTF-8 UTF-8/es_EC.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=es_EC.UTF-8

ENV LANG es_EC.UTF-8
ENV LC_ALL es_EC.UTF-8

ARG DEBIAN_FRONTEND=noninteractive
RUN apt install --fix-missing -y build-essential software-properties-common apt-utils \
    python3-dev python3-pip python3-setuptools python3-venv python3-wheel python3-cffi python3-brotli

COPY . ${APP_ROOT}/

WORKDIR ${APP_ROOT}
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
RUN pip3 install -r requirements.txt
RUN pip3 install flake8 isort pymakefile black==20.8b1
RUN pip3 install build twine

CMD ["python3", "-m", "build"]
