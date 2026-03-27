CF_PROFILE := armcknight
CF_DISTRIBUTION := E6BG42FYZHWB0
CF_FUNCTION := armcknight-com-redirect-to-mcknight-io

.PHONY: init
init:
	which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew bundle ||:

.PHONY: deploy
deploy:
	$(eval ETAG := $(shell aws --profile $(CF_PROFILE) cloudfront describe-function --name $(CF_FUNCTION) --stage DEVELOPMENT --query 'ETag' --output text))
	aws --profile $(CF_PROFILE) cloudfront update-function \
		--name $(CF_FUNCTION) \
		--if-match $(ETAG) \
		--function-config '{"Comment":"301 redirect armcknight.com to mcknight.io preserving path+query","Runtime":"cloudfront-js-2.0"}' \
		--function-code fileb://infra/cloudfront/redirect-to-mcknight-io.js
	$(eval ETAG := $(shell aws --profile $(CF_PROFILE) cloudfront describe-function --name $(CF_FUNCTION) --stage DEVELOPMENT --query 'ETag' --output text))
	aws --profile $(CF_PROFILE) cloudfront publish-function \
		--name $(CF_FUNCTION) \
		--if-match $(ETAG)

.PHONY: status
status:
	aws --profile $(CF_PROFILE) cloudfront get-distribution --id $(CF_DISTRIBUTION) --query 'Distribution.Status' --output text

.PHONY: test
test:
	aws --profile $(CF_PROFILE) cloudfront test-function \
		--name $(CF_FUNCTION) \
		--if-match $$(aws --profile $(CF_PROFILE) cloudfront describe-function --name $(CF_FUNCTION) --stage DEVELOPMENT --query 'ETag' --output text) \
		--stage DEVELOPMENT \
		--event-object "$$(echo '{"version":"1.0","context":{"eventType":"viewer-request"},"viewer":{"ip":"1.2.3.4"},"request":{"method":"GET","uri":"/blog/foo","querystring":{"bar":{"value":"baz"}},"headers":{"host":{"value":"armcknight.com"}}}}' | base64)" \
		--query 'TestResult.{Error:FunctionErrorMessage,Output:FunctionOutput}' --output table
