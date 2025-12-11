# XML Tool image
Container image for working with XML. Includes:
- [xmllint](https://gitlab.gnome.org/GNOME/libxml2) XML tool from libxml2
- [xmlstarlet](https://xmlstar.sourceforge.net/) Command Line XML Toolkit
- [xq](https://github.com/sibprogrammer/xq) Command-line XML and HTML beautifier and content extractor

## Usage:
Run in a pipeline to extract content:
```bash
$ curl --silent https://www.w3schools.com/xml/simple.xml | \
    podman run --rm -i ghcr.io/mnl/xmltool \
    xmlstarlet sel -t -m "//food[contains(name, 'Strawberry')]" -v name -n
Strawberry Belgian Waffles
$
```

Extract attribute value with xq:
```bash
$ curl -s example.com | \
    podman run --rm -i ghcr.io/mnl/xmltool \
    xq -x '//p/p/a/@href'
https://iana.org/domains/example
$
```

Lint XML with xmllint:
```bash
$ echo '<foo></foo>' | podman run --rm -i ghcr.io/mnl/xmltool \
    xmllint -
<?xml version="1.0"?>
<foo/>
$
```

You can also mount files to the container and do in place edits:
```bash
$ podman run --rm --user 0:0 \
    -v $XDG_DATA_HOME/recently-used.xbel:/home/xml/f.xml:rw,z \
    ghcr.io/mnl/xmltool \
    xmlstarlet ed -L -d '/xbel/bookmark[contains(@href,"Download")]' f.xml
$
```
Here I'm removing "Download" from GNOME's recently-used file list.
_As I run rootless `--user 0:0` is needed for podman to write as my user.
SELinux requires the `z` mount option to prevent label mismatch_

## Packaging
Run `podman run --rm ghcr.io/mnl/xmltool usage` for more info.

## Security
Published images are signed. Verify with [cosign](https://docs.sigstore.dev/cosign/verifying/verify/#keyless-verification-using-openid-connect):
```bash
cosign verify \
  --certificate-identity-regexp 'https://github\.com/mnl/xmltool/.*' \
  --certificate-oidc-issuer-regexp 'https://token.actions.githubusercontent.com' \
  --output text ghcr.io/mnl/xmltool
```
