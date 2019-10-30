version=$1
base_image='isspay/ruby:2.5.1'
echo "Building isspay_api:${version} imags."

docker build --build-arg RUBY_VERSION=2.5.1 --build-arg BUNDLER=2.0.2 \ 
             -t ${base_image} -f Dockerfile.build .

docker build --build-arg BASE_IMAGE=${base_image} -t isspay_api:${version} .
