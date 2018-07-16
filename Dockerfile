FROM ubuntu:16.04 

RUN apt-get update && \
	apt-get install -y \
	build-essential \
	software-properties-common && \
	apt-get clean && \
	add-apt-repository ppa:ubuntu-toolchain-r/test && \
	add-apt-repository ppa:alex-p/tesseract-ocr

RUN apt-get update && \
	apt-get upgrade -y && \
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5

RUN apt-get install -y \
	build-essential \
	autoconf \
	automake \
	libtool \
	autoconf-archive \
	pkg-config \
	libpng12-dev \
	libjpeg8-dev \
	libtiff5-dev \
	zlib1g-dev \
	libicu-dev \
	libpango1.0-dev \
	libcairo2-dev \
	wget && \
	apt-get clean

# Install Leptonica from source
RUN wget http://www.leptonica.org/source/leptonica-1.76.0.tar.gz && \
	tar -xvzf leptonica-1.76.0.tar.gz && \
	cd leptonica-1.76.0 && \
	./configure --with-libtiff --with-libpng && \
	make && \
	make install

# Installing Tesseract 3.05.01 from source
RUN wget https://github.com/tesseract-ocr/tesseract/archive/3.05.01.tar.gz && \
    tar -xvzf 3.05.01.tar.gz && \
    cd tesseract-3.05.01 && \
    sed "s?tesseract_LDADD += -lrt?tesseract_LDADD += -lrt -llept?" api/Makefile.am > api/tempMakeFile.am && mv api/tempMakeFile.am api/Makefile.am && \
    ./autogen.sh  &&\
	./configure  &&\
	make  &&\
	make install && \
	ldconfig && \
	mv /usr/local/bin/tesseract /usr/local/bin/tesseract3

#Installing Tesseract 4.0.0 from apt-get mirror
RUN apt-get install -y tesseract-ocr && \
	mv /usr/bin/tesseract /usr/local/bin/tesseract4

