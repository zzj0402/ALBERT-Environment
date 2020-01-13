FROM tensorflow/tensorflow:latest-gpu-py3

ENV TZ=Pacific/Auckland
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

RUN apt-get install -y git-all git-lfs
RUN git lfs install

RUN pip install kaggle --upgrade

# Downloading gcloud package
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

# Installing the package
RUN mkdir -p /usr/local/gcloud \
    && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
    && /usr/local/gcloud/google-cloud-sdk/install.sh

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

RUN apt-get install -y vim

RUN cd /root/ && git clone https://github.com/kamalkraj/ALBERT-TF2.0.git

WORKDIR /root/ALBERT-TF2.0
RUN pip install -r requirements.txt
RUN pip install gdown
RUN gdown --id 1FkrvdQnJR9za9Pv8cuiEXd1EI2hxx31a -O 2base.zip && unzip 2base.zip un rm 2base.zip
RUN python download_glue_data.py --data_dir glue_data --tasks all
