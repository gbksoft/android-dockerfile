# Docker file for android building android apps and CI integration

Docker file contains all needed actions to setup android sdk for building apps.
You can compose this image, and use it straight away.

## Gradle versioning

You may need to change lines 
```
RUN wget --quiet --output-document=gradle-5.4.1-bin.zip https://services.gradle.org/distributions/gradle-5.4.1-bin.zip
RUN mkdir /opt/gradle
RUN unzip -d /opt/gradle gradle-5.4.1-bin.zip
RUN rm gradle-5.4.1-bin.zip
```  
to latest gradle versions, you can obtain them here
`https://services.gradle.org/distributions/`

Don't forget to update your CI files respectively  