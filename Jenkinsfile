#!groovy

/* Set the properties this job has.
   I think there's a bug where the very first run lacks these... */
properties([
  /* Set our config to take a parameter when a build is triggered.
     We should always have defaults, I don't know what happens when
     it's triggered by a commit without a default... */
  [ $class: 'ParametersDefinitionProperty',
    parameterDefinitions: [
      [ $class: 'StringParameterDefinition',
        name: 'SILVER_BASE',
        defaultValue: '/export/scratch/melt-jenkins/custom-silver/',
        description: 'Silver installation path to use. Currently assumes only one build machine. Otherwise a path is not sufficient, we need to copy artifacts or something else.'
      ],
      [ $class: 'StringParameterDefinition',
        name: 'ABLEC_BASE',
        defaultValue: "ableC",
        description: 'AbleC installation path to use.'
      ]
    ]
  ],
  /* If we don't set this, everything is preserved forever.
     We don't bother discarding build logs (because they're small),
     but if this job keeps artifacts, we ask them to only stick around
     for awhile. */
  [ $class: 'BuildDiscarderProperty',
    strategy:
      [ $class: 'LogRotator',
        artifactDaysToKeepStr: '120',
        artifactNumToKeepStr: '20'
      ]
  ]
])

/* If the above syntax confuses you, be sure you've skimmed through
   https://github.com/jenkinsci/pipeline-plugin/blob/master/TUTORIAL.md

   In particular, Jenkins has this thing that turns a map with a '$class' property
   into an actual object of that type, with the remainder of the map being its
   parameters. */

/* a node allocates an executor to actually do work */
node {
  try {
    // notifyBuild('STARTED')

    /* the full path to ableC, use parameter as-is if changed from default,
     * otherwise prepend full path to workspace */
    def ablec_base = (ABLEC_BASE == 'ableC') ? "${WORKSPACE}/${ABLEC_BASE}" : ABLEC_BASE
    def include_grammars = "-I ${ablec_base} -I ${WORKSPACE}/grammars"

    /* stages are pretty much just labels about what's going on */
    stage ("Build") {
      /* don't check out extension under ableC_Home because doing so would allow
       * the Makefiles to find ableC with the included search paths, but we want
       * to explicitly specify the path to ableC according to ABLEC_BASE */
      checkout scm

      checkout([ $class: 'GitSCM',
                 branches: [[name: '*/develop']],
                 doGenerateSubmoduleConfigurations: false,
                 extensions: [
                   [ $class: 'RelativeTargetDirectory',
                     relativeTargetDir: 'ableC']
                 ],
                 submoduleCfg: [],
                 userRemoteConfigs: [
                   [url: 'https://github.com/melt-umn/ableC.git']
                 ]
               ])

      /* env.PATH is the master's path, not the executor's */
      withEnv(["PATH=${SILVER_BASE}/support/bin/:${env.PATH}"]) {
        dir("examples") {
          sh "silver -G ${WORKSPACE} -o ableC.jar ${include_grammars} artifact"
        }
	// sh "make build" - doesn't work
      }
    }
    
    stage ("Examples") {
      withEnv(["PATH=${SILVER_BASE}/support/bin/:${env.PATH}"]) {
        sh "make examples"
      }
    }

    stage ("Modular Analyses") {
      withEnv(["PATH=${SILVER_BASE}/support/bin/:${env.PATH}"]) {
        dir("modular_analyses") {
          sh "silver -G ${WORKSPACE} -o MDA.jar ${include_grammars} --clean determinism"
          sh "silver -G ${WORKSPACE} -o MWDA.jar ${include_grammars} --clean --warn-all --warn-error well_definedness"
        }
	// sh "make analyses"
      }
    }

    stage ("Test") {
      withEnv(["PATH=${SILVER_BASE}/support/bin/:${env.PATH}"]) {
        dir("test") {
          sh "silver -G ${WORKSPACE} -o ableC.jar ${include_grammars} artifact"
          sh "make"
        }
	// sh "make test"
      }
    }
  }
  catch (e) {
    currentBuild.result = 'FAILURE'
    throw e
  }
  finally {
    def previousResult = currentBuild.previousBuild?.result

    if (currentBuild.result == 'FAILURE') {
      notifyBuild(currentBuild.result)
    }
    else if (currentBuild.result == null &&
             previousResult && previousResult == 'FAILURE') {
      notifyBuild('BACK_TO_NORMAL')
    }
  }
}

/* Slack / email notification
 * notifyBuild() author: fahl-design
 * https://bitbucket.org/snippets/fahl-design/koxKe */
def notifyBuild(String buildStatus = 'STARTED') {
  // build status of null means successful
  buildStatus =  buildStatus ?: 'SUCCESSFUL'

  // Default values
  def colorName = 'RED'
  def colorCode = '#FF0000'
  def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
  def summary = "${subject} (${env.BUILD_URL})"
  def details = """<p>STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
    <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>"""

  // Override default values based on build status
  if (buildStatus == 'STARTED') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'SUCCESSFUL' || buildStatus == 'BACK_TO_NORMAL') {
    color = 'GREEN'
    colorCode = '#00FF00'
  } else {
    color = 'RED'
    colorCode = '#FF0000'
  }

  // Send notifications
  slackSend (color: colorCode, message: summary)

  emailext(
    subject: subject,
    body: details,
    to: 'evw@umn.edu',
    recipientProviders: [[$class: 'CulpritsRecipientProvider']]
  )
}

