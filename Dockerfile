FROM docker.io/library/alpine:3@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62 AS base

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
