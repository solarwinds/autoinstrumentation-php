variable "BUILD_ID" {
  default = "local"
}

target "_build-base" {
  target = "artifact"
}

target "final-ci" {
  inherits = ["final"]
  contexts = {
    build-non-zts-81      = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-non-zts-81"
    build-zts-81          = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-zts-81"
    build-non-zts-musl-81 = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-non-zts-musl-81"
    build-zts-musl-81     = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-zts-musl-81"
    build-non-zts-82      = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-non-zts-82"
    build-zts-82          = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-zts-82"
    build-non-zts-musl-82 = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-non-zts-musl-82"
    build-zts-musl-82     = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-zts-musl-82"
    build-non-zts-83      = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-non-zts-83"
    build-zts-83          = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-zts-83"
    build-non-zts-musl-83 = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-non-zts-musl-83"
    build-zts-musl-83     = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-zts-musl-83"
    build-non-zts-84      = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-non-zts-84"
    build-zts-84          = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-zts-84"
    build-non-zts-musl-84 = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-non-zts-musl-84"
    build-zts-musl-84     = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-zts-musl-84"
    build-non-zts-85      = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-non-zts-85"
    build-zts-85          = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-zts-85"
    build-non-zts-musl-85 = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-non-zts-musl-85"
    build-zts-musl-85     = "docker-image://${IMAGE_NAME}-build:${TAG}-${BUILD_ID}-build-zts-musl-85"
  }
}
