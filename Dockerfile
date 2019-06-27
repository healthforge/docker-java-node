FROM openjdk:8-jdk

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y nodejs yarn ruby2.3 ruby2.3-dev build-essential locales locales-all && \
    apt-get install -y --no-install-recommends libstdc++6:i386 libc6:i386 libncurses5:i386 zlib1g:i386
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
RUN gem install bundler

# Download and install Android
ARG ANDROID_TOOLS_URL=https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
ENV ANDROID_HOME=/opt/android
RUN mkdir $ANDROID_HOME
WORKDIR $ANDROID_HOME
RUN curl --silent $ANDROID_TOOLS_URL > android.zip
RUN unzip android.zip
RUN rm android.zip
RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager \
    "build-tools;28.0.3" \
    "build-tools;26.0.3" \
    "build-tools;23.0.3" \
    "platforms;android-23" \
    "platforms;android-26" \
    "platforms;android-28" \
    "platform-tools"
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Link adb executable
RUN ln -s /opt/android/platform-tools/adb /usr/bin/adb

