FROM python:3.6.5-stretch

RUN pip install --upgrade pip && \
    pip install --no-cache-dir pypyr pypyraws pypyrslack && \
    pypyr --version && pypyr magritte;

ENV USER_GROUP pypyruser
RUN groupadd -r ${USER_GROUP} && \
    useradd --no-create-home -g ${USER_GROUP} ${USER_GROUP}

WORKDIR /src/

USER pypyruser

ENTRYPOINT ["pypyr"]
