#
# Cookbook Name:: mongodb
# Recipe:: 10gen_repo
#
# Copyright 2011, edelight GmbH
# Authors:
#       Miquel Torres <miquel.torres@edelight.de>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Sets up the repositories for stable 10gen packages found here:
# http://www.mongodb.org/downloads#packages

case node['platform']
  when "debian", "ubuntu"
    # Adds the repo: http://www.mongodb.org/display/DOCS/Ubuntu+and+Debian+packages
    execute "apt-get update" do
      action :nothing
    end

    apt_repository "10gen" do
      uri "http://downloads-distro.mongodb.org/repo/debian-sysvinit"
      distribution "dist"
      components ["10gen"]
      keyserver "keyserver.ubuntu.com"
      key "7F0CEB10"
      action :add
     notifies :run, "execute[apt-get update]", :immediately
    end

    package "mongodb" do
      package_name "mongodb-10gen"
    end
  when "redhat","oracle","centos","fedora","suse", "amazon", "scientific"
      arch = node["kernel"]["machine"]
      arch = "i386" unless arch == "x86_64"
      #http://docs.mongodb.org/manual/tutorial/install-mongodb-on-redhat-centos-or-fedora-linux/

      execute "yum -q makecache" do
        action :nothing
      end

      ruby_block("reload-yum-cache") do
        block do
          Chef::Provider::Package::Yum::YumCache.instance.reload
        end
      end

      template "/etc/yum.repos.d/10gen.repo" do
        mode "0644"
        source "10gen.repo.erb"
        notifies :run, resources(:execute => "yum -q makecache"), :immediately
        notifies :create, resources('ruby_block[reload-yum-cache]'), :immediately
        not_if { ::FileTest.exists?("/etc/yum.repos.d/10gen.repo") }
      end

      #package "mongo-10gen mongo-10gen-server" do
      #  source "/var/tmp/#{rpm_file}"
      #  options "--nogpgcheck"
      #end
else
    Chef::Log.warn("Adding the #{node['platform']} 10gen repository is not yet not supported by this cookbook")
end
