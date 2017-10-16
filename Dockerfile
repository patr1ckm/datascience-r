FROM rocker/verse:3.4.1

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y --no-install-recommends && \
    apt-get install -y --no-install-recommends \
        curl \
        git \
        wget \
        fonts-dejavu \
        gfortran \
        python-dev \
        gcc &&  \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./requirements-python.txt /requirements-python.txt
RUN curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    pip install --upgrade pip setuptools && \
    rm -rf ~/.cache/pip && \
    rm -f get-pip.py


COPY ./setup.R /setup.R
RUN Rscript setup.R


COPY ./requirements.txt /requirements.txt
RUN Rscript -e "packages <- readLines('/requirements.txt'); install.packages(packages)"

EXPOSE 3838

WORKDIR /root/work

ENTRYPOINT ["ping", "google"]