FROM docker.io/library/alpine:3@sha256:51183f2cfa6320055da30872f211093f9ff1d3cf06f39a0bdb212314c5dc7375 AS base

RUN apk add \
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
