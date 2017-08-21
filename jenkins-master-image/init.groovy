import jenkins.model.*
import hudson.model.*
import hudson.security.*

def getMandatoryParameter(String parameterName) {
  def env = System.getenv()
  def value = env[parameterName]
  if(value == null || value.equals("")){
    println "[ERROR] Mandatory parameter ${parameterName} not found in environment variables. Killing Jenkins instance... Bye"
    System.exit(1)
  }
  return value
}

def jenkinsUrl = getMandatoryParameter('jenkins_url')
def adminUsername = getMandatoryParameter('admin_username')
def adminPassword = getMandatoryParameter('admin_password')
def adminEmail = getMandatoryParameter('admin_email')
def numExecutors = getMandatoryParameter('master_numexecutors')

// master setup
Jenkins.instance.setNumExecutors(Integer.parseInt(numExecutors))
Jenkins.instance.setMode(Node.Mode.EXCLUSIVE)
jlc = JenkinsLocationConfiguration.get()
jlc.setUrl(jenkinsUrl)
jlc.setAdminAddress(adminEmail)
jlc.save()

// create admin Jenkins account
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount(adminUsername, adminPassword)
Jenkins.instance.setSecurityRealm(hudsonRealm)
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
Jenkins.instance.setAuthorizationStrategy(strategy)

// auto install Maven
def mavenExtension = Jenkins.instance.getExtensionList(hudson.tasks.Maven.DescriptorImpl.class)[0]
def mavenInstallationList = (mavenExtension.installations as List)
mavenInstallationList.add(new hudson.tasks.Maven.MavenInstallation('M3', null, [new hudson.tools.InstallSourceProperty([new hudson.tasks.Maven.MavenInstaller("3.5.0")])]))
mavenExtension.installations = mavenInstallationList
mavenExtension.save()

// TODO - Dynamically manage AWS EC2 Plugin configuration here

Jenkins.instance.save()
