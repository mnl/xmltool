#!/usr/bin/env sh

case "$1" in
	xmlstarlet|xq|xmllint)
		exec "/usr/bin/$@" ;;
	usage|help)
		cat <<-'EOF'
		xmllint: Parse the XML files and output the result of the parsing
		  Usage: xmllint [options] XMLfiles ...
		xq: Command-line XML and HTML beautifier and content extractor
		  Usage: xq [flags]
		xmlstarlet: XMLStarlet Toolkit: Command line utilities for XML
		  Usage: xmlstarlet [<options>] <command> [<cmd-options>]
		This container:
		  Usage: pipe data to tools or mount files to working dir /home/xml
		  Configured user: uid=1000(xml) gid=100(users) groups=100(users)
		EOF
		exit 0
		;;
	default)
		;;
esac
exec "$@"
