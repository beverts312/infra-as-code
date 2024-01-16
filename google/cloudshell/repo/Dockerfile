FROM gcr.io/cloudshell-images/cloudshell:latest

COPY myconfig .myconfig

RUN git clone https://github.com/beverts312/dev-env.git &&\
    echo "source ${HOME}/.myconfig" >> ~/.bashrc
