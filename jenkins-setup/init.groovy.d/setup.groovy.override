// Admin user (password from a mounted secret file) + Pipeline job polling GitHub every minute
import jenkins.model.Jenkins
import hudson.security.*
import hudson.plugins.git.*
import hudson.triggers.SCMTrigger
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition

def j = Jenkins.get()
def realm = new HudsonPrivateSecurityRealm(false)
realm.createAccount('admin', new File('/run/secrets/jenkins_admin_password').text.trim())
j.setSecurityRealm(realm)
def auth = new FullControlOnceLoggedInAuthorizationStrategy()
auth.setAllowAnonymousRead(false)
j.setAuthorizationStrategy(auth)
j.setNumExecutors(1)
j.setSlaveAgentPort(-1)   // no inbound agents: builds run on the controller
j.save()

if (j.getItem('myapp-pipeline') == null) {
  def job = j.createProject(WorkflowJob, 'myapp-pipeline')
  def scm = new GitSCM(GitSCM.createRepoList('https://github.com/KinshukAgarwal/devops-monitoring-vle7.git', null),
                       [new BranchSpec('*/main')], null, null, [])
  job.setDefinition(new CpsScmFlowDefinition(scm, 'Jenkinsfile'))
  job.addTrigger(new SCMTrigger('* * * * *'))   // Poll SCM: GitHub cannot reach the EC2 for webhooks
  job.save()
}
