tomcat_test Cookbook
====================
This cookbook installs tomcat and deploys a sample html page

Requirements
------------
Java has to be installed for tomcat to be installed successfully

Attributes
----------
* `node['tomcat']['group']` - name of the group which runs tomcat service
* `['tomcat']['group_id']` - group if of the group which runs tomcat service
* `['tomcat']['user']` - username who runs tomcat service
* `['tomcat']['user_id']` - id of the user who runs tomcat service
* `['tomcat']['base_directory']` - base directory where tomcat has to be installed
* `['tomcat']['tomcat_file']` - name of the tomcat tar.gz file
* `['tomcat']['source_url']` - url from where apache-tomcat can be downloaded
* `['tomcat']['instance']` - name of the tomcat instance

Usage
-----
Include default recipe in run_list

License and Authors
-------------------
Authors: Vish Raparthi
