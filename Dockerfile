FROM docker.io/library/alpine:3@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6 AS base

# Upgrade base to fix patched vulnerabilities
RUN apk upgrade --no-cache && \
    apk add --no-cache \
	libxml2-utils=~2.13 \
	xmlstarlet=~1.6 \
	xq=~1.3 \
	;

# Add non-root user
RUN adduser -u 1000 -D -G users -g "xml user" xml
USER 1000:100

# Working directory
WORKDIR /home/xml

# Unobtrusive entrypoint
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["xmlstarlet"]
