# Route 53 Redirect
Redirects traffic from one domain to another using Route 53, API Gateway, and Lambda.

### Provisioned Resources

* Lambda to send redirect response
* API Gateway to route traffic to Lambda
* Route 53 Record set to point the from domain to the API Gateway
* SSL Cert for the API Gateway