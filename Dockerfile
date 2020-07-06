FROM debian:stretch

# build variables
ARG SBCL_VERSION=1.5.4
ARG SBCL_URL=https://prdownloads.sourceforge.net/sbcl/sbcl-${SBCL_VERSION}-source.tar.bz2
ARG QUICKLISP_VERSION=2020-02-18
ARG QUICKLISP_URL=http://beta.quicklisp.org/dist/quicklisp/${QUICKLISP_VERSION}/distinfo.txt

# install required debian packages
RUN apt-get update -y && \
    apt-get install -y \
    # used to install sbcl and quicklisp
    build-essential \
    curl \
    # used in downstream images (rpcq, quilc, qvm)
    cmake \
    git \
    libblas-dev \
    libffi-dev \
    liblapack-dev \
    libz-dev \
    libzmq3-dev \
    python3 \
    python3-pip \
    unzip \
    parallel \
    # used in the Dockerfile CMD
    rlwrap \
    # used to install sbcl and quicklisp
    sbcl && \	
    apt-get clean 

# install sbcl (requirements: build-essential, curl, libz-dev, sbcl)
WORKDIR /src
RUN curl -LO ${SBCL_URL} && \
    tar -xf sbcl-${SBCL_VERSION}-source.tar.bz2 && \
    rm /src/sbcl-${SBCL_VERSION}-source.tar.bz2 && \
    cd /src/sbcl-${SBCL_VERSION} && \
    ln -s /src/sbcl-${SBCL_VERSION} /src/sbcl && \
    bash make.sh --fancy --with-sb-dynamic-core --with-sb-linkable-runtime && \
    (cd src/runtime && make libsbcl.a) && \
    bash install.sh && \
    cd -



# install quicklisp (requirements: curl, sbcl)
RUN curl -o /tmp/quicklisp.lisp 'https://beta.quicklisp.org/quicklisp.lisp' && \
    sbcl --noinform --non-interactive --load /tmp/quicklisp.lisp --eval \
        "(quicklisp-quickstart:install :dist-url \"${QUICKLISP_URL}\")" && \
    sbcl --noinform --non-interactive --load ~/quicklisp/setup.lisp --eval \
        '(ql-util:without-prompting (ql:add-to-init-file))' && \
    echo '#+quicklisp(push "/src" ql:*local-project-directories*)' >> ~/.sbclrc && \
    rm -f /tmp/quicklisp.lisp

# quickload libraries
ADD . /src/docker-lisp
WORKDIR /src/docker-lisp
RUN sbcl --load "quantumlisp.lisp" --eval '(ql:quickload (uiop:read-file-lines "quicklisp-libraries.txt"))' --quit

# install Python packages
RUN pip3 install pandas numpy seaborn matplotlib

WORKDIR /

# clone experiment
RUN git clone https://github.com/theodrosmhaile/RLWM_ACTR.git

# install actr and modify dispatcher and set-up port files
RUN curl -LO http://act-r.psy.cmu.edu/actr7.x/actr7.x.zip
RUN unzip /actr7.x.zip
RUN rm /actr7.x/framework/dispatcher.lisp

RUN cp /RLWM_ACTR/act-r* /root/
RUN cp /RLWM_ACTR/port_change_actr/dispatcher.lisp  /actr7.x/framework/


# rlwm actr set-up and start
#COPY ./rlwm_actr /rlwm_actr
#RUN sbcl --noinform --non-interactive --load "/actr7.x/load-act-r.lisp"


# install ClosureCL (it maybe better than sbcl)
RUN curl -L -o /usr/local/src/ccl.tar.gz https://github.com/Clozure/ccl/releases/download/v1.11.5/ccl-1.11.5-linuxx86.tar.gz 
WORKDIR /usr/local/src
RUN  tar -xf ccl.tar.gz 
RUN  rm /usr/local/src/ccl.tar.gz


RUN PATH=$PATH:/usr/local/src/ccl/scripts
WORKDIR /



#COPY ./dispatcher.lisp /actr7.x/framework 

EXPOSE 2650
#initiate experiment
 

# enter into an SBCL REPL (requirements: rlwrap, sbcl)
#CMD sleep 0.05; rlwrap sbcl




