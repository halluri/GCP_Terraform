/*
This project is created as part of providing solution to the challenge below:

**Create a project in GCP using Terraform that includes:
1) A user-managed Vertex AI Notebook.
2) A private Google cloud storage bucket with a retention policy.
3) A BigQuery dataset (empty or with sample data) which includes a configured optimisation that could speed up queries

To create project using terraform module and generate project_Id and feed as input child resources, I need to set up an organization requiring a domain(which I couldn't), hence used a project created from console.

Also, in current code, to load external data with partition enabled, it is giving below error and am currently working on it:

"Error: googleapi: Error 400: Directory URI /bigstore/hp-private-bucket does not contain path to table (/bigstore/hp_private_bucket) as a prefix, which is a requirement., invalidQuery"

Hence commented that configuration code.
*/

