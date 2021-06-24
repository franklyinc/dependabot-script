FROM dependabot/dependabot-core:local

ARG CODE_DIR=/home/dependabot/dependabot-script
RUN mkdir -p ${CODE_DIR}
COPY --chown=dependabot:dependabot Gemfile Gemfile.lock ${CODE_DIR}/
WORKDIR ${CODE_DIR}

RUN cd /home/dependabot/dependabot-core/omnibus && bundle install && cd /home/dependabot/dependabot-script
RUN bundle install --jobs 4 --retry 3
RUN mkdir -p /home/dependabot/.bundle/ruby/2.6.0/gems/dependabot-common-0.151.1/lib/dependabot/
RUN cp -a /home/dependabot/dependabot-core/common/lib/dependabot/. /home/dependabot/.bundle/gems/dependabot-common-0.151.1/lib/dependabot/

COPY --chown=dependabot:dependabot . ${CODE_DIR}

CMD ["bundle", "exec", "ruby", "./generic-update-script.rb"]
#CMD tail -f /dev/null