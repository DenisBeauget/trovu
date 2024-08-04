FROM ghcr.io/cirruslabs/flutter:stable

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    openjdk-17-jdk


ENV ANDROID_SDK_ROOT /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_SDK_ROOT}/tools:${ANDROID_SDK_ROOT}/platform-tools

# Copier les fichiers du projet
WORKDIR /app
COPY . .


RUN flutter pub get
RUN flutter gen-l10n


RUN yes | sdkmanager --licenses

# Construire l'APK
RUN flutter build apk --release --no-tree-shake-icons