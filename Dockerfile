
FROM python:3.4-slim

RUN apt-get -y update && \
    apt-get install -y --fix-missing \
    build-essential \
    cmake \
    gfortran \
    git \
    wget \
    curl \
    graphicsmagick \
    libgraphicsmagick1-dev \
    libatlas-dev \
    libavcodec-dev \
    libavformat-dev \
    libboost-all-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    pkg-config \
    python3-dev \
    python3-numpy \
    software-properties-common \
    zip \
    && apt-get clean && rm -rf /tmp/* /var/tmp/*


# Install DLIB
RUN cd ~ && \
    mkdir -p dlib && \
    git clone -b 'v19.4' --single-branch https://github.com/davisking/dlib.git dlib/ 
    
# Copy updated makefile
COPY CMakeLists.txt ~/dlib/tools/python/CMakeLists.txt
    
RUN cd ~ && \
    cd dlib/ && \
    python3 setup.py install 
    #--yes USE_AVX_INSTRUCTIONS


# Install Flask
RUN cd ~ && \
    pip3 install flask


# Install Face-Recognition Python Library
RUN cd ~ && \
    mkdir -p face_recognition && \
    git clone https://github.com/ageitgey/face_recognition.git face_recognition/ && \
    cd face_recognition/ && \
    git checkout tags/v0.1.12 && \
    pip3 install -r requirements.txt && \
    python3 setup.py install


# Copy web service script
COPY facerec_service.py /root/facerec_service.py


# Start the web service
CMD cd /root/ && \
    python3 facerec_service.py
