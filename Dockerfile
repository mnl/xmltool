FROM docker.io/library/alpine:3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS base

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
