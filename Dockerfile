FROM debian:buster-slim

ARG GIT_COMMIT=none
LABEL git_commit=$GIT_COMMIT
ENV OPTION_ROOTDIR /srv
ENV OPTION_APPDIR ${OPTION_ROOTDIR}/app
ENV OPTION_DATA_DIR ${OPTION_ROOTDIR}/data
ENV OPTION_GUNICORN_PORT 8000
ENV OPTION_GUNICORN_WORKERS 1

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y --no-install-recommends install \
        python3 \
        python3-pip \
        xmlsec1 \
        python3-setuptools \
        python3-wheel \
    && apt-get -y autoremove \
    && apt-get -y clean

WORKDIR ${OPTION_APPDIR}

COPY requirements.txt ${OPTION_APPDIR}
RUN pip3 install -r requirements.txt

COPY . ${OPTION_APPDIR}/
RUN pip3 install -e ${OPTION_APPDIR}

COPY docker/attributemaps /opt/satosa/attributemaps
COPY  ./docker/start.sh /start.sh

VOLUME ${OPTION_DATA_DIR}
WORKDIR ${OPTION_DATA_DIR}
EXPOSE ${OPTION_GUNICORN_PORT}
CMD ["/start.sh"]
