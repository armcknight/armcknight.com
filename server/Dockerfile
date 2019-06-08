# from: https://github.com/jsorge/vapor-hello-world/blob/master/Dockerfile
# Build image
FROM swift:4.1 as builder
RUN apt-get -qq update && apt-get -q -y install \
  && rm -r /var/lib/apt/lists/*
WORKDIR /app
COPY . .
RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so /build/lib
RUN swift build -c release && mv `swift build -c release --show-bin-path` /build/bin

# Production image
FROM ubuntu:16.04
RUN apt-get -qq update && apt-get install -y \
  libicu55 libxml2 libbsd0 libcurl3 libatomic1 \
  tzdata \
  && rm -r /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /build/bin/Run .
COPY --from=builder /build/lib/* /usr/lib/
COPY Resources/ ./Resources/
EXPOSE 8080
ENTRYPOINT ./Run serve -e prod -b 0.0.0.0

# from: https://theswiftdev.com/2018/11/15/docker-loves-swift-and-vapor/
# FROM swift
# WORKDIR /app
# ADD . ./
# RUN swift package clean
# RUN swift build -c release
# RUN mkdir /app/bin
# RUN mv `swift build -c release --show-bin-path` /app/bin
# EXPOSE 8080
# ENTRYPOINT ./bin/release/Run serve -e prod -b 0.0.0.0

# from https://iosdevelopers.slack.com/archives/C0G0MMJ69/p1536194798000100
# # Build image
# FROM swift:4.1 as builder
# RUN apt-get -qq update && apt-get -q -y install
# WORKDIR /app
# COPY . .
# RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so /build/lib
# RUN swift build -c release && mv `swift build -c release --show-bin-path` /build/bin
#
# # Production image
# FROM ubuntu:16.04
# ENV ELASTIC_URI='REDACTED'
#
# RUN apt-get -qq update && apt-get install -y \
#   libicu55 libxml2 libbsd0 libcurl3 libatomic1 tzdata \
#   && rm -r /var/lib/apt/lists/*
#
# WORKDIR /app
#
# COPY Public/ ./Public/
# COPY --from=builder /app/catalog.json .
# COPY --from=builder /build/bin/Run .
# COPY --from=builder /build/lib/* /usr/lib/
#
# EXPOSE 8080
# CMD ./Run serve --env production --hostname 0.0.0.0


