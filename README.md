# **Improved and Terraform-Based 3-Tier AWS Project**

This project showcases the design, implementation, and improvement of a **3-Tier Architecture** on AWS, fully automated using **Terraform**. The solution focuses on scalability, security, cost optimization, and operational efficiency while adhering to the **AWS Well-Architected Framework**.

![image](https://github.com/user-attachments/assets/1454a267-92c4-4b18-a5c4-7b916e3ce3cf)
![image](https://github.com/user-attachments/assets/4ec7f97e-6a4f-4bf5-95d5-9c4abaa6a541)
# **AWS Well-Architected Framework**

## **1. Operational Excellence**
- All resources were provisioned with Terraform, ensuring repeatable deployments and consistent configurations across regions. By utilizing input variables and providing defaults, the code is portable and flexible, allowing for seamless changes and scaling.
- Systems Manager was configured for remote access and management of EC2 instances. Deployment tasks such as server configuration were automated, including importing and installing Apache through custom AMIs.

## **2. Security**
- A multi-domain ACM certificate ensures secure SSL/TLS communication between users, CloudFront, and ALB. This guarantees end-to-end encryption for both static and dynamic content.
- Tier 1 EC2 instances are now hosted in private subnets, ensuring they are inaccessible from the public internet. Ingress rules are restricted to allow traffic only from ALB and Systems Manager endpoints. Egress rules permit access to the S3 bucket using AWS prefix list.
- ALB is configured to accept traffic only from CloudFront IP ranges, referencing the AWS CloudFront prefix-managed list. This prevents unauthorized access and ensures only trusted traffic reaches the application layer.
- Requests forwarded to EC2 instances are verified using the X-Origin Verify header, adding an additional layer of security.
- The S3 bucket designated for VPC access is accessed via a VPC Gateway Endpoint, while the S3 bucket used as the CloudFront origin is secured using Origin Access Control (OAC).
- AWS WAF was applied at the CloudFront and ALB layers, protecting the application from common vulnerabilities like SQL injection and cross-site scripting (XSS).

## **3. Reliability**
- Static content is stored in Amazon S3 and delivered through CloudFront for caching, while dynamic content is served via CloudFront and routed to the ALB for processing.
- RDS Multi-AZ configuration ensures data redundancy and high availability. RDS replicas further improve reliability and support read-heavy workloads.

## **4. Performance Efficiency**
- EC2 instances scale automatically with Auto Scaling, ensuring optimal performance during traffic spikes.
- RDS scalability is achieved through read replicas, distributing database workloads and reducing latency.
- Static content is cached at CloudFront edge locations, reducing latency and offloading traffic from backend resources. Dynamic traffic is routed efficiently to ALB and EC2 instances.

## **5. Cost Optimization**
- Removing NAT Gateways was a major cost-saving improvement. It eliminated unnecessary operational expenses, while ensuring private subnets relied on VPC Endpoints for essential services like S3 or Systems Manager.
- Using CloudFront for caching static content from S3 reduces backend load and operational costs. The CDN minimizes repeated requests to the origin servers, optimizing resource usage.
- Used instances powered by Graviton and Savings Plans have been used for EC2 and RDS, with upfront paying, reducing the cost by 65%. [Read more about pricing in this Medium post](https://medium.com/@irinazarzu/aws-cost-estimation-for-an-e-commerce-platform-using-a-3-tier-architecture-49eb6fafd963).

## **6. Sustainability**
- The use of caching for static content, dynamic content routing, and fine-tuned security rules ensures that resources are not overprovisioned, reducing energy consumption.


This project reflects my ability to design, automate, and improve cloud solutions using cutting-edge technologies and industry best practices. Your feedback and suggestions are highly appreciated. Let’s connect and collaborate!
