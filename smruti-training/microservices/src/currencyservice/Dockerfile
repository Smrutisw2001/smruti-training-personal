FROM alpine:3.18 as builder

# Install build dependencies
RUN apk update && apk add git cmake make g++ grpc-dev protobuf-dev linux-headers

# Set OpenTelemetry C++ version as an argument
ARG OPENTELEMETRY_CPP_VERSION=1.13.0

# Clone and build OpenTelemetry C++ SDK
RUN git clone https://github.com/open-telemetry/opentelemetry-cpp \
    && cd opentelemetry-cpp/ \
    && git checkout tags/v${OPENTELEMETRY_CPP_VERSION} -b v${OPENTELEMETRY_CPP_VERSION} \
    && mkdir build \
    && cd build \
    && cmake .. -DCMAKE_CXX_STANDARD=17 -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
          -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF \
          -DWITH_EXAMPLES=OFF -DWITH_OTLP_GRPC=ON -DWITH_ABSEIL=ON \
    && make -j$(nproc || sysctl -n hw.ncpu || echo 1) install \
    && cd ../..

# Copy the currencyservice source code into the container
COPY ./src/currencyservice /currencyservice

# Build the currencyservice application
RUN cd /currencyservice \
    && mkdir -p build && cd build \
    && cmake .. \
    && make -j$(nproc || sysctl -n hw.ncpu || echo 1) install

# Release image
FROM alpine:3.18 as release

# Install runtime dependencies
RUN apk update && apk add grpc-dev protobuf-dev

# Copy the OpenTelemetry and currencyservice installation
COPY --from=builder /usr/local /usr/local

# Set default port if not set
ENV CURRENCY_SERVICE_PORT=50051

# Expose the service port
EXPOSE ${CURRENCY_SERVICE_PORT}

# Use absolute path for entrypoint
ENTRYPOINT ["/usr/local/bin/currencyservice", "${CURRENCY_SERVICE_PORT}"]
