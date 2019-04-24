FROM centos:7
MAINTAINER john123951 "john123951@126.com"

ENV TEMP_PATH=/temp

# install dependences
RUN yum install -y wget unzip make gcc perl && yum clean all

# create directory
RUN mkdir ${TEMP_PATH} -p && \
    mkdir /var/fastdfs && \
    mkdir /data/fastdfs -p

# download zip
WORKDIR ${TEMP_PATH}
RUN wget https://github.com/happyfish100/libfastcommon/archive/master.zip -O fastcommon.zip
RUN wget https://github.com/happyfish100/fastdfs/archive/master.zip -O fastdfs.zip

RUN unzip fastcommon.zip && unzip fastdfs.zip

# compile & install libfastcommon
WORKDIR ${TEMP_PATH}/libfastcommon-master
RUN ./make.sh && ./make.sh install
RUN ln -s /usr/lib64/libfastcommon.so /usr/local/lib/libfastcommon.so
RUN ln -s /usr/lib64/libfdfsclient.so /usr/local/lib/libfdfsclient.so

# compile & install fastdfs
WORKDIR ${TEMP_PATH}/fastdfs-master
RUN ./make.sh && ./make.sh install

EXPOSE 23000

CMD ["/bin/bash", "-c", "fdfs_storaged /etc/fdfs/storage.conf start && sleep 5 && tail -F --pid=`cat /var/fastdfs/data/fdfs_storaged.pid` /dev/null"]


