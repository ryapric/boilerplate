FROM python:3.7-buster

RUN git clone --depth 1 https://github.com/ryapric/fredcast.git
WORKDIR /fredcast

RUN pip3 install -r requirements.txt \
    && rm -rf $HOME/.cache/pip

EXPOSE 8080

CMD ["python3", "main.py"]
