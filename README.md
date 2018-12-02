# DEPLOY A LAMP STACK APPLICATION

This repository contains code that automates the deployment of a Linux Apache MySQL PHP (LAMP) stack application. 
The application in this case is [Wordpress](https://wordpress.com).

## TECHNOLOGY STACK
The following technologies were used in the set up:

* [Google Cloud](https://console.cloud.google.com): The application runs on an instance provisioned on Google Cloud.
* [Terraform](https://www.terraform.io/): Terraform is used to provision the instance on Google Cloud, using the Terraform Google Cloud Provider.
* LAMP: LAMP (short for Linux, Apache, MySQL, and PHP) is a popular stack on which Web Applications are built and run.

## SETUP

### GOOGLE CLOUD

1. Create an account on [Google Cloud](https://cloud.google.com). Skip this step if you already have an account
2. Go to https://console.cloud.google.com
3. Click on the drop down shown in the image below


![image](https://user-images.githubusercontent.com/26189554/49220833-8afaa380-f3d7-11e8-8d3e-9db09f49d57c.png)


4. From the modal that pops up, copy the project ID of the project you want to create the instance in and paste it somewhere.
For a new Google Cloud account, a default project is automatically created for you. 
You can also create a new project by clicking on the NEW PROJECT button in the top right corner of the screen.


![image](https://user-images.githubusercontent.com/26189554/49221450-77e8d300-f3d9-11e8-86fe-065acf6ab651.png)

#### 5. CREATE A SERVICE ACCOUNT KEY
a. Click on the menu icon > APIs and Services > Credentials

![image](https://user-images.githubusercontent.com/26189554/49341115-5130d380-f649-11e8-8ece-6e5d10b86d38.png)

b. Click on Create credentials > Service account key

![image](https://user-images.githubusercontent.com/26189554/49341187-390d8400-f64a-11e8-9485-725f57dbb85d.png)

c. Click the Service account dropdown, then select New service account

![image](https://user-images.githubusercontent.com/26189554/49341240-e7b1c480-f64a-11e8-8a44-3a849a2ce798.png)


d. Give the service account a name. Select Project > Owner for role; this would give that service account full access.
Leave the JSON key type selected then click on the Create button to download the service key.

![image](https://user-images.githubusercontent.com/26189554/49341305-ad94f280-f64b-11e8-9e64-a7ef0eeb59b2.png)

#### 6. ADD SOME PROJECT METADATA
Since the set up is automated, rather than ask for username and password during the setup process, the setup_wordpress.sh script gets that information from the Project Metadata and uses that to set up MySQL. 
Follow the steps below to add metadata:

a. Click on the menu icon > Compute Engine > Metadata

![image](https://user-images.githubusercontent.com/26189554/49341434-8dfec980-f64d-11e8-9c31-0ca5bc81ce1c.png)


b. Create metadata for the following:
  1. database_name
  2. database_password
  3. mysql_root_password
Give them any value you like BUT make sure the keys are exactly as written in the list above because the setup_wordpress.sh script will query for those values using those exact keys.

c. Click on Save to save your changes.

### TERRAFORM

Go [here](https://www.terraform.io/intro/getting-started/install.html) for instructions on how to install Terraform. 
Proceed to the next stage once you have Terraform installed.


### PROJECT BUILD

1. Clone this project if you haven't done so already by running
    ``` CLONE PROJECT
    git clone https://github.com/baasbank/output1.git
    ```
2. Change directory into the terraform folder by running
```CHANGE DIRECTORY
cd output1/terraform
```
3. In the provider section of the `main.tf` file, replace `key.json` in credentials with the path to the Service account key  downloaded during the Google Cloud Setup section above. 
Also, replace `gcloud-project-id` with your Google Cloud Project ID copied in the Google Cloud Setup section above.

4. Make sure you are in the terraform directory, then run the following

```TERRAFORM BUILD
terraform init
terraform plan
terraform apply
```

Running the last command produces a prompt. Enter `yes`.

![image](https://user-images.githubusercontent.com/26189554/49341824-2f3c4e80-f653-11e8-9f69-9367edede29b.png)


5. You get the following message on a successful build
![image](https://user-images.githubusercontent.com/26189554/49341841-6e6a9f80-f653-11e8-9fdf-8643077a76c0.png)

6. Give it a few minutes for the instance creation and setup to complete, then go back to https://console.cloud.google.com

7. Click on the menu icon > Compute Engine > VM instances

![image](https://user-images.githubusercontent.com/26189554/49341983-fdc48280-f654-11e8-9622-65ce1263b582.png)


8. You should see an instance named `lamp-instance`. Click on the external IP address associated with the instance to open it in a browser. Make sure it's using `http` not `https` in the address bar. You should see a page similar to the ones below

![image](https://user-images.githubusercontent.com/26189554/49342036-ce624580-f655-11e8-92f6-6ec12a486f54.png)


![image](https://user-images.githubusercontent.com/26189554/49342041-f2258b80-f655-11e8-97c2-551bc1772990.png)


Follow through with the setup process and voila! you have a new Wordpress site.


## AN ALTERNATIVE TO USING TERRAFORM

To get the project running without terraform, do the following:

1. Follow the steps in the section on Google Cloud Setup above but ignore Step 5 (CREATE A SERVICE ACCOUNT KEY).
2. Click on the menu icon > Compute Engine > Vm instances

![image](https://user-images.githubusercontent.com/26189554/49342147-a07e0080-f657-11e8-98d1-8b1b7c0eb87f.png)


3. Click on CREATE INSTANCE
4
a. Give the instance a name
b. Choose a desired machine type (I used Ubuntu 16.04LTS)


![image](https://user-images.githubusercontent.com/26189554/49342208-a88a7000-f658-11e8-844e-a1758c9d4405.png)



c. Check the `allow HTTP traffic` and the `allow HTTP traffic` boxes
d. Click on `Management, security, disks, networking, sole tenancy` to expand it
e. Copy and paste the content of the `startup_script.sh` file in this repository into the box under `Startup script`

![image](https://user-images.githubusercontent.com/26189554/49342266-cc9a8100-f659-11e8-8442-4ce4a2afcf37.png)

f. Click on Create

5. Give it a few minutes to setup, then click on the associated external IP address and make sure it's using `http` not `https`.

Voila! You should a page similar to the one shown in the previous section.
