FROM docker.io/library/alpine:3@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS base

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
