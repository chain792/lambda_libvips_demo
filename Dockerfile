FROM amazon/aws-lambda-ruby:latest

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

RUN yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm

RUN yum install -y install vips make gcc

COPY Gemfile Gemfile.lock ${LAMBDA_TASK_ROOT}

COPY lambda_function.rb ${LAMBDA_TASK_ROOT}

ENV GEM_HOME=/usr/local/bundle

RUN bundle install

CMD [ "lambda_function.lambda_handler" ]
