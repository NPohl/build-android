FROM ubuntu:19.04

ARG android_api=21
ARG android_build_tools_version=28.0.3

ARG android_ndk_version=r19c
ARG android_sdk_tools_version=4333796

LABEL description="Ubunutu based android build image. API=${android_api} ndk=${android_ndk_version} build-tools=${android_build_tools_version} sdk-tools=${android_sdk_tools_version}"

ENV ANDROID_SDK_ROOT /opt/android-sdk
ENV ANDROID_NDK /opt/android-ndk
ENV ANDROID_HOME $ANDROID_SDK_ROOT
ENV PATH $PATH:$ANDROID_SDK_ROOT/tools/bin

# Basic tools
RUN apt-get update \
    && apt-get install -y \    
    # requirements to build docker image
    unzip \
    wget \
    # basic build requirements
    cmake \
    # requirements for Android SDK
    openjdk-8-jre

# Android NDK
RUN wget --quiet https://dl.google.com/android/repository/android-ndk-${android_ndk_version}-linux-x86_64.zip -O /tmp/android-ndk.zip \
    && mkdir -p $ANDROID_NDK \
    && unzip -q /tmp/android-ndk.zip -d $ANDROID_NDK \
    && mv $ANDROID_NDK/android-ndk-${android_ndk_version}/* $ANDROID_NDK/ \
    && rmdir $ANDROID_NDK/android-ndk-${android_ndk_version} \
    && rm -v /tmp/android-ndk.zip    

# Android SDK tools
RUN wget --quiet https://dl.google.com/android/repository/sdk-tools-linux-${android_sdk_tools_version}.zip -O /tmp/android-sdk-tools.zip \
    && mkdir -p $ANDROID_SDK_ROOT \
    && unzip -q /tmp/android-sdk-tools.zip -d $ANDROID_SDK_ROOT \
    && rm -v /tmp/android-sdk-tools.zip

# Android build-tools and platform
RUN yes | sdkmanager \
        "build-tools;${android_build_tools_version}" \
        "platforms;android-${android_api}" > dev/null \
    # delete things to save space
    && rm -rf  \
        $ANDROID_SDK_ROOT/tools/proguard/examples \
        $ANDROID_SDK_ROOT/tools/proguard/docs