[parallel-ITSx]: https://github.com/AAFC-MBB/parallel_itsx
[blackbox-pipeline]: https://github.com/AAFC-MBB/blackbox-pipeline
[accessoryfiles script]: accessoryfiles.sh

# docker-assembly
These are the instructions to build a docker image containing the [blackbox-pipeline].

### Requirements
We packaged [accessoryfiles script] to create a folder called accessoryfiles in the directory it was run. 
 
At first you need to install docker. Please follow the [very good instructions](https://docs.docker.com/installation/) from the Docker project.

After the successful installation, all what you need to do is:

### Installation

Build the image:

```commandline
docker build -t docker-assembly https://github.com/AAFC-MBB/docker-assembly.git
```

You may need to download the required packages for the pipeline to run, you will have to specify their location on execution 

``` commandline
curl -fsSL https://raw.githubusercontent.com/AAFC-MBB/docker-assembly/master/accessoryfiles.sh | bash
```

### Execution

```comandline
docker run -u $(id -u) -v path/to/fastq/data -v path/to/accessory/files:/accessoryfiles ....
```

### Examples

For docker setup using `docker-machine` with openstack and the ubuntu coud image, the default user is ubuntu with uid = 1000. This will alter thhe above `docker run` command to the following

```
docker run -u 1000 ...
```

To use a MiSeq library (fastq files including `SampleSheet.csv``GenerateFASTQRunStatistics.xml` `RunInfo.xml`) stored inside folder labeled `data` in the home folder (`/home/ubuntu/`) of an OpenStack instance:

First you _must_ download and execute the [accessoryfiles script]:

To download the requirements to an `accessoryfiles` folder

``` commandline
curl -fsSL https://raw.githubusercontent.com/AAFC-MBB/docker-assembly/master/accessoryfiles.sh | bash
```
##### On `docker-machine` the command becomes

``` commandline
docker-machine ssh <machine name> "curl -fsSL https://raw.githubusercontent.com/AAFC-MBB/docker-assembly/master/accessoryfiles.sh | bash"
```

Where `<machine name>` is replaced with the name you used to with the `docker-machine create` command


```
docker run -it -u 1000 -v /home/ubuntu/data:/home/ubuntu/data \
-v /home/ubuntu/accessoryfiles:/accessoryfiles docker-assembly /home/ubuntu/data
```
The above command can be broken down into:
* `docker run` the command line instruction run a built container
* `-it` flag for both _interactive_ and _teletype_
  * This will print the progress of the pipeline to the terminal in which it has been executed
* `-u 1000` Explained earlier to run with ubuntu user's permissions
* `-v /home/ubuntu/data:/home/ubuntu/data` to mount the directory containing the MiSeq library
* `-v /home/ubuntu/accessoryfiles:/accessoryfiles` to mount the directory created by the [accessoryfiles script]
  * This folder must mounted to **/accessoryfiles** in the container, this is done on the right side of the colon
* `docker-assembly` is the name of our image we built earlier
* `/home/ubuntu/data` is the folder containing the MiSeq library, this parameter is passed directly to the [blackbox-pipeline]
  * Additional run parameters are specified before the `/home/ubuntu/data` parameter in this example. The options available are found in [blackbox-pipeline] 

### Caveats
`SampleSheet.csv` is needed for the pipeline to run
