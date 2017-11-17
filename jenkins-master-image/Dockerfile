FROM jenkins/jenkins:2.73.3-alpine

RUN /usr/local/bin/install-plugins.sh \
	workflow-aggregator:2.5 \
	pipeline-stage-view:2.9 \
	workflow-multibranch:2.16 \
	pipeline-utility-steps:1.5.1 \
	pipeline-model-definition:1.2.4 \
	pipeline-maven:3.0.3 \
	blueocean:1.3.3 \
	github-branch-source:2.3.1 \
	cloudbees-bitbucket-branch-source:2.2.7 \
	ec2:1.37 \
	buildtriggerbadge:2.8.1 \
	ssh-agent:1.15

COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/init.groovy

ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false"
