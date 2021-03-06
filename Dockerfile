FROM rglutes/kier_transactive_campus:volttron_python3
USER root
RUN apt-get update --fix-missing && apt-get install locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ARG buildings

USER volttron

ARG buildings

ARG volttron_user

USER root

RUN rm -r /home/volttron/volttron/volttron/platform/agent/base_market_agent
COPY volttron-GS/base_market_agent /home/volttron/volttron/volttron/platform/agent/base_market_agent

COPY volttron-GS/TNSAgent /home/volttron/volttron/volttron/TNS_city_Agent

COPY source/citysetup.py /home/volttron/volttron/volttron/TNS_city_Agent/setup.py

COPY volttron-GS/TNSAgent /home/volttron/volttron/volttron/TNS_campus_Agent

COPY source/campussetup.py /home/volttron/volttron/volttron/TNS_campus_Agent/setup.py

COPY volttron-GS/TNSAgent /home/volttron/volttron/volttron/TNS_building_Agent

COPY source/buildingsetup.py /home/volttron/volttron/volttron/TNS_building_Agent/setup.py

COPY volttron-GS/pnnl /home/volttron/volttron/volttron/pnnl

RUN chown volttron.volttron /home/volttron/volttron/volttron/platform/agent -R

USER volttron

RUN /bin/bash -c "source env/bin/activate"

ENV VOLTTRON_HOME=~/.volttron_${buildings}

RUN mkdir /home/volttron/.volttron_${buildings}/

COPY transactivecontrol/MarketAgents/config/${buildings}/keystore /home/volttron/.volttron_${buildings}/

COPY transactivecontrol/MarketAgents/config/${buildings}/config /home/volttron/.volttron_${buildings}/

COPY transactivecontrol/MarketAgents/config/${buildings}/auth.json /home/volttron/.volttron_${buildings}/

COPY /source/eplus /home/volttron/volttron/eplus

USER root

RUN chown volttron.volttron /home/volttron/.volttron_${buildings}/keystore

RUN chown volttron.volttron /home/volttron/.volttron_${buildings}/config

RUN chown volttron.volttron /home/volttron/.volttron_${buildings}/auth.json

RUN chown volttron.volttron /home/volttron/volttron/eplus -R

WORKDIR /home/volttron/volttron/

USER volttron