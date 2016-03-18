# docker-assembly
Assembly pipeline using Docker and SPAdes

[parallel-ITSx]: https://github.com/AAFC-MBB/parallel_itsx
[blackbox-pipeline]: https://github.com/AAFC-MBB/blackbox-pipeline


### Requirements
To accomodate space concerns, we packaged [accessoryfiles script](accessoryfiles.sh) upon execution of this script, the 
script will create an accessoryfiles folder for the docker container which will be need later
 
Obviously, this will require [docker](http://get.docker.io) 

### Installation

After cloning the git:

```commandline
git clone --recursive https://github.com/AAFC-MBB/docker-assembly
``` 

Build the image:

```commandline
docker build -t docker-assembly docker-assembly/
```

### Execution

```comandline
docker run -u $(id -u) -v path/to/fastq/data -v path/to/accessory/files:/accessoryfiles ....
```

Additional run parameters are specified after the above command. The options available are found in [blackbox-pipeline] 

### Caveats
`Samplesheet.csv` is needed for the pipeline to run