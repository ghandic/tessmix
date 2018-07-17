# These links may be useful for production by using alpine:
# https://github.com/jamesbrink/docker-tesseract/blob/master/Dockerfile
# https://github.com/petronetto/alpine-opencv-python/blob/master/Dockerfile

FROM ubuntu:16.04

MAINTAINER Andy Challis <andrewchallis@hotmail.co.uk>

# Install all dependencies
RUN export LEPTONICA_VERSION="1.76.0" && \
	export TESSERACT3_VERSION="3.05.01" && \
	apt-get update && \
	apt-get install -y \
	build-essential \
	software-properties-common && \
	apt-get clean && \
	add-apt-repository ppa:ubuntu-toolchain-r/test && \
	add-apt-repository ppa:alex-p/tesseract-ocr && \
	apt-get update && \
	apt-get upgrade -y && \
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5 && \
	apt-get install -y \
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
	wget \
	# Update locales to utf8
	locales \
	locales-all && \
	locale-gen en_US && \
	locale-gen en_US.UTF-8 && \
	update-locale  && \
	# Clear the cache
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \

	## Install Leptonica from source
	wget http://www.leptonica.org/source/leptonica-${LEPTONICA_VERSION}.tar.gz && \
	tar -xvzf leptonica-${LEPTONICA_VERSION}.tar.gz && \
	cd leptonica-${LEPTONICA_VERSION} && \
	./configure --with-libtiff --with-libpng && \
	make && \
	make install && \
	# Clear the cache
	cd / && \
	rm /leptonica-${LEPTONICA_VERSION}.tar.gz && \
    rm -r /leptonica-${LEPTONICA_VERSION} && \

	## Installing Tesseract 3.05.01 from source
	wget https://github.com/tesseract-ocr/tesseract/archive/${TESSERACT3_VERSION}.tar.gz && \
    tar -xvzf ${TESSERACT3_VERSION}.tar.gz && \
    cd tesseract-${TESSERACT3_VERSION} && \
    # This is needed on 3.05.01 as there is a bug
    sed "s?tesseract_LDADD += -lrt?tesseract_LDADD += -lrt -llept?" api/Makefile.am > api/tempMakeFile.am && mv api/tempMakeFile.am api/Makefile.am && \
    ./autogen.sh  &&\
	./configure  &&\
	make  && \
	make install && \
	ldconfig && \
	# Move binary to tesseract3
	mv /usr/local/bin/tesseract /usr/local/bin/tesseract3 && \
	# Clear the cache
	cd / && \
	rm /${TESSERACT3_VERSION}.tar.gz && \
    rm -r /tesseract-${TESSERACT3_VERSION} && \

	## Installing Tesseract 4.0.0 from apt-get mirror
	apt-get update && \
	apt-get install -y tesseract-ocr && \
	# Move binary to tesseract4
	mv /usr/bin/tesseract /usr/local/bin/tesseract4 && \
	# Clear the cache
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    wget https://github.com/tesseract-ocr/tessdata/raw/master/eng.traineddata && \
    mv -v eng.traineddata /usr/local/share/tessdata/

