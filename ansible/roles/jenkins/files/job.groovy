pipelineJob('install-app') {
    description('App install pipeline')
    
    logRotator {
        numToKeep(5)
        daysToKeep(1)
    }
    
    parameters {
        stringParam('APP_VERSION', '1.0', 'App version')
        stringParam('APP_PLATFORM', 'linux/amd64', 'App image platform')
        stringParam('APP_DIR_NAME', 'shareit', 'Application data directory name')
    }

    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/h0ttab/shareit')
                    }
                    branches('main')
                }
            }
            scriptPath('Jenkinsfile')
        }
    }
}