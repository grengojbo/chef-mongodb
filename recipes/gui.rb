#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2011, edelight GmbH
# Authors:
#       Markus Korn <markus.korn@edelight.de>
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

case node['platform']
  when "debian", "ubuntu"
    package "mongodb" do
      action :install
    end
  when "redhat","oracle","centos","fedora","suse", "amazon", "scientific"
    #  perl-MongoDB pymongo python-asyncmongo
    # wget https://github.com/downloads/Imaginea/mViewer/mViewer-v0.9.1.tar.gz
    # cd /opt/mongo_gui/ && ./start_mViewer.sh <port>
    package "mongo-10gen" do
      action :update
      #source "/var/tmp/#{rpm_file}"
      #options "--nogpgcheck"
    end
end

