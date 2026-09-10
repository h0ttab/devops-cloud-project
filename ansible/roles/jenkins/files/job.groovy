pipelineJob('install-app') {
    description('App install pipeline')
    
    logRotator {
        numToKeep(5)
        daysToKeep(1)
    }

    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url(System.getenv('APP_SCM_URL'))
                    }
                    branches('main')
                }
            }
            scriptPath('Jenkinsfile')
        }
    }

    queue('install-app')
}