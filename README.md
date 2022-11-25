# Mitigation of OWASP TOP 10 A03:2021 – Injection attacks using F5® Distributed Cloud Platform (F5 XC) #
---
##### The objective of this repo is to automate mititgation of `OWASP TOP 10 A03:2021 – Injection attacks` using F5® Distributed Cloud Platform (F5 XC)
---
**Table of Contents:** <br />
---
&nbsp;&nbsp;&nbsp;&nbsp;•	**[Deployment design](#deployment-design)** <br />
&nbsp;&nbsp;&nbsp;&nbsp;•	**[Prerequisites](#prerequisites)** <br />
&nbsp;&nbsp;&nbsp;&nbsp;•	**[Steps to run the workflow](#steps-to-run-the-workflow)** <br />
&nbsp;&nbsp;&nbsp;&nbsp;•	**[Sample output logs](#sample-output-logs)** <br />
<br />


**Deployment design:**<br />
---
Automation scope is achieved by implementing below steps: <br />
1.	Deploy a demo application in AWS which hosts JuiceShop as vulnerable application. Refer https://owasp.org/www-project-juice-shop/ for more info <br />
2.	Deploy origin pool, WAF and load balancer in F5 XC using above created backend server public IP <br />
3.	Generate and send malicious SQL login payload request to above LB domain using python <br />
4.	Validate if malicious SQL request is blocked by `F5 XC WAF` <br />
5.  Once above tasks are complete CI/CD is destroying all resources <br />
<br />

**Prerequisites:**<br />
---
1.	F5 Distributed Cloud account (F5 XC). Refer https://console.ves.volterra.io/signup/start for account creation <br />
2.	Create a F5 XC API Certificate and APIToken. Please see this page for generation: [https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials](https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials) <br />
3.	Extract the certificate and the key from the .p12: <br />
```
    openssl pkcs12 -info -in certificate.p12 -out private_key.key -nodes -nocerts
    openssl pkcs12 -info -in certificate.p12 -out certificate.cert -nokeys
```
4.	Move the cert and key files to the repository root folder <br />
5.	Generate and replace EC2 instance private and pub files to `application` folder with names `aws-key.pem` and `aws-key.pub`  <br />
6.	Create a namespace in F5 XC console with name `automation-apisec` <br />
7.	Make sure to delegate domain in F5 XC console. Please follow the steps mentioned in doc: [https://docs.cloud.f5.com/docs/how-to/app-networking/domain-delegation](https://docs.cloud.f5.com/docs/how-to/app-networking/domain-delegation) <br />
8.	AWS Account with `Access key` and `Secret key` (if in organisation then need session token). Refer https://aws.amazon.com/resources/create-account/ for account creation <br />
<br />

**Steps to run the workflow:**<br />
---
1.	Make sure your AWS credentials are valid and configured in secrets as below:
![image](https://user-images.githubusercontent.com/6093830/203716693-67fbc040-d835-46d5-94ec-8db8adaa02dc.png) <br />
2.	Check the `variables.tf` and update `api_url`, `domain` fields and needed LB domain name as per your tenant <br />
3.	Open `test_sql_injection.py` file and update your LB domain name in field `pub_dns` <br />
4.	Navigate to `Actions` tab in the repository and select the workflow to execute <br />
&nbsp;&nbsp;&nbsp;&nbsp;• For full end to end testing we have to use `Automation of Injection Attacks` workflow (this also destroys infra) <br />
&nbsp;&nbsp;&nbsp;&nbsp;• For demo purposes and to deploy infra only use `Deploy Infra` job flow <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Note: We have to delete resources manually for this job if not needed.<br />
&nbsp;&nbsp;&nbsp;&nbsp;• You can also execute `Testing Injection Attack` flow if infra is already available and want to run testing validation
5.	Click on `Run workflow` drop-down on the right side of the UI <br />
6.	Select the `main` branch and click `Run workflow` button <br />
7.	Check and expand each job step logs to understand script execution <br />
<br />

**Jobs in the workflow:**<br />
---
&nbsp;&nbsp;&nbsp;&nbsp;• `Deploy ` - Deploys demo application in AWS and also origin pool and load balancer in F5 XC console <br />
&nbsp;&nbsp;&nbsp;&nbsp;• `Testing` - Validates testing using python <br />
&nbsp;&nbsp;&nbsp;&nbsp;• `Destroy` - Destroys both application and resources created in cloud and F5 XC <br />
<br />

**Sample output logs:**<br />
---
Full work-flow output:<br />
![image](https://user-images.githubusercontent.com/6093830/203716947-fe1307e9-37ec-4bf6-91a3-87ea63f67e12.png) <br />
<br />
Deployment Job Output: <br />
![image](https://user-images.githubusercontent.com/6093830/203717036-9234f6f8-97d8-4d9c-bd31-05b92b37b8c0.png) <br />
<br />
Testing Job output: <br />
![image](https://user-images.githubusercontent.com/6093830/203717213-cde2b3bc-8cb4-49cc-9dd4-9fa005ffe921.png) <br />
<br />
Destroy Job Output: <br />
![image](https://user-images.githubusercontent.com/6093830/203717267-af99f749-c4b2-4f9e-86d4-453062d0e487.png) <br />
<br />


*Some of the issues and debugging steps:*<br />
1. If jobs are not getting started then please check if private runner machine is running and actions service is running
2. If unable to create LB, Origin pool or WAF in F5 XC check if your cert and key are valid
3. If terraform is unable to deploy application check if credentials provided in secrets are working
