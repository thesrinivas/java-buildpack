# Encoding: utf-8
# Cloud Foundry Java Buildpack
# Copyright 2013-2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'fileutils'
require 'java_buildpack/component/versioned_dependency_component'
require 'java_buildpack/framework'

module JavaBuildpack
  module Framework

    # Encapsulates the functionality for enabling zero-touch New Relic support.
    class LunaHSM < JavaBuildpack::Component::VersionedDependencyComponent

      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        download_jar
        @droplet.copy_resources
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release
        # @droplet.java_opts
        #   .add_javaagent(@droplet.sandbox + jar_name)
        #   .add_system_property('newrelic.home', @droplet.sandbox)
        #   .add_system_property('newrelic.config.license_key', license_key)
        #   .add_system_property('newrelic.config.app_name', "#{application_name}")
        #   .add_system_property('newrelic.config.log_file_path', logs_dir)
        # @droplet.java_opts.add_system_property('newrelic.enable.java.8', 'true') if @droplet.java_home.java_8_or_later?

        copy_lib
        write_luna_provider
        write_certificates
      end

      protected

      # (see JavaBuildpack::Component::VersionedDependencyComponent#supports?)
      def supports?
        @application.services.one_service? FILTER, 'private_key', 'public_key', 'host'
      end

      private

      FILTER = /luna/.freeze

      private_constant :FILTER

      def application_name
        @application.details['application_name']
      end

      def copy_lib

      end

      def host
        @application.services.find_service(FILTER)['credentials']['host']
      end

      def private_key
        @application.services.find_service(FILTER)['credentials']['private_key']
      end

      def public_key
        @application.services.find_service(FILTER)['credentials']['public_key']
      end

      def write_certificates
        #original location - /usr/safenet/lunaclient/cert/client
      end

      def write_luna_provider
      #    security.provider.10=com.safenetinc.luna.provider.LunaProvider
      #   to $JAVA_HOME/jre/lib/security/java.security
      end

    end

  end
end
