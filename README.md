# Solution

## Create infra in AWS

  1. AWS to run spring boot app and mongo db in docker containers
  2. AWS instance to run jenkins

  ```bash
  $ cd infra
  $ terraform init
  $ terraform apply --auto-approve
  ```

  3. Get ssh key for the instances and store in file

  ```bash
  $ terraform output ssh_private_key > key.pem
  $ chmod 400 key.pem
  ```

  4. Get IP addresses of jenkins and webapp instances using `terraform output`

  5. Copy the key file into jenkins instance using scp.
  6. ssh into jenkins instance and using key file ssh into webapp instance for host key verification.

  ```bash
  $ scp -i key.pem key.pem ubuntu@54.157.9.172:~/
  $ ssh -i key.pem ubuntu@54.157.9.172
    $ sudo su
    $ su jenkins
    $ ssh -i  key.pem ubuntu@100.26.238.127
  ```

## Jenkins Configuration

  1. Configure jenkins with admin credentials.
    ```
    $ ssh -i key.pem ubuntu@54.157.9.172
    $ sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    ```
  2. Install docker pipeline plugin, pipeline maven integration plugin, ssh plugin and Generic webhook trigger plugin.
  3. Configure maven with auto installation with name mymaven in global tool configuration.
  4. Create credentials for docker hub with id 'dockerhub'.
  5. Create ssh private key credentials with ssh key from terraform output with id 'key'.
  6. Configure ssh remote host with username, ip and key in configure system.
  7. Create a pipeline jenkins job with https://github.com/mutyala09/jenkins-aws-challenge.git git repo and main branch.
  8. Configure webhook integrating github and jenkins for automatic pipeline trigger. Configure webhook by going to github repo -> settings -> add webhook and add jenkins generic webhook trigger plugin url with token.
  
## To test

  1. Create User
  
  ```bash
  $ curl -X POST \
  http://100.26.238.127:8080/api/user \
  -d '{
	"firstName": "Test",
	"lastName": "User",
	"email": "test1@test.com",
	"age": 32,
	"address": "US"
  }'
  ```
  
  2. To retrieve all users

  ```bash
  $ curl -X GET \
  http://100.26.238.127:8080/api/users
  ```
