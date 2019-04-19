FROM openjdk:8-jdk
MAINTAINER Developer GBKSoft <devgbksoft@gmail.com>
RUN dpkg --add-architecture i386 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update && \
    apt-get install -yq libc6:i386 libstdc++6:i386 zlib1g:i386 libncurses5:i386 libqt5widgets5 build-essential libssl-dev lib32z1 --no-install-recommends && \
    apt-get clean


# Download and unzip Android SDK tools with SDK manager (here used 26.0.2, https://dl.google.com/android/repository/repository2-1.xml)
RUN mkdir -p /usr/local/android-sdk-linux
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
     unzip -qq -o android-sdk.zip -d /usr/local/android-sdk-linux
RUN rm android-sdk.zip

# Set environment variable
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH
ENV PATH=$PATH:/opt/gradle/gradle-5.1.1/bin
ENV ANDROID_TARGET_SDK="28" \
    ANDROID_BUILD_TOOLS="28.0.3" \
    ANDROID_COMPILE_SDK="28" \
    ANDROID_PLATFORM_TOOLS="28"

# Update and install using sdkmanager
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}"
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "platform-tools" "platforms;android-${ANDROID_PLATFORM_TOOLS}"
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}"
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "extras;google;google_play_services"
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "extras;google;m2repository"
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "extras;android;m2repository"

#RUN rm android-emulator.zip
ADD android-wait-for-emulator.sh $ANDROID_HOME/ci/
ADD stop-emulators.sh $ANDROID_HOME/ci/

#download gradle
RUN wget --quiet --output-document=gradle-5.1.1-bin.zip https://services.gradle.org/distributions/gradle-5.1.1-bin.zip
RUN mkdir /opt/gradle
RUN unzip -d /opt/gradle gradle-5.1.1-bin.zip
RUN rm gradle-5.1.1-bin.zip