require "refile/backend/s3"

aws = {
  access_key_id: ENV["S3_KEY"],
  secret_access_key: ENV["S3_SECRET_KEY"],
  bucket: ENV["S3_BUCKET"],
}

Refile.host = "//d3qsrkjdadnces.cloudfront.net"
Refile.cache = Refile::Backend::S3.new(prefix: "cache", **aws)
Refile.store = Refile::Backend::S3.new(prefix: "store", **aws)
