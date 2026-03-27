# armcknight.com

`armcknight.com` and `www.armcknight.com` now 301 redirect to `mcknight.io`, preserving the request path and query string.

## How it works

A [CloudFront Function](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cloudfront-functions.html) runs at the viewer-request stage on the CloudFront distribution (`E6BG42FYZHWB0`). It returns a 301 before the request ever reaches the origin, so no backend is needed.

The function source lives at `infra/cloudfront/redirect-to-mcknight-io.js`.

## Usage

Test the function against a sample event (DEVELOPMENT stage):

    make test

Deploy an updated function to LIVE:

    make deploy

Check distribution deployment status:

    make status
