GeoServer will be running in a load balanced environment, automatically created by [Elastic Beanstalk (EB)](https://aws.amazon.com/documentation/elastic-beanstalk/). All instances will use the same [data directory](http://docs.geoserver.org/latest/en/user/datadirectory/index.html) by accessing a shared filesystem ([EFS](https://aws.amazon.com/documentation/efs/)).

Whenever an instance modifies the shared data directory, the other instances need to reload the configuration. To do that, we set a cron job that uses the [REST API](http://docs.geoserver.org/stable/en/user/rest/api/index.html) to [reload](http://docs.geoserver.org/stable/en/user/rest/api/reload.html) the catalog (every 5 minutes by default).

## Create the file system

We can create the empty file system easily either with the [console](https://docs.aws.amazon.com/efs/latest/ug/gs-step-two-create-efs-resources.html) or the [CLI](https://docs.aws.amazon.com/efs/latest/ug/wt1-create-efs-resources.html). Note the **File system ID** since we will be using it later.

> **NOTE**: In case you want to use an existing data directory, you will need to start with an empty one and fill it once the environment has been deployed.

You might need to configure a specific security group allowing **inbound** traffic to the file system so instances are able to use it (see [official doc](https://docs.aws.amazon.com/efs/latest/ug/accessing-fs-create-security-groups.html) for details).

## Create the application version

First, you **must** modify the `.ebextensions/02_storage-efs-mountfilesystem.config` file to set your **File system ID**.

You can change Java options in `.ebextensions/01_env.config`.

You can change how often GeoServer is reloaded in `.ebextensions/03_reload-geoserver-on-change.config`.

You can include any extension you want in a `extensions` directory in the package. You can create it easily with `build_exts_dir.sh -v <version> -t aws/extensions`.

Finally, just create a zip file containing `Dockerrun.aws.json`, `.ebextensions` and `extensions`.

## Create the environment

It is recommended to use at least `t2.small` instances so GeoServer has enough memory.

You **must** set a `GS_ADMIN_PASS` environment variable with the password for `admin` in GeoServer. This is used to reload the catalog via REST when the shared data directory changes.

You **must** set the **Session stickiness** option in the *Load Balancer* options so the user's session for the GeoServer GUI is bound to a specific instance (see [official doc](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-sticky-sessions.html) for details).

You might need to configure a specific security group allowing **outbound** traffic to the file system so instances are able to use it (see [official doc](https://docs.aws.amazon.com/efs/latest/ug/accessing-fs-create-security-groups.html) for details).

You might want to enable the *Load balancing across multiple Availability Zones* option in the *Load Balancer* options in case your instances are created in different Availability Zones.

Then, just create the environment as any other Elastic Beanstalk environment.

## Importing an existing data directory

In case you want to import an existing data directory, wait until the environment has been created, then copy the data directory into the `/efs` directory of any of the instances and wait until the catalog is reloaded on all instances.

## Deploy to a different path than `/geoserver`


In case you want to deploy GeoServer to a different path than `/geoserver`, you will need to:

* Include another volume in `Dockerrun.aws.json`:
```json
{
  "HostDirectory": "/var/app/current/conf",
  "ContainerDirectory": "/usr/local/tomcat/conf/Catalina/localhost"
}
```

* Include a `conf` directory with the configuration for Tomcat. You can see some examples in this repository (`<version>/conf` directories).

* Modify `.ebextensions/03_reload-geoserver-on-change.config` to access the correct REST API endpoint to reload the configuration.