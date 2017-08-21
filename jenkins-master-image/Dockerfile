FROM jenkins/jenkins:2.60.3-alpine

RUN /usr/local/bin/install-plugins.sh \
	workflow-aggregator:2.5 \
	pipeline-stage-view:2.8 \
	workflow-multibranch:2.16 \
	pipeline-utility-steps:1.4.0 \
	pipeline-model-definition:1.1.9 \
	pipeline-maven:2.5.2 \
	blueocean:1.1.7 \
	github-branch-source:2.2.3 \
	cloudbees-bitbucket-branch-source:2.2.3 \
	ec2:1.36 \
	buildtriggerbadge:2.8.1 \
	ssh-agent:1.15

COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/init.groovy

ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false"
