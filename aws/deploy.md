Deploy to AWS
============

Deploy to AWS using [Elastic Beanstalk (EB)](https://aws.amazon.com/documentation/elastic-beanstalk/).

## Architecture

GeoServer will be running in a single instance, automatically created by EB. That instance will use two volumes:

* A root volume where the operating system will run. This is automatically created by EB.
* A volume holding the GeoServer data directory . This is created automatically by EB from an existing snapshot.

The volume holding the GeoServer data directory can be destroyed at any point (for rebuilding the environment, switch to a more powerful instance, etc.). Make sure you create snapshots **very** often.

The volume holding the GeoServer data directory will be mounted on the host instance on startup/creation. Then, that volume should be used as a volume for the Docker container.

The process consists in three steps:
* Create a first snapshot by hand.
* Create an EB package specifying the latest snapshot and some volume configuration parameters.
* Deploy to EB.

## Create first snapshot

Since the GeoServer *data_dir* volume has to be created from an existing snapshot, first we will need to create that snapshot by hand.

To do so:

* [Create a new EBS volume](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-creating-volume.html).
* [Attach it to an existing EC2 instance](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-attaching-volume.html).
* [Prepare it](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html). Basically:
```
$ sudo mkfs -t ext4 /dev/<your_device>
$ sudo mkdir /mnt/<your_device>
$ sudo mount /dev/<your_device> /mnt/<your_device>
```
* Copy your initial GeoServer data directory to your mounted volume:
```
(from your local machine)
$ scp -r -i your_ssh_key.pem <your_geoserver_data_dir> ec2-user@<your_ec2_machine>:/tmp

(from the EC2 instance)
$ sudo mv /tmp/<your_geoserver_data_dir>/* /mnt/<your_device>
```

* [Create your first snapshot](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-creating-snapshot.html).

Once you have a proper snapshot you can umount the original volume and destroy it.

## Package configuration files
The EB package should contain three files:
* `Dockerfile`. This should be packaged simply as is.
* `Dockerrun.aws.json`. This contains options to be used for running the container. It can be packaged as is, but can also be configured to, for example, change the ports or the `CATALINA_OPTS` environment variable.
* `.ebextensions/ebs.config`. A configuration file to specify EB how to mount the EBS volume with the GeoServer data directory and from which snapshot.

In order to package it easily, a `package.sh` script is provided. It requires at least the snapshot identifier and the size of the volume to create:
```
$ ./package.sh -s snap-fa2bc934 -g 4
```

The script should create a `geoserver.zip` file ready to be deployed to EB.

## Deploy to Elastic Beanstalk

To deploy, simply use the `geoserver.zip` file in an EB Docker environment.

