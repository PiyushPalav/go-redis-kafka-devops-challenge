# go-redis-kafka-devops-challenge
Demonstrate containerization of golang app using Docker that interacts with Kafka (producer & consumer) + Redis services through Docker compose and automate app deployment on Amazon ECS using AWS CloudFormation.


## Prerequisities
* Docker
* Docker-Compose
* AWS cli / AWS Management console access


## Table of contents
* [Containerizing App using Dockerfile](#containerizing-app-using-dockerfile)
* [GoApp-Redis-Kafka using Docker Compose](#goapp-redis-kafka-using-docker-compose)
* [ECS Deployment using AWS CloudFormation](#ecs-deployment-using-aws-cloudformation)


### Containerizing App using Dockerfile
* Build the docker image using the following command where *`image-tag`* specifies a tag for the image and '.' specifies the current directory where Dockerfile is present.

```shell
docker build -t <image-tag> .
```
* Run the docker image to start the container in detached mode using the following command :

```shell
docker run <image-tag> -d 
```
* Alternatively, run the following command to determine the status of the container :

```shell
docker ps | grep <image-tag>
```


### GoApp-Redis-Kafka using Docker Compose
* Run the following command to validate and view the [docker-compose.yml](https://github.com/PiyushPalav/go-redis-kafka-devops-challenge/blob/master/docker-compose.yml) with all the environment variables substituted.

```shell
docker-compose config
```
* Upon verification, run the following command to build images if any and run all the microservices in multi-containers in detached mode.

```shell
docker-compose up --build -d
```
* [.env](https://github.com/PiyushPalav/go-redis-kafka-devops-challenge/blob/master/.env) file in the current directory is referred to setup the environment variables required by [docker-compose.yml](https://github.com/PiyushPalav/go-redis-kafka-devops-challenge/blob/master/docker-compose.yml).

* `HOSTNAME_COMMAND` in [.env](https://github.com/PiyushPalav/go-redis-kafka-devops-challenge/blob/master/.env) file is used For AWS ECS deployment which uses the Metadata service to get the container host's IP :
```
HOSTNAME_COMMAND: curl http://169.254.169.254/latest/meta-data/public-ipv4
```
Reference: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html

* Push the Docker image built to DockerHub using the following command :

```shell
docker-compose push
```

* Stop containers and remove containers, networks, volumes, and images created by `up` using the following command :

```shell
docker-compose down
```


### ECS Deployment using AWS CloudFormation
* Make sure aws-cli is installed on the machine and configure aws named profile on the same using the following command :

```shell
    $ aws configure --profile <profile-name>
      AWS Access Key ID: MYACCESSKEY
      AWS Secret Access Key: MYSECRETKEY
      Default region name [us-west-2]: us-west-2
      Default output format [None]: json
```
  Make sure the Access keys has sufficient permissions needed to manage AWS CloudFormation and deploy AWS services defined in our [my-go-app-cloudformation-template.yml](https://github.com/PiyushPalav/go-redis-kafka-devops-challenge/blob/master/my-go-app-cloudformation-template.yml) file
  
 * Create an AWS CloudFormation stack with the following command :
 
```shell
    $ aws cloudformation create-stack --stack-name <stackName> \
        --template-body file://my-go-app-cloudformation-template.yml \
        --parameters file://<parameterfile> \
        --enable-termination-protection \
        --profile <profile-name>
```
* Describe the stack once it is created :
 
```shell
    $ aws cloudformation describe-stacks --stack-name <stackName> --profile <profile-name>
```
* Disable the stack-termination prtotection before deleting the stack :
 
```shell
    $ aws cloudformation update-termination-protection --no-enable-termination-protection \
         --stack-name <stackName> --profile <profile-name>
```
 
