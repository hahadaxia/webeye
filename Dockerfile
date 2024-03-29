FROM python:3.6
LABEL MAINTAINER=hahadaxia
ENV TZ=Asia/Shanghai
#EXPOSE 5000
RUN apt-get update
RUN apt-get install --no-install-recommends -y curl gnupg git  supervisor software-properties-common wget
RUN curl https://openresty.org/package/pubkey.gpg | apt-key add -
RUN add-apt-repository -y "deb http://openresty.org/package/debian $(lsb_release -sc) openresty"
RUN apt-get update

RUN apt-get install -y openresty
COPY ./deploy /webeye/deploy
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r /webeye/deploy/requirements.txt -U
RUN cp /webeye/deploy/nginx/*.conf /usr/local/openresty/nginx/conf/
RUN cp /webeye/deploy/supervisor/*.conf /etc/supervisor/conf.d/

COPY ./static /webeye/static
COPY ./templates /webeye/templates
COPY ./_Rules.db /webeye/_Rules.db
COPY ./Rules.db  /webeye/Rules.db
COPY ./config.ini  /webeye/config.ini
COPY ./database.py  /webeye/database.py
COPY ./fingerprint.py  /webeye/fingerprint.py
COPY ./app.py /webeye/app.py
WORKDIR /webeye
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]