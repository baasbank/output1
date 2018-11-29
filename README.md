# DEPLOY A LAMP STACK APPLICATION

This repository contains code that automates the deployment of a Linux Apache MySQL PHP (LAMP) stack application. 
The application in this case is [Wordpress](https://wordpress.com).

## TECHNOLOGY STACK
The following technologies were used in the set up:

* [Google Cloud](https://console.cloud.google.com): The application runs on an instance provisioned on Google Cloud.
* [Terraform](https://www.terraform.io/): Terraform is used to provision the instance on Google Cloud, using the Terraform Google Cloud Provider.
* LAMP: LAMP (short for Linux, Apache, MySQL, and PHP) is a popular stack on which Web Applications are built and run.

## PROJECT SETUP

### GOOGLE CLOUD

1. Create an account on [Google Cloud](https://cloud.google.com). Skip this step if you already have an account
2. Go to https://console.cloud.google.com
3. Click on the drop down shown in the image below

![image](https://user-images.githubusercontent.com/26189554/49220833-8afaa380-f3d7-11e8-8d3e-9db09f49d57c.png)

4. From the modal that pops up, copy the project ID of the project you want to create the instance in and paste it somewhere.
For a new Google Cloud account, a default project is automatically created for you. 
You can also create a new project by clicking on the NEW PROJECT button in the top right corner of the screen.

![image](https://user-images.githubusercontent.com/26189554/49221450-77e8d300-f3d9-11e8-86fe-065acf6ab651.png)


### TERRAFORM
